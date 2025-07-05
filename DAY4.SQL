/**************************************/
/* SECTION 1: INSERTING DATA (TASKS 1-10) */
/**************************************/

-- Task 1: Create Departments table
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) UNIQUE NOT NULL
);

-- Task 2: Insert 3 departments
INSERT INTO Departments VALUES 
(1, 'HR'),
(2, 'Finance'),
(3, 'IT');

-- Task 3: Create Employees table
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department INT,
    salary DECIMAL(10,2),
    FOREIGN KEY (department) REFERENCES Departments(dept_id)
);

-- Task 4: Insert 5 employees
INSERT INTO Employees VALUES
(101, 'John Smith', 1, 50000.00),
(102, 'Jane Doe', 2, 60000.00),
(103, 'Robert Johnson', 3, 75000.00),
(104, 'Emily Williams', 1, 55000.00),
(105, 'Michael Brown', 3, 80000.00);

-- Task 5: Insert employee with only emp_id and name
INSERT INTO Employees (emp_id, name) VALUES (106, 'Sarah Davis');

-- Task 6: Insert employee with columns in different order
INSERT INTO Employees (name, emp_id, salary, department) 
VALUES ('David Wilson', 107, 65000.00, 2);

-- Task 7: Insert multiple employees in one query
INSERT INTO Employees VALUES
(108, 'Lisa Taylor', 2, 58000.00),
(109, 'James Anderson', 3, 72000.00),
(110, 'Jennifer Lee', 1, 53000.00);

-- Task 8: Insert employee without salary (NULL)
INSERT INTO Employees (emp_id, name, department) VALUES (111, 'Thomas Moore', 2);

-- Task 9: Attempt to insert employee with non-existent department (should fail)
-- INSERT INTO Employees VALUES (112, 'Invalid Dept', 99, 40000.00);

-- Task 10: Attempt duplicate emp_id (should fail)
-- INSERT INTO Employees VALUES (101, 'Duplicate ID', 1, 45000.00);

-- Task 11: Attempt duplicate department name (should fail)
-- INSERT INTO Departments VALUES (4, 'HR');

-- Task 12: Create Attendance table with defaults
CREATE TABLE Attendance (
    attendance_id INT PRIMARY KEY,
    emp_id INT,
    date DATE DEFAULT GETDATE(),
    status VARCHAR(20) DEFAULT 'Present',
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

INSERT INTO Attendance (attendance_id, emp_id) VALUES (1, 101);

/**************************************/
/* SECTION 2: UPDATING DATA (TASKS 11-20) */
/**************************************/

-- Task 11: Update HR salaries (+5000)
UPDATE Employees
SET salary = salary + 5000
WHERE department = (SELECT dept_id FROM Departments WHERE dept_name = 'HR');

-- Task 12: Update department of employee 102 to Finance
UPDATE Employees
SET department = (SELECT dept_id FROM Departments WHERE dept_name = 'Finance')
WHERE emp_id = 102;

-- Task 13: Update salaries < 40000 to 45000
UPDATE Employees
SET salary = 45000
WHERE salary < 40000;

-- Task 14: Change name of employee 103
UPDATE Employees
SET name = 'Michael Scott'
WHERE emp_id = 103;

-- Task 15: Increase IT salaries by 10%
UPDATE Employees
SET salary = salary * 1.10
WHERE department = (SELECT dept_id FROM Departments WHERE dept_name = 'IT');

-- Task 16: Set salary to NULL for Testing (if Testing existed)
-- UPDATE Employees SET salary = NULL WHERE department = 
-- (SELECT dept_id FROM Departments WHERE dept_name = 'Testing');

-- Task 17: Update NULL departments to Admin
UPDATE Employees
SET department = (SELECT dept_id FROM Departments WHERE dept_name = 'HR')
WHERE department IS NULL;

-- Task 18: Update multiple columns
UPDATE Employees
SET department = 3, salary = 85000
WHERE emp_id = 105;

-- Task 19: Update salaries based on subquery (above average)
UPDATE Employees
SET salary = salary * 1.05
WHERE salary > (SELECT AVG(salary) FROM Employees);

-- Task 20: Add bonus column and set to 5% of salary
ALTER TABLE Employees ADD bonus DECIMAL(10,2);

UPDATE Employees
SET bonus = salary * 0.05;

/**************************************/
/* SECTION 3: DELETING DATA (TASKS 21-30) */
/**************************************/

-- Task 21: Delete employee with emp_id = 102
DELETE FROM Employees WHERE emp_id = 102;

-- Task 22: Delete all Finance employees
DELETE FROM Employees 
WHERE department = (SELECT dept_id FROM Departments WHERE dept_name = 'Finance');

-- Task 23: Delete employees with salary < 30000
DELETE FROM Employees WHERE salary < 30000;

-- Task 24: Delete all employees (without WHERE)
-- DELETE FROM Employees;

-- Task 25: Attempt to delete referenced department (should fail)
-- DELETE FROM Departments WHERE dept_id = 1;

-- Task 26: Add join_date column for next task
ALTER TABLE Employees ADD join_date DATE DEFAULT '2023-01-01';

-- Task 27: Delete employees joined before 2023
DELETE FROM Employees WHERE join_date < '2023-01-01';

-- Task 28: Delete all except HR
DELETE FROM Employees 
WHERE department NOT IN (SELECT dept_id FROM Departments WHERE dept_name = 'HR');

-- Task 29: Delete NULL department employees
DELETE FROM Employees WHERE department IS NULL;

-- Task 30: Delete and reinsert record
BEGIN TRANSACTION;
DECLARE @emp_id INT = 101;
DECLARE @name VARCHAR(100);
DECLARE @dept INT;
DECLARE @sal DECIMAL(10,2);

SELECT @name = name, @dept = department, @sal = salary 
FROM Employees WHERE emp_id = @emp_id;

DELETE FROM Employees WHERE emp_id = @emp_id;

INSERT INTO Employees VALUES (@emp_id, @name, @dept, @sal);
COMMIT;

/**************************************/
/* SECTION 4: CONSTRAINTS & DATA INTEGRITY (TASKS 31-40) */
/**************************************/

-- Task 31: Already created with PRIMARY KEY and UNIQUE

-- Task 32: Already created with NOT NULL on name and salary

-- Task 33: Add CHECK constraint for salary
ALTER TABLE Employees
ADD CONSTRAINT CHK_Salary CHECK (salary > 3000);

-- Task 34: Already created FOREIGN KEY

-- Task 35: Test NOT NULL constraint
-- INSERT INTO Employees (emp_id, department) VALUES (112, 1);

-- Task 36: Test CHECK constraint
-- INSERT INTO Employees VALUES (112, 'Low Salary', 1, 2000.00);

-- Task 37: Test UNIQUE constraint
-- INSERT INTO Departments VALUES (4, 'HR');

-- Task 38: Test FOREIGN KEY constraint
-- INSERT INTO Employees VALUES (112, 'Invalid Dept', 99, 40000.00);

-- Task 39: Add new constraint
ALTER TABLE Employees
ADD CONSTRAINT CHK_NameLength CHECK (LEN(name) > 2);

-- Task 40: Drop constraint
ALTER TABLE Employees
DROP CONSTRAINT CHK_NameLength;

/**************************************/
/* SECTION 5: TRANSACTIONS & ACID PROPERTIES (TASKS 41-50) */
/**************************************/

-- Task 41: Transaction with two inserts
BEGIN TRANSACTION;
INSERT INTO Employees VALUES (112, 'Alice Johnson', 1, 52000.00);
INSERT INTO Employees VALUES (113, 'Bob Smith', 2, 58000.00);
COMMIT;

-- Task 42: Transaction with rollback
BEGIN TRANSACTION;
UPDATE Employees SET salary = salary * 1.10 WHERE emp_id = 101;
SELECT * FROM Employees WHERE emp_id = 101; -- Verify change
ROLLBACK;
SELECT * FROM Employees WHERE emp_id = 101; -- Verify rollback

-- Task 43: SAVEPOINT example
BEGIN TRANSACTION;
INSERT INTO Employees VALUES (114, 'Carol Williams', 3, 62000.00);
SAVEPOINT AfterInsert;
UPDATE Employees SET salary = 65000 WHERE emp_id = 114;
ROLLBACK TRANSACTION AfterInsert;
COMMIT;

-- Task 44: Delete transaction
BEGIN TRANSACTION;
DELETE FROM Employees WHERE emp_id = 112;
DELETE FROM Employees WHERE emp_id = 113;
COMMIT;

-- Task 45: Multiple savepoints
BEGIN TRANSACTION;
UPDATE Employees SET salary = 60000 WHERE emp_id = 101;
SAVEPOINT SP1;
UPDATE Employees SET department = 2 WHERE emp_id = 101;
SAVEPOINT SP2;
UPDATE Employees SET name = 'John Updated' WHERE emp_id = 101;
ROLLBACK TRANSACTION SP1;
COMMIT;

-- Task 46: Isolation test would require two separate sessions

-- Task 47: Transaction with simulated error
BEGIN TRANSACTION;
INSERT INTO Employees VALUES (115, 'Valid Employee', 1, 45000.00);
-- Simulate error
DECLARE @error INT = 1;
IF @error = 1
BEGIN
    ROLLBACK;
    PRINT 'Transaction rolled back due to error';
END
ELSE
BEGIN
    COMMIT;
END

-- Task 48: Update all departments
BEGIN TRANSACTION;
UPDATE Departments SET dept_name = dept_name + ' Department';
-- Verify changes
SELECT * FROM Departments;
-- Then either COMMIT or ROLLBACK
COMMIT;

-- Task 49: Partial failure simulation
BEGIN TRANSACTION;
INSERT INTO Employees VALUES (115, 'Good Employee', 1, 45000.00);
-- This will fail due to duplicate ID
-- INSERT INTO Employees VALUES (101, 'Duplicate ID', 1, 45000.00);
-- Check if any errors occurred
IF @@ERROR <> 0
BEGIN
    ROLLBACK;
    PRINT 'Transaction rolled back due to constraint violation';
END
ELSE
BEGIN
    COMMIT;
END

-- Task 50: Department transfer with logging
CREATE TABLE EmployeeLog (
    log_id INT PRIMARY KEY IDENTITY,
    emp_id INT,
    old_dept INT,
    new_dept INT,
    change_date DATETIME DEFAULT GETDATE()
);

BEGIN TRANSACTION;
DECLARE @oldDept INT;
SELECT @oldDept = department FROM Employees WHERE emp_id = 101;

UPDATE Employees 
SET department = 3 
WHERE emp_id = 101;

INSERT INTO EmployeeLog (emp_id, old_dept, new_dept)
VALUES (101, @oldDept, 3);

COMMIT;

/**************************************/
/* MINI PROJECT 1: EMPLOYEE MANAGEMENT SYSTEM */
/**************************************/

-- Create enhanced tables
CREATE TABLE EnhancedDepartments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) UNIQUE NOT NULL,
    location VARCHAR(100)
);

