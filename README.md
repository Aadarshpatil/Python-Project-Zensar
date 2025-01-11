Loan Management System
Overview
The Loan Management System is a web-based application that enables users to apply for loans, view their loan details, and manage repayment schedules. It is built using Python, Flask, Oracle Database, and HTML/CSS/JS for the front-end. This system offers a simple interface for managing loan applications, approvals, repayments, and loan status tracking.

Features
Loan Application: Allows users to apply for loans by selecting loan type and amount.
Loan Approval: Approves or rejects loan applications.
Repayment Processing: Allows users to make repayments and updates the repayment schedule.
Loan Status: Tracks the loan status including Pending, Approved, Disbursed, and Completed.
Database Integration: Integrated with Oracle Database to store and manage loan-related data.
Technology Stack
Backend: Python (Flask)
Frontend: HTML, CSS, JavaScript
Database: Oracle Database
API: REST API (GET, POST methods)
Setup Instructions
Prerequisites
Before setting up the project, ensure that you have the following installed:

Python 3.x
Oracle Database (or Oracle XE)
cx_Oracle library to connect Python to Oracle Database
Flask for the web framework
Installation Steps
Clone the Repository:

Clone the project repository to your local machine:

bash
Copy code
git clone https://github.com/your-username/loan-management-system.git
cd loan-management-system
Install Dependencies:

It's recommended to create a virtual environment for the project:

bash
Copy code
python -m venv venv
source venv/bin/activate  # For macOS/Linux
venv\Scripts\activate  # For Windows
Install the necessary dependencies from requirements.txt:

bash
Copy code
pip install -r requirements.txt
Here's the contents for requirements.txt:

makefile
Copy code
Flask==2.1.2
oracledb==2.2.0
Set Up Oracle Database:

You need an Oracle Database (or Oracle XE) with the following tables:

customers
loan_types
loans
repayment_schedule
payments
You can use the provided SQL scripts to create these tables and insert sample data. Make sure to replace system and root with your own database credentials.

Configure Database Connection:

Open the app.py (or similar file) and configure the database connection settings as per your Oracle DB:

python
Copy code
DB_CONFIG = {
    "host": "localhost",
    "port": 1521,
    "sid": "XE",          # Your Oracle SID or service name
    "user": "system",     # Your Oracle username
    "password": "root"    # Your Oracle password
}
Run the Application:

Start the Flask application using the following command:

bash
Copy code
python app.py
The Flask server will run on http://127.0.0.1:5000/ by default.

Endpoints
1. GET /customers
Fetch all customers from the database.

2. GET /loan_types
Fetch all available loan types from the database.

3. GET /loans/{loan_id}
Fetch details of a specific loan (by loan_id), including customer and loan type info.

4. POST /apply_loan
Apply for a loan by providing the following data:

json
Copy code
{
    "customer_id": 1,
    "loan_type_id": 3,
    "amount": 10000.00
}
5. POST /approve_loan
Approve a pending loan application by providing the loan_id:

json
Copy code
{
    "loan_id": 1
}
6. POST /make_repayment
Make a repayment for a scheduled loan payment by providing the following data:

json
Copy code
{
    "schedule_id": 1,
    "payment_amount": 2000.00
}
Example Usage
Apply for a Loan:

POST /apply_loan

Request Body:
json
Copy code
{
    "customer_id": 1,
    "loan_type_id": 3,
    "amount": 10000.00
}
Approve a Loan:

POST /approve_loan

Request Body:
json
Copy code
{
    "loan_id": 1
}
Make a Repayment:

POST /make_repayment

Request Body:
json
Copy code
{
    "schedule_id": 1,
    "payment_amount": 2000.00
}
Contributing
We welcome contributions! To contribute:

Fork the repository.
Make changes in your fork.
Submit a pull request.
Please follow coding standards and ensure that your contributions are well-documented and tested.

License
This project is licensed under the MIT License - see the LICENSE file for details.

Acknowledgements
Flask for the web framework.
cx_Oracle for database integration with Oracle.
Oracle Database for storing and managing data.
