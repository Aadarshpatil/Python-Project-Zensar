import json
from http.server import BaseHTTPRequestHandler, HTTPServer
import oracledb
from datetime import date, datetime
from decimal import Decimal

# Database Configuration
DB_CONFIG = {
    "host": "localhost",  # Replace with your Oracle DB host
    "port": 1521,         # Default Oracle port
    "sid": "XE",          # Your Oracle SID (or service name)
    "user": "system",     # Replace with your Oracle username
    "password": "root"    # Replace with your Oracle password
}

# Get a database connection
def get_db_connection():
    dsn = oracledb.makedsn(DB_CONFIG["host"], DB_CONFIG["port"], DB_CONFIG["sid"])
    connection = oracledb.connect(user=DB_CONFIG["user"], password=DB_CONFIG["password"], dsn=dsn)
    return connection

# Custom JSON encoder to handle special data types
class CustomJSONEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, (date, datetime)):
            return obj.isoformat()  # Convert to ISO 8601 string
        if isinstance(obj, Decimal):
            return float(obj)  # Convert Decimal to float
        return super().default(obj)

# Request Handler
class RequestHandler(BaseHTTPRequestHandler):
    def _set_headers(self):
        self.send_header("Access-Control-Allow-Origin", "*")  # Allow all origins
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")

    def do_OPTIONS(self):
        self.send_response(200)
        self._set_headers()
        self.end_headers()

    def do_GET(self):
        try:
            conn = get_db_connection()
            cursor = conn.cursor()

            # Endpoint to fetch all customers
            if self.path == "/customers":
                cursor.execute("SELECT * FROM customers")
                result = cursor.fetchall()
            
            # Endpoint to fetch loan types
            elif self.path == "/loan_types":
                cursor.execute("SELECT * FROM loan_types")
                result = cursor.fetchall()

            # Endpoint to fetch loans (with customer and loan type info)
            elif self.path.startswith("/loans/"):
                loan_id = self.path.split("/")[-1]
                cursor.execute("""
                    SELECT l.loan_id, c.name AS customer_name, lt.loan_type_name, l.amount, l.approval_status, l.disbursement_date
                    FROM loans l
                    JOIN customers c ON l.customer_id = c.customer_id
                    JOIN loan_types lt ON l.loan_type_id = lt.loan_type_id
                    WHERE l.loan_id = :loan_id
                """, {"loan_id": loan_id})
                result = cursor.fetchone()

            # Default response for unknown endpoints
            else:
                result = {"message": "Endpoint not found"}
            
            response_body = json.dumps(result, cls=CustomJSONEncoder)
            self.send_response(200)
            self._set_headers()
            self.end_headers()
            self.wfile.write(response_body.encode())

        except Exception as e:
            self.send_error(500, str(e))
        finally:
            cursor.close()
            conn.close()

    def do_POST(self):
        try:
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            data = json.loads(post_data.decode('utf-8'))

            conn = get_db_connection()
            cursor = conn.cursor()

            # Endpoint to apply for a loan
            if self.path == "/apply_loan":
                sql = """
                    INSERT INTO loans (loan_id, customer_id, loan_type_id, amount, approval_status, disbursement_date, repayment_due_date)
                    VALUES (loans_seq.NEXTVAL, :customer_id, :loan_type_id, :amount, 'Pending', NULL, NULL)
                """
                cursor.execute(sql, {
                    "customer_id": data['customer_id'],
                    "loan_type_id": data['loan_type_id'],
                    "amount": data['amount']
                })
                conn.commit()
                
                self.send_response(201)
                self._set_headers()
                self.end_headers()
                response = {"message": "Loan application submitted successfully"}
                self.wfile.write(json.dumps(response).encode())

            # Endpoint to approve a loan
            elif self.path == "/approve_loan":
                loan_id = data['loan_id']
                sql = """
                    UPDATE loans
                    SET approval_status = 'Approved', disbursement_date = SYSDATE
                    WHERE loan_id = :loan_id AND approval_status = 'Pending'
                """
                cursor.execute(sql, {"loan_id": loan_id})
                conn.commit()

                self.send_response(200)
                self._set_headers()
                self.end_headers()
                response = {"message": "Loan approved successfully"}
                self.wfile.write(json.dumps(response).encode())

            # Endpoint to make a repayment
            elif self.path == "/make_repayment":
                schedule_id = data['schedule_id']
                payment_amount = data['payment_amount']
                sql = """
                    UPDATE repayment_schedule
                    SET status = 'Paid'
                    WHERE schedule_id = :schedule_id AND amount_due = :payment_amount AND status = 'Pending'
                """
                cursor.execute(sql, {"schedule_id": schedule_id, "payment_amount": payment_amount})

                sql_insert_payment = """
                    INSERT INTO payments (payment_id, repayment_schedule_id, payment_date, payment_amount)
                    VALUES (payments_seq.NEXTVAL, :schedule_id, SYSDATE, :payment_amount)
                """
                cursor.execute(sql_insert_payment, {"schedule_id": schedule_id, "payment_amount": payment_amount})
                conn.commit()

                self.send_response(200)
                self._set_headers()
                self.end_headers()
                response = {"message": "Repayment processed successfully"}
                self.wfile.write(json.dumps(response).encode())

            else:
                self.send_error(400, "Invalid path")

        except Exception as e:
            self.send_error(500, f"Server error: {str(e)}")
        finally:
            cursor.close()
            conn.close()

# Run the HTTP server
def run(server_class=HTTPServer, handler_class=RequestHandler, port=8080):
    server_address = ("", port)
    httpd = server_class(server_address, handler_class)
    print(f"Server started on port {port}")
    httpd.serve_forever()

if __name__ == "__main__":
    run()