CREATE TABLE EnhancedEmployees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    department_id INT,
    salary DECIMAL(10,2) NOT NULL CHECK (salary > 3000),
    join_date DATE DEFAULT GETDATE(),
    FOREIGN KEY (department_id) REFERENCES EnhancedDepartments(dept_id)
);

-- Insert data
INSERT INTO EnhancedDepartments VALUES
(1, 'Human Resources', 'Floor 1'),
(2, 'Finance', 'Floor 2'),
(3, 'Information Technology', 'Floor 3');

INSERT INTO EnhancedEmployees VALUES
(101, 'John Smith', 'john.smith@company.com', 1, 50000.00, '2022-01-15'),
(102, 'Jane Doe', 'jane.doe@company.com', 2, 60000.00, '2021-05-20'),
(103, 'Robert Johnson', 'robert.j@company.com', 3, 75000.00, '2020-11-10');

-- Hiring multiple employees in transaction
BEGIN TRANSACTION;
SAVEPOINT StartHiring;

INSERT INTO EnhancedEmployees VALUES
(104, 'Emily Williams', 'emily.w@company.com', 1, 55000.00, GETDATE()),
(105, 'Michael Brown', 'michael.b@company.com', 3, 80000.00, GETDATE());

-- Simulate background check failure for one candidate
DECLARE @backgroundCheck BIT = 0; -- 0 means failed

IF @backgroundCheck = 0
BEGIN
    ROLLBACK TRANSACTION StartHiring;
    PRINT 'Hiring rolled back due to failed background check';
END
ELSE
BEGIN
    COMMIT TRANSACTION;
    PRINT 'New employees hired successfully';
END

-- Department transfer with validation
BEGIN TRANSACTION;
DECLARE @currentDept INT;
SELECT @currentDept = department_id FROM EnhancedEmployees WHERE emp_id = 101;

UPDATE EnhancedEmployees
SET department_id = 3
WHERE emp_id = 101;

-- Verify headcount in new department
DECLARE @newDeptCount INT;
SELECT @newDeptCount = COUNT(*) FROM EnhancedEmployees WHERE department_id = 3;

IF @newDeptCount > 5 -- Assuming max 5 per department
BEGIN
    ROLLBACK;
    PRINT 'Transfer failed - department at capacity';
END
ELSE
BEGIN
    COMMIT;
    PRINT 'Employee transferred successfully';
END

/**************************************/
/* MINI PROJECT 2: STUDENT ENROLLMENT & FEE TRACKER */
/**************************************/

