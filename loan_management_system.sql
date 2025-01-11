CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    contact_number VARCHAR2(15),
    address VARCHAR2(200)
);


    INSERT INTO customers (customer_id, name, contact_number, address) VALUES (1, 'John Doe', '123-456-7890', '123 Elm Street, Springfield, IL');
    INSERT INTO customers (customer_id, name, contact_number, address) VALUES (2, 'Jane Smith', '987-654-3210', '456 Oak Avenue, Chicago, IL');
    INSERT INTO customers (customer_id, name, contact_number, address) VALUES (3, 'Samuel Green', '555-123-4567', '789 Maple Road, Joliet, IL');
    INSERT INTO customers (customer_id, name, contact_number, address) VALUES (4, 'Laura White', '333-222-1111', '101 Pine Circle, Peoria, IL');
    INSERT INTO customers (customer_id, name, contact_number, address) VALUES (5, 'James Brown', '444-555-6666', '202 Cedar Lane, Urbana, IL');
    INSERT INTO customers (customer_id, name, contact_number, address) VALUES (6, 'Sophia Taylor', '555-777-8888', '303 Birch Blvd, Champaign, IL');
    INSERT INTO customers (customer_id, name, contact_number, address) VALUES (7, 'Daniel Black', '666-888-9999', '404 Oakwood Drive, Carbondale, IL');
    INSERT INTO customers (customer_id, name, contact_number, address) VALUES (8, 'Olivia Clark', '777-999-0000', '505 Walnut Place, Bloomington, IL');
    INSERT INTO customers (customer_id, name, contact_number, address) VALUES (9, 'Ethan Harris', '888-000-1111', '606 Pine Grove, Normal, IL');
    INSERT INTO customers (customer_id, name, contact_number, address) VALUES (10, 'Amelia Lewis', '999-111-2222', '707 Maple Avenue, Rockford, IL');
    

SELECT * FROM customers;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE loan_types (
    loan_type_id NUMBER PRIMARY KEY,
    loan_type_name VARCHAR2(100),
    interest_rate NUMBER(5,2)  
);

    INSERT INTO loan_types (loan_type_id, loan_type_name, interest_rate) VALUES (1, 'Personal Loan', 8.50);
    INSERT INTO loan_types (loan_type_id, loan_type_name, interest_rate) VALUES (2, 'Home Loan', 4.75);
    INSERT INTO loan_types (loan_type_id, loan_type_name, interest_rate) VALUES (3, 'Car Loan', 6.00);
    INSERT INTO loan_types (loan_type_id, loan_type_name, interest_rate) VALUES (4, 'Student Loan', 5.25);
    INSERT INTO loan_types (loan_type_id, loan_type_name, interest_rate) VALUES (5, 'Business Loan', 7.80);
    
SELECT * FROM loan_types;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE loans (
    loan_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    loan_type_id NUMBER,
    amount NUMBER(15, 2),
    approval_status VARCHAR2(20),  
    disbursement_date DATE,
    repayment_due_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (loan_type_id) REFERENCES loan_types(loan_type_id)
);

INSERT INTO loans (loan_id, customer_id, loan_type_id, amount, approval_status, disbursement_date, repayment_due_date)
    VALUES (1, 1, 3, 20000.00, 'Approved', TO_DATE('2025-01-10', 'YYYY-MM-DD'), TO_DATE('2026-01-10', 'YYYY-MM-DD'));

    INSERT INTO loans (loan_id, customer_id, loan_type_id, amount, approval_status, disbursement_date, repayment_due_date)
    VALUES (2, 2, 1, 5000.00, 'Pending', NULL, NULL);

    INSERT INTO loans (loan_id, customer_id, loan_type_id, amount, approval_status, disbursement_date, repayment_due_date)
    VALUES (3, 3, 5, 15000.00, 'Disbursed', TO_DATE('2025-01-05', 'YYYY-MM-DD'), TO_DATE('2026-01-05', 'YYYY-MM-DD'));
    