CREATE DATABASE StudentEnrollment;
USE StudentEnrollment;

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    enrollment_date DATE DEFAULT GETDATE()
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    credits INT CHECK (credits > 0),
    fee DECIMAL(10,2) CHECK (fee >= 0)
);

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE DEFAULT GETDATE(),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    UNIQUE (student_id, course_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    student_id INT,
    amount DECIMAL(10,2) CHECK (amount >= 0),
    payment_date DATE DEFAULT GETDATE(),
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

-- Insert data
INSERT INTO Students VALUES
(1001, 'Alice Johnson', 'alice.j@school.edu', '2023-09-01'),
(1002, 'Bob Smith', 'bob.s@school.edu', '2023-09-01'),
(1003, 'Carol Williams', 'carol.w@school.edu', '2023-09-01');

INSERT INTO Courses VALUES
(101, 'Introduction to Computer Science', 3, 1200.00),
(102, 'Calculus I', 4, 1500.00),
(103, 'English Literature', 3, 1100.00);

INSERT INTO Enrollments VALUES
(1, 1001, 101, '2023-09-05'),
(2, 1001, 102, '2023-09-05'),
(3, 1002, 101, '2023-09-06'),
(4, 1003, 103, '2023-09-06');

-- Fee payment with rollback on error
BEGIN TRANSACTION;
SAVEPOINT BeforePayment;

-- Record payment
INSERT INTO Payments VALUES (1, 1001, 1200.00, GETDATE());

-- Update enrollment status (simulated)
-- In a real system, you might have a status column to update

-- Simulate payment processing error
DECLARE @paymentProcessed BIT = 0;

IF @paymentProcessed = 0
BEGIN
    ROLLBACK TRANSACTION BeforePayment;
    PRINT 'Payment failed - transaction rolled back';
END
ELSE
BEGIN
    COMMIT TRANSACTION;
    PRINT 'Payment processed successfully';
END

-- Student dropping course
BEGIN TRANSACTION;
DELETE FROM Enrollments 
WHERE student_id = 1001 AND course_id = 102;

-- Refund processing would go here
COMMIT;

/**************************************/
/* MINI PROJECT 3: HOSPITAL PATIENT RECORDS */
/**************************************/

CREATE DATABASE HospitalRecords;
USE HospitalRecords;

CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dob DATE,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    insurance VARCHAR(50)
);

CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialty VARCHAR(50),
    license_number VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATETIME,
    status VARCHAR(20) DEFAULT 'Scheduled',
    diagnosis VARCHAR(200),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    CHECK (appointment_date > GETDATE())
);

-- Insert data
INSERT INTO Patients VALUES
(1, 'David Brown', '1985-07-15', 'david.b@email.com', '555-1001', 'Blue Cross'),
(2, 'Sarah Wilson', '1990-11-22', 'sarah.w@email.com', '555-1002', 'Aetna');

INSERT INTO Doctors VALUES
(101, 'Dr. James Smith', 'Cardiology', 'MD123456', 'james.s@hospital.com'),
(102, 'Dr. Emily Davis', 'Pediatrics', 'MD654321', 'emily.d@hospital.com');

INSERT INTO Appointments VALUES
(1, 1, 101, '2023-12-15 09:00:00', 'Scheduled', NULL),
(2, 2, 102, '2023-12-16 10:30:00', 'Scheduled', NULL);

-- Patient registration with validation
BEGIN TRANSACTION;
DECLARE @newPatientId INT = 3;

INSERT INTO Patients VALUES
(@newPatientId, 'Robert Johnson', '1978-03-10', 'robert.j@email.com', '555-1003', 'Medicare');

-- Verify email uniqueness
IF EXISTS (SELECT 1 FROM Patients WHERE email = 'robert.j@email.com' AND patient_id <> @newPatientId)
BEGIN
    ROLLBACK;
    PRINT 'Registration failed - email already in use';
END
ELSE
BEGIN
    COMMIT;
    PRINT 'Patient registered successfully';
END

-- Complete appointment
BEGIN TRANSACTION;
UPDATE Appointments 
SET status = 'Completed', 
    diagnosis = 'Routine checkup - no issues found'
WHERE appointment_id = 1;

-- Add follow-up appointment
INSERT INTO Appointments VALUES
(3, 1, 101, '2024-03-15 09:00:00', 'Scheduled', NULL);

COMMIT;

/**************************************/
/* MINI PROJECT 4: E-COMMERCE ORDER MANAGER */
/**************************************/

CREATE DATABASE ECommerce;
USE ECommerce;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    join_date DATE DEFAULT GETDATE()
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) CHECK (price >= 0),
    stock_quantity INT CHECK (stock_quantity >= 0),
    sku VARCHAR(20) UNIQUE
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATETIME DEFAULT GETDATE(),
    status VARCHAR(20) DEFAULT 'Processing',
    total_amount DECIMAL(12,2) CHECK (total_amount >= 0),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT CHECK (quantity > 0),
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Insert data
INSERT INTO Customers VALUES
(1, 'John Smith', 'john.s@email.com', '2023-01-15'),
(2, 'Emily Davis', 'emily.d@email.com', '2023-02-20');

INSERT INTO Products VALUES
(101, 'Wireless Headphones', 99.99, 50, 'WH-1001'),
(102, 'Smartphone Case', 19.99, 100, 'SC-2001'),
(103, 'Bluetooth Speaker', 59.99, 30, 'BS-3001');

-- Complete order transaction
BEGIN TRANSACTION;
DECLARE @newOrderId INT = 1001;

-- Create order
INSERT INTO Orders (order_id, customer_id, total_amount)
VALUES (@newOrderId, 1, 0); -- Temporary total

-- Add items
INSERT INTO OrderItems VALUES
(1, @newOrderId, 101, 1, (SELECT price FROM Products WHERE product_id = 101)),
(2, @newOrderId, 102, 2, (SELECT price FROM Products WHERE product_id = 102));

-- Update order total
UPDATE Orders
SET total_amount = (
    SELECT SUM(quantity * unit_price) 
    FROM OrderItems 
    WHERE order_id = @newOrderId
)
WHERE order_id = @newOrderId;

-- Update product stock
UPDATE Products
SET stock_quantity = stock_quantity - (
    SELECT quantity 
    FROM OrderItems 
    WHERE product_id = Products.product_id AND order_id = @newOrderId
)
WHERE product_id IN (
    SELECT product_id 
    FROM OrderItems 
    WHERE order_id = @newOrderId
);

-- Verify no negative stock
IF EXISTS (SELECT 1 FROM Products WHERE stock_quantity < 0)
BEGIN
    ROLLBACK;
    PRINT 'Order failed - insufficient stock';
END
ELSE
BEGIN
    COMMIT;
    PRINT 'Order processed successfully';
END

/**************************************/
/* MINI PROJECT 5: HOTEL BOOKING SYSTEM */
/**************************************/

CREATE DATABASE HotelManagement;
USE HotelManagement;

CREATE TABLE Rooms (
    room_id INT PRIMARY KEY,
    room_number VARCHAR(10) UNIQUE,
    room_type VARCHAR(50),
    rate_per_night DECIMAL(10,2) CHECK (rate_per_night >= 0),
    capacity INT CHECK (capacity > 0),
    status VARCHAR(20) DEFAULT 'Available'
);

CREATE TABLE Guests (
    guest_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20)
);

CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY,
    room_id INT,
    guest_id INT,
    check_in_date DATE,
    check_out_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'Confirmed',
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id),
    FOREIGN KEY (guest_id) REFERENCES Guests(guest_id),
    CHECK (check_out_date > check_in_date)
);

-- Insert data
INSERT INTO Rooms VALUES
(101, '101', 'Standard', 99.99, 2, 'Available'),
(102, '102', 'Standard', 99.99, 2, 'Available'),
(201, '201', 'Deluxe', 149.99, 4, 'Available');

INSERT INTO Guests VALUES
(1, 'Robert Johnson', 'robert.j@email.com', '555-2001'),
(2, 'Sarah Williams', 'sarah.w@email.com', '555-2002');

-- Booking transaction
BEGIN TRANSACTION;
DECLARE @newBookingId INT = 1;
DECLARE @roomId INT = 101;
DECLARE @guestId INT = 1;
DECLARE @checkIn DATE = '2023-12-20';
DECLARE @checkOut DATE = '2023-12-25';
DECLARE @nights INT = DATEDIFF(DAY, @checkIn, @checkOut);
DECLARE @rate DECIMAL(10,2);
DECLARE @total DECIMAL(10,2);

-- Get room rate
SELECT @rate = rate_per_night FROM Rooms WHERE room_id = @roomId;
SET @total = @rate * @nights;

-- Check room availability
IF EXISTS (
    SELECT 1 FROM Bookings 
    WHERE room_id = @roomId
    AND status = 'Confirmed'
    AND (
        (@checkIn BETWEEN check_in_date AND check_out_date)
        OR (@checkOut BETWEEN check_in_date AND check_out_date)
        OR (check_in_date BETWEEN @checkIn AND @checkOut)
    )
)
BEGIN
    ROLLBACK;
    PRINT 'Booking failed - room not available for selected dates';
END
ELSE
BEGIN
    -- Create booking
    INSERT INTO Bookings VALUES
    (@newBookingId, @roomId, @guestId, @checkIn, @checkOut, @total, 'Confirmed');
    
    -- Update room status
    UPDATE Rooms SET status = 'Booked' WHERE room_id = @roomId;
    
    COMMIT;
    PRINT 'Booking confirmed successfully';
END

/**************************************/
/* MINI PROJECT 6: LIBRARY MANAGEMENT SYSTEM */
/**************************************/

CREATE DATABASE LibraryManagement;
USE LibraryManagement;

CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100),
    isbn VARCHAR(20) UNIQUE,
    status VARCHAR(20) DEFAULT 'Available'
);

CREATE TABLE Members (
    member_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    join_date DATE DEFAULT GETDATE()
);

CREATE TABLE BorrowRecords (
    borrow_id INT PRIMARY KEY,
    book_id INT,
    member_id INT,
    borrow_date DATE DEFAULT GETDATE(),
    due_date DATE,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    CHECK (due_date > borrow_date)
);

-- Insert data
INSERT INTO Books VALUES
(1, 'The Great Gatsby', 'F. Scott Fitzgerald', '9780743273565', 'Available'),
(2, 'To Kill a Mockingbird', 'Harper Lee', '9780061120084', 'Available'),
(3, '1984', 'George Orwell', '9780451524935', 'Available');

INSERT INTO Members VALUES
(101, 'Emma Thompson', 'emma.t@email.com', '2023-01-10'),
(102, 'James Wilson', 'james.w@email.com', '2023-02-15');

-- Borrow transaction
BEGIN TRANSACTION;
-- Check book availability
IF (SELECT status FROM Books WHERE book_id = 1) = 'Available'
BEGIN
    -- Create borrow record
    INSERT INTO BorrowRecords VALUES
    (1, 1, 101, GETDATE(), DATEADD(DAY, 14, GETDATE()), NULL);
    
    -- Update book status
    UPDATE Books SET status = 'Borrowed' WHERE book_id = 1;
    
    COMMIT;
    PRINT 'Book borrowed successfully';
END
ELSE
BEGIN
    ROLLBACK;
    PRINT 'Book not available for borrowing';
END

-- Return transaction
BEGIN TRANSACTION;
UPDATE BorrowRecords 
SET return_date = GETDATE()
WHERE borrow_id = 1;

UPDATE Books 
SET status = 'Available'
WHERE book_id = 1;

COMMIT;
PRINT 'Book returned successfully';

/**************************************/
/* MINI PROJECT 7: INVENTORY AND STOCK CONTROL */
/**************************************/

CREATE DATABASE InventoryManagement;
USE InventoryManagement;

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    quantity INT CHECK (quantity >= 0),
    reorder_level INT CHECK (reorder_level >= 0),
    supplier VARCHAR(100)
);

CREATE TABLE StockMovements (
    movement_id INT PRIMARY KEY,
    product_id INT,
    movement_type VARCHAR(20),
    quantity INT CHECK (quantity > 0),
    movement_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Insert data
INSERT INTO Products VALUES
(1, 'Laptop', 'Electronics', 50, 10, 'Tech Supplier Inc.'),
(2, 'Desk Chair', 'Furniture', 30, 5, 'Office Furnishings Ltd.'),
(3, 'Notebook', 'Office Supplies', 200, 50, 'Paper Products Co.');

-- Stock update transaction
BEGIN TRANSACTION;
-- Receive new stock
UPDATE Products 
SET quantity = quantity + 20
WHERE product_id = 1;

-- Record movement
INSERT INTO StockMovements VALUES
(1, 1, 'Inbound', 20, GETDATE());

-- Check if below reorder level
IF EXISTS (SELECT 1 FROM Products WHERE quantity < reorder_level)
BEGIN
    PRINT 'Warning: Some products are below reorder level';
END

COMMIT;
PRINT 'Stock updated successfully';

/**************************************/
/* MINI PROJECT 8: BANKING TRANSACTION SIMULATOR */
/**************************************/

CREATE DATABASE BankingSystem;
USE BankingSystem;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    join_date DATE DEFAULT GETDATE()
);