SELECT * FROM loans;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE repayment_schedule (
    schedule_id NUMBER PRIMARY KEY,
    loan_id NUMBER,
    repayment_date DATE,
    amount_due NUMBER(15, 2),
    status VARCHAR2(20),  
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

INSERT INTO repayment_schedule (schedule_id, loan_id, repayment_date, amount_due, status) 
    VALUES (1, 1, TO_DATE('2025-02-10', 'YYYY-MM-DD'), 2000.00, 'Pending');
    
    INSERT INTO repayment_schedule (schedule_id, loan_id, repayment_date, amount_due, status) 
    VALUES (2, 1, TO_DATE('2025-03-10', 'YYYY-MM-DD'), 2000.00, 'Paid');
    
    INSERT INTO repayment_schedule (schedule_id, loan_id, repayment_date, amount_due, status) 
    VALUES (3, 1, TO_DATE('2025-04-10', 'YYYY-MM-DD'), 2000.00, 'Pending');

    INSERT INTO repayment_schedule (schedule_id, loan_id, repayment_date, amount_due, status) 
    VALUES (4, 2, TO_DATE('2025-02-15', 'YYYY-MM-DD'), 500.00, 'Pending');
    
    INSERT INTO repayment_schedule (schedule_id, loan_id, repayment_date, amount_due, status) 
    VALUES (5, 2, TO_DATE('2025-03-15', 'YYYY-MM-DD'), 500.00, 'Pending');
    
SELECT * FROM repayment_schedule;
----------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE payments (
    payment_id NUMBER PRIMARY KEY,
    repayment_schedule_id INT,
    payment_date DATE,
    payment_amount NUMBER(15, 2),
    FOREIGN KEY (repayment_schedule_id) REFERENCES repayment_schedule(schedule_id)
);

INSERT INTO payments (payment_id, repayment_schedule_id, payment_date, payment_amount)
    VALUES (1, 1, TO_DATE('2025-02-10', 'YYYY-MM-DD'), 2000.00);
    
    INSERT INTO payments (payment_id, repayment_schedule_id, payment_date, payment_amount)
    VALUES (2, 2, TO_DATE('2025-03-10', 'YYYY-MM-DD'), 2000.00);

    INSERT INTO payments (payment_id, repayment_schedule_id, payment_date, payment_amount)
    VALUES (3, 3, TO_DATE('2025-04-10', 'YYYY-MM-DD'), 2000.00);

    INSERT INTO payments (payment_id, repayment_schedule_id, payment_date, payment_amount)
    VALUES (4, 4, TO_DATE('2025-02-15', 'YYYY-MM-DD'), 500.00);

    INSERT INTO payments (payment_id, repayment_schedule_id, payment_date, payment_amount)
    VALUES (5, 5, TO_DATE('2025-03-15', 'YYYY-MM-DD'), 500.00);

SELECT * FROM payments;
---------------------------------------------------------------------------------------------------------------------------------------------------
CREATE SEQUENCE loans_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
----------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE apply_for_loan (
    p_customer_id INT,
    p_loan_type_id INT,
    p_amount NUMBER
) AS
BEGIN
    INSERT INTO loans (loan_id, customer_id, loan_type_id, amount, approval_status, disbursement_date, repayment_due_date)
    VALUES (loans_seq.NEXTVAL, p_customer_id, p_loan_type_id, p_amount, 'Pending', NULL, NULL);
    
    DBMS_OUTPUT.PUT_LINE('Loan application submitted successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred during loan application: ' || SQLERRM);
END apply_for_loan;
----------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE approve_loan (
    p_loan_id INT
) AS
BEGIN
    UPDATE loans
    SET approval_status = 'Approved', disbursement_date = SYSDATE
    WHERE loan_id = p_loan_id AND approval_status = 'Pending';
    
    DBMS_OUTPUT.PUT_LINE('Loan approved and disbursed.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred while approving loan: ' || SQLERRM);
END approve_loan;
--------------------------------------------------------------------------------------------------------------------------------------
CREATE SEQUENCE payments_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
---------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE make_repayment (
    p_schedule_id INT,
    p_payment_amount NUMBER
) AS
BEGIN
    UPDATE repayment_schedule
    SET status = 'Paid'
    WHERE schedule_id = p_schedule_id AND amount_due = p_payment_amount AND status = 'Pending';
    
    INSERT INTO payments (payment_id, repayment_schedule_id, payment_date, payment_amount)
    VALUES (payments_seq.NEXTVAL, p_schedule_id, SYSDATE, p_payment_amount);
    
    DBMS_OUTPUT.PUT_LINE('Repayment processed successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred during repayment: ' || SQLERRM);
END make_repayment;
-------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER update_loan_status
AFTER UPDATE OF status ON repayment_schedule
FOR EACH ROW
BEGIN
    DECLARE
        total_due NUMBER;
        total_paid NUMBER;
    BEGIN
        SELECT SUM(amount_due) INTO total_due FROM repayment_schedule WHERE loan_id = :NEW.loan_id;
        SELECT SUM(payment_amount) INTO total_paid FROM payments WHERE repayment_schedule_id = :NEW.schedule_id;
        
        IF total_due = total_paid THEN
            UPDATE loans
            SET approval_status = 'Completed'
            WHERE loan_id = :NEW.loan_id;
        END IF;
    END;
END;