CREATE TABLE Accounts (
    account_id INT PRIMARY KEY,
    customer_id INT,
    account_type VARCHAR(20),
    balance DECIMAL(15,2) DEFAULT 0 CHECK (balance >= 0),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT,
    amount DECIMAL(12,2),
    transaction_type VARCHAR(20),
    transaction_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

-- Insert data
INSERT INTO Customers VALUES
(1, 'Michael Davis', 'michael.d@email.com', '2020-05-15'),
(2, 'Jennifer Lee', 'jennifer.l@email.com', '2021-02-20');

INSERT INTO Accounts VALUES
(1001, 1, 'Checking', 2500.00),
(1002, 1, 'Savings', 10000.00),
(1003, 2, 'Checking', 5000.00);

-- Transfer transaction
BEGIN TRANSACTION;
DECLARE @fromAccount INT = 1002;
DECLARE @toAccount INT = 1003;
DECLARE @transferAmount DECIMAL(12,2) = 1000.00;
DECLARE @fromBalance DECIMAL(15,2);

-- Check balance
SELECT @fromBalance = balance FROM Accounts WHERE account_id = @fromAccount;

IF @fromBalance >= @transferAmount
BEGIN
    -- Withdraw from source
    UPDATE Accounts SET balance = balance - @transferAmount WHERE account_id = @fromAccount;
    INSERT INTO Transactions VALUES (1, @fromAccount, @transferAmount, 'Withdrawal', GETDATE());
    
    -- Deposit to target
    UPDATE Accounts SET balance = balance + @transferAmount WHERE account_id = @toAccount;
    INSERT INTO Transactions VALUES (2, @toAccount, @transferAmount, 'Deposit', GETDATE());
    
    COMMIT;
    PRINT 'Transfer completed successfully';
END
ELSE
BEGIN
    ROLLBACK;
    PRINT 'Transfer failed - insufficient funds';
END

/**************************************/
/* MINI PROJECT 9: RETAIL POINT OF SALE SYSTEM */
/**************************************/

CREATE DATABASE RetailPOS;
USE RetailPOS;

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    barcode VARCHAR(20) UNIQUE,
    price DECIMAL(10,2) CHECK (price >= 0),
    stock INT CHECK (stock >= 0)
);

CREATE TABLE Cashiers (
    cashier_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    employee_id VARCHAR(20) UNIQUE
);

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    cashier_id INT,
    sale_date DATETIME DEFAULT GETDATE(),
    total_amount DECIMAL(12,2) CHECK (total_amount >= 0),
    FOREIGN KEY (cashier_id) REFERENCES Cashiers(cashier_id)
);

CREATE TABLE SaleItems (
    sale_item_id INT PRIMARY KEY,
    sale_id INT,
    product_id INT,
    quantity INT CHECK (quantity > 0),
    unit_price DECIMAL(10,2),
    FOREIGN KEY (sale_id) REFERENCES Sales(sale_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Insert data
INSERT INTO Products VALUES
(1, 'Milk', '123456789012', 3.99, 100),
(2, 'Bread', '234567890123', 2.49, 150),
(3, 'Eggs', '345678901234', 4.99, 200);

INSERT INTO Cashiers VALUES
(1, 'Sarah Johnson', 'EMP1001'),
(2, 'David Wilson', 'EMP1002');

-- Sale transaction
BEGIN TRANSACTION;
DECLARE @newSaleId INT = 1;

-- Create sale
INSERT INTO Sales (sale_id, cashier_id, total_amount)
VALUES (@newSaleId, 1, 0); -- Temporary total

-- Add items
INSERT INTO SaleItems VALUES
(1, @newSaleId, 1, 2, (SELECT price FROM Products WHERE product_id = 1)),
(2, @newSaleId, 2, 1, (SELECT price FROM Products WHERE product_id = 2)),
(3, @newSaleId, 3, 1, (SELECT price FROM Products WHERE product_id = 3));

-- Update sale total
UPDATE Sales
SET total_amount = (
    SELECT SUM(quantity * unit_price) 
    FROM SaleItems 
    WHERE sale_id = @newSaleId
)
WHERE sale_id = @newSaleId;

-- Update inventory
UPDATE Products
SET stock = stock - (
    SELECT quantity 
    FROM SaleItems 
    WHERE product_id = Products.product_id AND sale_id = @newSaleId
)
WHERE product_id IN (
    SELECT product_id 
    FROM SaleItems 
    WHERE sale_id = @newSaleId
);

-- Verify no negative stock
IF EXISTS (SELECT 1 FROM Products WHERE stock < 0)
BEGIN
    ROLLBACK;
    PRINT 'Sale failed - insufficient stock';
END
ELSE
BEGIN
    COMMIT;
    PRINT 'Sale completed successfully';
END

/**************************************/
/* MINI PROJECT 10: CAR RENTAL BOOKING SYSTEM */
/**************************************/

CREATE DATABASE CarRental;
USE CarRental;

CREATE TABLE Cars (
    car_id INT PRIMARY KEY,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INT CHECK (year > 2000),
    daily_rate DECIMAL(10,2) CHECK (daily_rate >= 0),
    status VARCHAR(20) DEFAULT 'Available'
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    driver_license VARCHAR(20) UNIQUE
);

CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY,
    car_id INT,
    customer_id INT,
    start_date DATE,
    end_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'Confirmed',
    FOREIGN KEY (car_id) REFERENCES Cars(car_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    CHECK (end_date > start_date)
);

-- Insert data
INSERT INTO Cars VALUES
(1, 'Toyota', 'Camry', 2022, 49.99, 'Available'),
(2, 'Honda', 'Accord', 2023, 54.99, 'Available'),
(3, 'Ford', 'Mustang', 2023, 79.99, 'Available');

INSERT INTO Customers VALUES
(1, 'Robert Johnson', 'robert.j@email.com', 'DL1001'),
(2, 'Sarah Williams', 'sarah.w@email.com', 'DL1002');

-- Booking transaction
BEGIN TRANSACTION;
DECLARE @newBookingId INT = 1;
DECLARE @carId INT = 1;
DECLARE @customerId INT = 1;
DECLARE @startDate DATE = '2023-12-20';
DECLARE @endDate DATE = '2023-12-25';
DECLARE @days INT = DATEDIFF(DAY, @startDate, @endDate);
DECLARE @dailyRate DECIMAL(10,2);
DECLARE @total DECIMAL(10,2);

-- Get car rate
SELECT @dailyRate = daily_rate FROM Cars WHERE car_id = @carId;
SET @total = @dailyRate * @days;

-- Check car availability
IF EXISTS (
    SELECT 1 FROM Bookings 
    WHERE car_id = @carId
    AND status = 'Confirmed'
    AND (
        (@startDate BETWEEN start_date AND end_date)
        OR (@endDate BETWEEN start_date AND end_date)
        OR (start_date BETWEEN @startDate AND @endDate)
    )
)
BEGIN
    ROLLBACK;
    PRINT 'Booking failed - car not available for selected dates';
END
ELSE
BEGIN
    -- Create booking
    INSERT INTO Bookings VALUES
    (@newBookingId, @carId, @customerId, @startDate, @endDate, @total, 'Confirmed');
    
    -- Update car status
    UPDATE Cars SET status = 'Booked' WHERE car_id = @carId;
    
    COMMIT;
    PRINT 'Booking confirmed successfully';
END

/**************************************/
/* MINI PROJECT 11: UNIVERSITY COURSE REGISTRATION */
/**************************************/

CREATE DATABASE UniversityRegistration;
USE UniversityRegistration;

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    major VARCHAR(50)
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    credits INT CHECK (credits > 0),
    capacity INT CHECK (capacity > 0),
    enrolled INT DEFAULT 0 CHECK (enrolled >= 0 AND enrolled <= capacity)
);

CREATE TABLE Registrations (
    registration_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    registration_date DATE DEFAULT GETDATE(),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    UNIQUE (student_id, course_id)
);

-- Insert data
INSERT INTO Students VALUES
(1001, 'Alice Johnson', 'alice.j@university.edu', 'Computer Science'),
(1002, 'Bob Smith', 'bob.s@university.edu', 'Mathematics'),
(1003, 'Carol Williams', 'carol.w@university.edu', 'English');

INSERT INTO Courses VALUES
(101, 'Introduction to Programming', 'Computer Science', 3, 30, 0),
(102, 'Calculus I', 'Mathematics', 4, 25, 0),
(103, 'English Literature', 'English', 3, 20, 0);

-- Registration transaction
BEGIN TRANSACTION;
DECLARE @studentId INT = 1001;
DECLARE @courseId INT = 101;

-- Check capacity
IF (SELECT enrolled FROM Courses WHERE course_id = @courseId) < 
   (SELECT capacity FROM Courses WHERE course_id = @courseId)
BEGIN
    -- Register student
    INSERT INTO Registrations VALUES (1, @studentId, @courseId, GETDATE());
    
    -- Update enrollment count
    UPDATE Courses 
    SET enrolled = enrolled + 1 
    WHERE course_id = @courseId;
    
    COMMIT;
    PRINT 'Registration successful';
END
ELSE
BEGIN
    ROLLBACK;
    PRINT 'Registration failed - course at capacity';
END

/**************************************/
/* MINI PROJECT 12: GYM MEMBERSHIP SYSTEM */
/**************************************/

CREATE DATABASE GymMembership;
USE GymMembership;

CREATE TABLE Members (
    member_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    join_date DATE DEFAULT GETDATE(),
    status VARCHAR(20) DEFAULT 'Active'
);

CREATE TABLE MembershipPlans (
    plan_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    duration_months INT CHECK (duration_months > 0),
    price DECIMAL(10,2) CHECK (price >= 0)
);

CREATE TABLE MemberSubscriptions (
    subscription_id INT PRIMARY KEY,
    member_id INT,
    plan_id INT,
    start_date DATE DEFAULT GETDATE(),
    end_date DATE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    FOREIGN KEY (plan_id) REFERENCES MembershipPlans(plan_id)
);

CREATE TABLE ClassBookings (
    booking_id INT PRIMARY KEY,
    member_id INT,
    class_name VARCHAR(50),
    booking_date DATE DEFAULT GETDATE(),
    class_date DATE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    CHECK (class_date >= booking_date)
);

-- Insert data
INSERT INTO MembershipPlans VALUES
(1, 'Basic', 1, 29.99),
(2, 'Standard', 3, 79.99),
(3, 'Premium', 12, 299.99);

INSERT INTO Members VALUES
(101, 'Emma Thompson', 'emma.t@email.com', '2023-01-10', 'Active'),
(102, 'James Wilson', 'james.w@email.com', '2023-02-15', 'Active');

-- Membership purchase and class booking transaction
BEGIN TRANSACTION;
DECLARE @memberId INT = 101;
DECLARE @planId INT = 2;
DECLARE @endDate DATE = DATEADD(MONTH, 3, GETDATE());

-- Purchase membership
INSERT INTO MemberSubscriptions VALUES
(1, @memberId, @planId, GETDATE(), @endDate);

-- Book class
INSERT INTO ClassBookings VALUES
(1, @memberId, 'Yoga', GETDATE(), '2023-12-20');

COMMIT;
PRINT 'Membership and class booking completed successfully';

/**************************************/
/* MINI PROJECT 13: RESTAURANT ORDER PROCESSING */
/**************************************/

CREATE DATABASE RestaurantOrders;
USE RestaurantOrders;

CREATE TABLE MenuItems (
    item_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) CHECK (price >= 0),
    description VARCHAR(200)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    table_number INT,
    order_date DATETIME DEFAULT GETDATE(),
    status VARCHAR(20) DEFAULT 'Received',
    total_amount DECIMAL(10,2) CHECK (total_amount >= 0)
);

CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    item_id INT,
    quantity INT CHECK (quantity > 0),
    special_requests VARCHAR(200),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (item_id) REFERENCES MenuItems(item_id)
);

-- Insert data
INSERT INTO MenuItems VALUES
(1, 'Margherita Pizza', 'Main', 12.99, 'Classic tomato and mozzarella'),
(2, 'Caesar Salad', 'Starter', 8.99, 'Romaine lettuce with Caesar dressing'),
(3, 'Tiramisu', 'Dessert', 6.99, 'Italian coffee-flavored dessert');

-- Order transaction
BEGIN TRANSACTION;
DECLARE @newOrderId INT = 1;

-- Create order
INSERT INTO Orders (order_id, table_number, total_amount)
VALUES (@newOrderId, 5, 0); -- Temporary total

-- Add items
INSERT INTO OrderItems VALUES
(1, @newOrderId, 1, 1, 'Extra cheese'),
(2, @newOrderId, 2, 2, 'Dressing on the side'),
(3, @newOrderId, 3, 1, NULL);

-- Update order total
UPDATE Orders
SET total_amount = (
    SELECT SUM(quantity * (SELECT price FROM MenuItems WHERE item_id = OrderItems.item_id))
    FROM OrderItems 
    WHERE order_id = @newOrderId
)
WHERE order_id = @newOrderId;

-- Update kitchen status (simulated)
-- In a real system, you might have a separate table for kitchen tickets

COMMIT;
PRINT 'Order placed successfully';

/**************************************/
/* MINI PROJECT 14: ONLINE EXAM SYSTEM */
/**************************************/

CREATE DATABASE ExamSystem;
USE ExamSystem;

CREATE TABLE Candidates (
    candidate_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    registration_date DATE DEFAULT GETDATE()
);

CREATE TABLE Exams (
    exam_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    max_marks INT CHECK (max_marks > 0),
    passing_marks INT CHECK (passing_marks > 0 AND passing_marks <= max_marks)
);

CREATE TABLE Results (
    result_id INT PRIMARY KEY,
    candidate_id INT,
    exam_id INT,
    marks_obtained INT CHECK (marks_obtained >= 0),
    status VARCHAR(20),
    FOREIGN KEY (candidate_id) REFERENCES Candidates(candidate_id),
    FOREIGN KEY (exam_id) REFERENCES Exams(exam_id),
    CHECK (marks_obtained <= (SELECT max_marks FROM Exams WHERE exam_id = Results.exam_id))
);

-- Insert data
INSERT INTO Candidates VALUES
(1001, 'Alice Johnson', 'alice.j@test.com', '2023-09-01'),
(1002, 'Bob Smith', 'bob.s@test.com', '2023-09-01');

INSERT INTO Exams VALUES
(1, 'SQL Certification', 100, 70),
(2, 'Programming Fundamentals', 100, 60);

-- Result entry transaction
BEGIN TRANSACTION;
DECLARE @candidateId INT = 1001;
DECLARE @examId INT = 1;
DECLARE @marks INT = 85;

-- Insert result
INSERT INTO Results VALUES
(1, @candidateId, @examId, @marks, 
 CASE WHEN @marks >= (SELECT passing_marks FROM Exams WHERE exam_id = @examId) 
      THEN 'Pass' ELSE 'Fail' END);

-- Generate certificate (simulated)
-- In a real system, this might involve calling a stored procedure

COMMIT;
PRINT 'Result recorded and certificate generated';

/**************************************/
/* MINI PROJECT 15: CLINIC APPOINTMENT SCHEDULER */
/**************************************/

CREATE DATABASE ClinicScheduler;
USE ClinicScheduler;

CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialty VARCHAR(50),
    available_from TIME,
    available_to TIME
);

CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    doctor_id INT,
    patient_id INT,
    appointment_date DATETIME,
    duration_minutes INT CHECK (duration_minutes > 0),
    status VARCHAR(20) DEFAULT 'Scheduled',
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    CHECK (appointment_date > GETDATE())
);

-- Insert data
INSERT INTO Doctors VALUES
(1, 'Dr. James Smith', 'Cardiology', '09:00', '17:00'),
(2, 'Dr. Emily Davis', 'Pediatrics', '10:00', '16:00');

INSERT INTO Patients VALUES
(1, 'David Brown', '555-1001', 'david.b@email.com'),
(2, 'Sarah Wilson', '555-1002', 'sarah.w@email.com');

-- Appointment scheduling transaction
BEGIN TRANSACTION;
DECLARE @doctorId INT = 1;
DECLARE @patientId INT = 1;
DECLARE @apptDate DATETIME = '2023-12-20 10:30:00';
DECLARE @duration INT = 30;

-- Check doctor availability
IF NOT EXISTS (
    SELECT 1 FROM Appointments 
    WHERE doctor_id = @doctorId
    AND appointment_date BETWEEN DATEADD(MINUTE, -@duration, @apptDate) 
                          AND DATEADD(MINUTE, @duration, @apptDate)
    AND status <> 'Cancelled'
)
AND @apptDate BETWEEN 
    (SELECT CAST(CAST(GETDATE() AS DATE) AS DATETIME) + 
    (SELECT available_from FROM Doctors WHERE doctor_id = @doctorId)
AND 
    (SELECT CAST(CAST(GETDATE() AS DATE) AS DATETIME) + 
    (SELECT available_to FROM Doctors WHERE doctor_id = @doctorId)
BEGIN
    -- Schedule appointment
    INSERT INTO Appointments VALUES
    (1, @doctorId, @patientId, @apptDate, @duration, 'Scheduled');
    
    COMMIT;
    PRINT 'Appointment scheduled successfully';
END
ELSE
BEGIN
    ROLLBACK;
    PRINT 'Appointment scheduling failed - doctor not available';
END

/**************************************/
/* MINI PROJECT 16: TRANSPORT TICKET BOOKING SYSTEM */
/**************************************/

CREATE DATABASE TransportBooking;
USE TransportBooking;

CREATE TABLE Routes (
    route_id INT PRIMARY KEY,
    origin VARCHAR(50) NOT NULL,
    destination VARCHAR(50) NOT NULL,
    departure_time TIME,
    arrival_time TIME,
    fare DECIMAL(10,2) CHECK (fare >= 0)
);

CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    id_number VARCHAR(20) UNIQUE,
    phone VARCHAR(20)
);

CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY,
    route_id INT,
    passenger_id INT,
    seat_number VARCHAR(10),
    booking_date DATETIME DEFAULT GETDATE(),
    travel_date DATE,
    status VARCHAR(20) DEFAULT 'Confirmed',
    FOREIGN KEY (route_id) REFERENCES Routes(route_id),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    CHECK (travel_date >= CAST(GETDATE() AS DATE))
);

-- Insert data
INSERT INTO Routes VALUES
(1, 'New York', 'Boston', '08:00', '12:00', 49.99),
(2, 'Chicago', 'St. Louis', '09:30', '14:00', 39.99);

INSERT INTO Passengers VALUES
(1, 'Robert Johnson', 'ID1001', '555-2001'),
(2, 'Sarah Williams', 'ID1002', '555-2002');

-- Ticket booking transaction
BEGIN TRANSACTION;
DECLARE @routeId INT = 1;
DECLARE @passengerId INT = 1;
DECLARE @travelDate DATE = '2023-12-20';
DECLARE @seatNumber VARCHAR(10) = 'A12';

-- Check seat availability
IF NOT EXISTS (
    SELECT 1 FROM Tickets 
    WHERE route_id = @routeId 
    AND travel_date = @travelDate 
    AND seat_number = @seatNumber
)
BEGIN
    -- Book ticket
    INSERT INTO Tickets VALUES
    (1, @routeId, @passengerId, @seatNumber, GETDATE(), @travelDate, 'Confirmed');
    
    COMMIT;
    PRINT 'Ticket booked successfully';
END
ELSE
BEGIN
    ROLLBACK;
    PRINT 'Booking failed - seat already taken';
END

/**************************************/
/* MINI PROJECT 17: EMPLOYEE ATTENDANCE TRACKER */
/**************************************/

CREATE DATABASE AttendanceTracker;
USE AttendanceTracker;

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    position VARCHAR(50)
);

CREATE TABLE Attendance (
    attendance_id INT PRIMARY KEY,
    employee_id INT,
    date DATE DEFAULT GETDATE(),
    check_in TIME,
    check_out TIME,
    status VARCHAR(20),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    CHECK (check_out >= check_in OR check_out IS NULL)
);

-- Insert data
INSERT INTO Employees VALUES
(101, 'John Smith', 'HR', 'Manager'),
(102, 'Jane Doe', 'IT', 'Developer'),
(103, 'Robert Johnson', 'Finance', 'Analyst');

-- Attendance recording transaction
BEGIN TRANSACTION;
DECLARE @employeeId INT = 101;
DECLARE @checkInTime TIME = '08:30';
DECLARE @checkOutTime TIME = '17:15';

-- Check if attendance already recorded for today
IF NOT EXISTS (
    SELECT 1 FROM Attendance 
    WHERE employee_id = @employeeId 
    AND date = CAST(GETDATE() AS DATE)
)
BEGIN
    -- Record attendance
    INSERT INTO Attendance VALUES
    (1, @employeeId, GETDATE(), @checkInTime, @checkOutTime,
     CASE 
         WHEN @checkInTime > '09:00' THEN 'Late'
         WHEN @checkOutTime < '17:00' THEN 'Left Early'
         ELSE 'Present'
     END);
    
    COMMIT;
    PRINT 'Attendance recorded successfully';
END
ELSE
BEGIN
    ROLLBACK;
    PRINT 'Attendance already recorded for today';
END

/**************************************/
/* MINI PROJECT 18: NGO DONATION RECORD SYSTEM */
/**************************************/

CREATE DATABASE DonationSystem;
USE DonationSystem;

CREATE TABLE Donors (
    donor_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(200),
    registration_date DATE DEFAULT GETDATE()
);

CREATE TABLE Donations (
    donation_id INT PRIMARY KEY,
    donor_id INT,
    amount DECIMAL(10,2) CHECK (amount > 0),
    donation_date DATE DEFAULT GETDATE(),
    purpose VARCHAR(100),
    payment_method VARCHAR(20),
    FOREIGN KEY (donor_id) REFERENCES Donors(donor_id)
);

-- Insert data
INSERT INTO Donors VALUES
(1, 'Alice Johnson', 'alice.j@email.com', '555-3001', '123 Main St', '2023-01-15'),
(2, 'Bob Smith', 'bob.s@email.com', '555-3002', '456 Oak Ave', '2023-02-20');

-- Donation processing transaction
BEGIN TRANSACTION;
DECLARE @donorId INT = 1;
DECLARE @amount DECIMAL(10,2) = 500.00;
DECLARE @purpose VARCHAR(100) = 'Education Fund';
DECLARE @paymentMethod VARCHAR(20) = 'Credit Card';

-- Record donation
INSERT INTO Donations VALUES
(1, @donorId, @amount, GETDATE(), @purpose, @paymentMethod);

-- Update donor status (simulated)
-- In a real system, you might update donor tier based on total donations

COMMIT;
PRINT 'Donation recorded successfully';

/**************************************/
/* MINI PROJECT 19: PAYROLL & SALARY SYSTEM */
/**************************************/

CREATE DATABASE PayrollSystem;
USE PayrollSystem;

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    position VARCHAR(50),
    base_salary DECIMAL(10,2) CHECK (base_salary >= 3000),
    join_date DATE
);

CREATE TABLE Salaries (
    salary_id INT PRIMARY KEY,
    employee_id INT,
    pay_period_start DATE,
    pay_period_end DATE,
    gross_salary DECIMAL(10,2) CHECK (gross_salary >= 0),
    net_salary DECIMAL(10,2) CHECK (net_salary >= 0),
    payment_date DATE,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    CHECK (pay_period_end > pay_period_start)
);

CREATE TABLE Deductions (
    deduction_id INT PRIMARY KEY,
    salary_id INT,
    description VARCHAR(100),
    amount DECIMAL(10,2) CHECK (amount >= 0),
    FOREIGN KEY (salary_id) REFERENCES Salaries(salary_id)
);

-- Insert data
INSERT INTO Employees VALUES
(101, 'John Smith', 'Manager', 6000.00, '2022-01-15'),
(102, 'Jane Doe', 'Developer', 5000.00, '2022-05-20');

-- Payroll processing transaction
BEGIN TRANSACTION;
DECLARE @employeeId INT = 101;
DECLARE @periodStart DATE = '2023-12-01';
DECLARE @periodEnd DATE = '2023-12-31';
DECLARE @paymentDate DATE = '2024-01-05';
DECLARE @baseSalary DECIMAL(10,2);
DECLARE @bonus DECIMAL(10,2) = 1000.00;
DECLARE @taxRate DECIMAL(5,2) = 0.20;
DECLARE @grossSalary DECIMAL(10,2);
DECLARE @taxAmount DECIMAL(10,2);
DECLARE @netSalary DECIMAL(10,2);
DECLARE @newSalaryId INT = 1;

-- Get base salary
SELECT @baseSalary = base_salary FROM Employees WHERE employee_id = @employeeId;

-- Calculate salary components
SET @grossSalary = @baseSalary + @bonus;
SET @taxAmount = @grossSalary * @taxRate;
SET @netSalary = @grossSalary - @taxAmount;

-- Record salary
INSERT INTO Salaries VALUES
(@newSalaryId, @employeeId, @periodStart, @periodEnd, @grossSalary, @netSalary, @paymentDate);

-- Record deductions
INSERT INTO Deductions VALUES
(1, @newSalaryId, 'Income Tax', @taxAmount);

COMMIT;
PRINT 'Payroll processed successfully';

/**************************************/
/* MINI PROJECT 20: WAREHOUSE INWARD/OUTWARD SYSTEM */
/**************************************/

CREATE DATABASE WarehouseManagement;
USE WarehouseManagement;

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    current_stock INT CHECK (current_stock >= 0),
    reorder_level INT CHECK (reorder_level >= 0)
);

CREATE TABLE Inward (
    inward_id INT PRIMARY KEY,
    product_id INT,
    quantity INT CHECK (quantity > 0),
    received_date DATE DEFAULT GETDATE(),
    supplier VARCHAR(100),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Outward (
    outward_id INT PRIMARY KEY,
    product_id INT,
    quantity INT CHECK (quantity > 0),
    dispatch_date DATE DEFAULT GETDATE(),
    destination VARCHAR(100),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Insert data
INSERT INTO Products VALUES
(1, 'Laptop', 'Electronics', 50, 10),
(2, 'Desk Chair', 'Furniture', 30, 5),
(3, 'Notebook', 'Office Supplies', 200, 50);

-- Stock movement transaction
BEGIN TRANSACTION;
DECLARE @productId INT = 1;
DECLARE @inwardQty INT = 20;
DECLARE @outwardQty INT = 5;
DECLARE @supplier VARCHAR(100) = 'Tech Supplier Inc.';
DECLARE @destination VARCHAR(100) = 'Office Branch A';

-- Record inward movement
INSERT INTO Inward VALUES
(1, @productId, @inwardQty, GETDATE(), @supplier);

-- Update stock
UPDATE Products 
SET current_stock = current_stock + @inwardQty
WHERE product_id = @productId;

-- Record outward movement
INSERT INTO Outward VALUES
(1, @productId, @outwardQty, GETDATE(), @destination);

-- Update stock
UPDATE Products 
SET current_stock = current_stock - @outwardQty
WHERE product_id = @productId;

-- Check if below reorder level
IF EXISTS (
    SELECT 1 FROM Products 
    WHERE current_stock < reorder_level
)
BEGIN
    PRINT 'Warning: Some products are below reorder level';
END

COMMIT;
PRINT 'Stock movements recorded successfully';