##1. Employee Performance Analyzer
-- Create tables
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL
);

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    dept_id INT,
    performance_score INT,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

CREATE TABLE Salaries (
    salary_id INT PRIMARY KEY,
    emp_id INT,
    salary DECIMAL(10,2),
    effective_date DATE,
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

-- Insert data
INSERT INTO Departments VALUES (1, 'HR'), (2, 'IT'), (3, 'Finance');

INSERT INTO Employees VALUES 
(101, 'John Doe', 1, 85),
(102, 'Jane Smith', 2, 92),
(103, 'Mike Johnson', 2, 78);

INSERT INTO Salaries VALUES 
(1, 101, 50000.00, '2023-01-01'),
(2, 102, 65000.00, '2023-01-01'),
(3, 103, 55000.00, '2023-01-01');

-- Retrieve high performers
SELECT e.emp_name, e.performance_score, s.salary
FROM Employees e
JOIN Salaries s ON e.emp_id = s.emp_id
WHERE e.performance_score > 80
ORDER BY e.performance_score DESC;

-- Department-wise average salary
SELECT d.dept_name, AVG(s.salary) as avg_salary
FROM Departments d
JOIN Employees e ON d.dept_id = e.dept_id
JOIN Salaries s ON e.emp_id = s.emp_id
GROUP BY d.dept_name;

-- Classify salaries
SELECT e.emp_name, s.salary,
    CASE 
        WHEN s.salary > 60000 THEN 'High'
        WHEN s.salary BETWEEN 45000 AND 60000 THEN 'Medium'
        ELSE 'Low'
    END as salary_class
FROM Employees e
JOIN Salaries s ON e.emp_id = s.emp_id;

-- Update salary with transaction
START TRANSACTION;
UPDATE Salaries SET salary = 70000.00 WHERE emp_id = 102;
-- If error occurs: ROLLBACK;
COMMIT;






#2. Online Course Enrollment Report


-- Create tables
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    instructor VARCHAR(100)
);

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE Grades (
    grade_id INT PRIMARY KEY,
    enrollment_id INT,
    score DECIMAL(5,2) CHECK (score >= 0 AND score <= 100),
    FOREIGN KEY (enrollment_id) REFERENCES Enrollments(enrollment_id)
);

-- Insert data
INSERT INTO Students VALUES 
(1, 'Alice Brown', 'alice@email.com'),
(2, 'Bob Green', 'bob@email.com');

INSERT INTO Courses VALUES 
(101, 'Database Systems', 'Dr. Smith'),
(102, 'Web Development', 'Prof. Johnson');

INSERT INTO Enrollments VALUES 
(1001, 1, 101, '2023-09-01'),
(1002, 2, 101, '2023-09-01'),
(1003, 1, 102, '2023-09-15');

INSERT INTO Grades VALUES 
(1, 1001, 85.5),
(2, 1002, 72.0),
(3, 1003, 90.0);

-- Students who scored above average in each course
SELECT s.student_name, c.course_name, g.score
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
JOIN Grades g ON e.enrollment_id = g.enrollment_id
WHERE g.score > (
    SELECT AVG(score) 
    FROM Grades g2 
    JOIN Enrollments e2 ON g2.enrollment_id = e2.enrollment_id 
    WHERE e2.course_id = e.course_id
);

-- Courses with more than 10 enrollments
SELECT c.course_name, COUNT(e.enrollment_id) as enrollment_count
FROM Courses c
JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
HAVING COUNT(e.enrollment_id) > 1; -- Using 1 for demo purposes





#3. Retail Order Summary Dashboard

-- Create tables
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Insert data
INSERT INTO Customers VALUES 
(1, 'David Wilson', 'david@email.com'),
(2, 'Emily Davis', 'emily@email.com');

INSERT INTO Products VALUES 
(1001, 'Laptop', 999.99),
(1002, 'Smartphone', 699.99);

INSERT INTO Orders VALUES 
(5001, 1, '2023-10-01'),
(5002, 2, '2023-10-01'),
(5003, 1, '2023-10-02');

INSERT INTO OrderItems VALUES 
(1, 5001, 1001, 1),
(2, 5001, 1002, 2),
(3, 5002, 1002, 1),
(4, 5003, 1001, 1);

-- Complete order summaries
SELECT o.order_id, c.customer_name, o.order_date, 
       p.product_name, oi.quantity, p.price, 
       (oi.quantity * p.price) as item_total
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
ORDER BY o.order_date, c.customer_name;

-- Daily sales
SELECT o.order_date, SUM(oi.quantity * p.price) as daily_sales
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
GROUP BY o.order_date;

-- Best-selling products
SELECT p.product_name, SUM(oi.quantity) as total_sold
FROM Products p
JOIN OrderItems oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;




#4. Library Borrowing Management System

-- Create tables
CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100),
    is_available BOOLEAN DEFAULT TRUE
);

CREATE TABLE Members (
    member_id INT PRIMARY KEY,
    member_name VARCHAR(100) NOT NULL,
    membership_date DATE
);

CREATE TABLE BorrowRecords (
    record_id INT PRIMARY KEY,
    book_id INT,
    member_id INT,
    borrow_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- Insert data
INSERT INTO Books VALUES 
(1, 'Database Design', 'C.J. Date', TRUE),
(2, 'SQL for Beginners', 'Alice Peterson', TRUE);

INSERT INTO Members VALUES 
(1001, 'Sarah Miller', '2023-01-15'),
(1002, 'Tom Wilson', '2023-03-20');

INSERT INTO BorrowRecords VALUES 
(1, 1, 1001, '2023-09-01', '2023-09-15'),
(2, 2, 1002, '2023-09-10', NULL);

-- Books borrowed in September
SELECT b.title, m.member_name, br.borrow_date, br.return_date
FROM BorrowRecords br
JOIN Books b ON br.book_id = b.book_id
JOIN Members m ON br.member_id = m.member_id
WHERE br.borrow_date BETWEEN '2023-09-01' AND '2023-09-30';

-- Overdue books
SELECT b.title, m.member_name, br.borrow_date
FROM BorrowRecords br
JOIN Books b ON br.book_id = b.book_id
JOIN Members m ON br.member_id = m.member_id
WHERE br.return_date IS NULL AND br.borrow_date < DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY);

-- Borrow transaction with rollback
START TRANSACTION;
-- Check if book is available
SELECT is_available INTO @is_available FROM Books WHERE book_id = 1;
IF @is_available THEN
    INSERT INTO BorrowRecords VALUES (3, 1, 1002, CURRENT_DATE, NULL);
    UPDATE Books SET is_available = FALSE WHERE book_id = 1;
    COMMIT;
ELSE
    ROLLBACK;
END IF;



#5. Hospital Appointment & Doctor Tracker


-- Create tables
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(100)
);

CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    dob DATE
);

CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    doctor_id INT,
    patient_id INT,
    appointment_date DATETIME NOT NULL,
    status VARCHAR(20),
    CHECK (appointment_date > CURRENT_TIMESTAMP),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- Insert data
INSERT INTO Doctors VALUES 
(1, 'Dr. Anderson', 'Cardiology'),
(2, 'Dr. Baker', 'Pediatrics');

INSERT INTO Patients VALUES 
(1001, 'Lisa Taylor', '1985-07-15'),
(1002, 'James Wilson', '1990-11-22');

INSERT INTO Appointments VALUES 
(1, 1, 1001, '2023-10-15 10:00:00', 'Scheduled'),
(2, 2, 1002, '2023-10-16 14:30:00', 'Scheduled'),
(3, 1, 1002, '2023-10-17 11:00:00', 'Scheduled');

-- Doctor schedules
SELECT d.doctor_name, a.appointment_date, p.patient_name
FROM Appointments a
JOIN Doctors d ON a.doctor_id = d.doctor_id
JOIN Patients p ON a.patient_id = p.patient_id
ORDER BY d.doctor_name, a.appointment_date;

-- Search patients by name
SELECT * FROM Patients WHERE patient_name LIKE '%Wilson%';

-- Doctors with most patients
SELECT d.doctor_name, COUNT(DISTINCT a.patient_id) as patient_count
FROM Appointments a
JOIN Doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_name
ORDER BY patient_count DESC;

-- Reschedule appointment
UPDATE Appointments 
SET appointment_date = '2023-10-15 11:00:00' 
WHERE appointment_id = 1;

-- Cancel appointment
DELETE FROM Appointments WHERE appointment_id = 2;



#6. Bank Transaction Verifier


-- Create tables
CREATE TABLE Accounts (
    account_id INT PRIMARY KEY,
    account_holder VARCHAR(100) NOT NULL,
    balance DECIMAL(12,2) DEFAULT 0.00
);

CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT,
    amount DECIMAL(10,2) NOT NULL,
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    type ENUM('Deposit', 'Withdrawal', 'Transfer'),
    CHECK (amount > 0),
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

-- Insert data
INSERT INTO Accounts VALUES 
(1001, 'Robert Johnson', 5000.00),
(1002, 'Maria Garcia', 3000.00);

INSERT INTO Transactions VALUES 
(1, 1001, 500.00, '2023-09-01 10:00:00', 'Deposit'),
(2, 1001, 200.00, '2023-09-02 11:30:00', 'Withdrawal'),
(3, 1002, 1000.00, '2023-09-01 09:45:00', 'Deposit');

-- Account balances with transactions
SELECT a.account_holder, a.balance, 
       SUM(CASE WHEN t.type = 'Deposit' THEN t.amount ELSE 0 END) as total_deposits,
       SUM(CASE WHEN t.type = 'Withdrawal' THEN t.amount ELSE 0 END) as total_withdrawals
FROM Accounts a
LEFT JOIN Transactions t ON a.account_id = t.account_id
GROUP BY a.account_id;

-- Transfer simulation with transaction
START TRANSACTION;
-- Withdraw from account 1001
INSERT INTO Transactions VALUES (4, 1001, 300.00, CURRENT_TIMESTAMP, 'Withdrawal');
UPDATE Accounts SET balance = balance - 300.00 WHERE account_id = 1001;

SAVEPOINT withdraw_complete;

-- Deposit to account 1002
INSERT INTO Transactions VALUES (5, 1002, 300.00, CURRENT_TIMESTAMP, 'Deposit');
UPDATE Accounts SET balance = balance + 300.00 WHERE account_id = 1002;

-- Verify balances are positive
SELECT balance INTO @balance1 FROM Accounts WHERE account_id = 1001;
SELECT balance INTO @balance2 FROM Accounts WHERE account_id = 1002;

IF @balance1 >= 0 AND @balance2 >= 0 THEN
    COMMIT;
ELSE
    ROLLBACK TO withdraw_complete;
    ROLLBACK;
END IF;


#7. E-Commerce Refund and Payment System


-- Create tables
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    amount DECIMAL(10,2),
    payment_date DATE,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Refunds (
    refund_id INT PRIMARY KEY,
    order_id INT,
    amount DECIMAL(10,2),
    refund_date DATE,
    reason VARCHAR(200),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Insert data
INSERT INTO Orders VALUES 
(1001, 1, '2023-09-01', 150.00, 'Completed'),
(1002, 2, '2023-09-05', 89.99, 'Completed');

INSERT INTO Payments VALUES 
(1, 1001, 150.00, '2023-09-01'),
(2, 1002, 89.99, '2023-09-05');

-- Process refund with transaction
START TRANSACTION;
-- Check if order is eligible for refund
SELECT status, total_amount INTO @status, @amount FROM Orders WHERE order_id = 1001;
IF @status = 'Completed' THEN
    -- Add refund record
    INSERT INTO Refunds VALUES (1, 1001, @amount, CURRENT_DATE, 'Customer request');
    -- Update order status
    UPDATE Orders SET status = 'Refunded' WHERE order_id = 1001;
    COMMIT;
ELSE
    ROLLBACK;
END IF;

-- Refund summaries
SELECT o.order_id, o.order_date, o.total_amount, 
       r.refund_date, r.reason,
       CASE 
           WHEN r.refund_id IS NOT NULL THEN 'Refunded'
           ELSE 'Not Refunded'
       END as refund_status
FROM Orders o
LEFT JOIN Refunds r ON o.order_id = r.order_id;

-- Categorize refund reasons
SELECT 
    reason,
    COUNT(*) as refund_count,
    CASE
        WHEN reason LIKE '%defective%' THEN 'Product Issue'
        WHEN reason LIKE '%customer request%' THEN 'Customer Request'
        ELSE 'Other'
    END as reason_category
FROM Refunds
GROUP BY reason_category;




#8. Warehouse Stock Movement System

-- Create tables
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    current_stock INT DEFAULT 0
);

CREATE TABLE Inward (
    inward_id INT PRIMARY KEY,
    product_id INT,
    quantity INT,
    movement_date DATE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Outward (
    outward_id INT PRIMARY KEY,
    product_id INT,
    quantity INT,
    movement_date DATE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE StockLevels (
    stock_id INT PRIMARY KEY,
    product_id INT,
    quantity INT,
    record_date DATE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Insert data
INSERT INTO Products VALUES 
(1, 'Laptop', 50),
(2, 'Monitor', 30);

-- Stock movement transaction
START TRANSACTION;
-- Record inward movement
INSERT INTO Inward VALUES (1, 1, 10, CURRENT_DATE);
UPDATE Products SET current_stock = current_stock + 10 WHERE product_id = 1;

-- Record stock level snapshot
INSERT INTO StockLevels VALUES (1, 1, (SELECT current_stock FROM Products WHERE product_id = 1), CURRENT_DATE);

-- Verify stock is not negative
SELECT current_stock INTO @stock FROM Products WHERE product_id = 1;
IF @stock >= 0 THEN
    COMMIT;
ELSE
    ROLLBACK;
END IF;

-- Net stock calculation
SELECT p.product_name, 
       p.current_stock,
       COALESCE(SUM(i.quantity), 0) as total_inward,
       COALESCE(SUM(o.quantity), 0) as total_outward,
       (COALESCE(SUM(i.quantity), 0) - COALESCE(SUM(o.quantity), 0)) as net_movement
FROM Products p
LEFT JOIN Inward i ON p.product_id = i.product_id
LEFT JOIN Outward o ON p.product_id = o.product_id
GROUP BY p.product_id;

-- Items with potential negative stock
SELECT p.product_name, p.current_stock
FROM Products p
HAVING p.current_stock < 0;




#9. Student Marks & Rank Processing System


-- Create tables
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    class VARCHAR(50)
);

CREATE TABLE Subjects (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL
);

CREATE TABLE Marks (
    mark_id INT PRIMARY KEY,
    student_id INT,
    subject_id INT,
    score DECIMAL(5,2) CHECK (score >= 0 AND score <= 100),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
);

-- Insert data
INSERT INTO Students VALUES 
(1, 'Emma Watson', '10A'),
(2, 'Daniel Radcliffe', '10A');

INSERT INTO Subjects VALUES 
(101, 'Mathematics'),
(102, 'Science');

INSERT INTO Marks VALUES 
(1, 1, 101, 85.5),
(2, 1, 102, 92.0),
(3, 2, 101, 78.0),
(4, 2, 102, 88.5);

-- Total marks per student
SELECT s.student_name, SUM(m.score) as total_marks
FROM Students s
JOIN Marks m ON s.student_id = m.student_id
GROUP BY s.student_id
ORDER BY total_marks DESC;

-- Student rankings
SELECT 
    student_name,
    total_marks,
    RANK() OVER (ORDER BY total_marks DESC) as student_rank
FROM (
    SELECT s.student_name, SUM(m.score) as total_marks
    FROM Students s
    JOIN Marks m ON s.student_id = m.student_id
    GROUP BY s.student_id
) as mark_totals;

-- Grade classification
SELECT 
    student_name,
    subject_name,
    score,
    CASE
        WHEN score >= 90 THEN 'A'
        WHEN score >= 80 THEN 'B'
        WHEN score >= 70 THEN 'C'
        WHEN score >= 60 THEN 'D'
        ELSE 'F'
    END as grade
FROM Marks m
JOIN Students s ON m.student_id = s.student_id
JOIN Subjects sub ON m.subject_id = sub.subject_id;


#10. Customer Loyalty Points System

-- Create tables
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    join_date DATE
);

CREATE TABLE Purchases (
    purchase_id INT PRIMARY KEY,
    customer_id INT,
    amount DECIMAL(10,2),
    purchase_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Points (
    point_id INT PRIMARY KEY,
    customer_id INT,
    points_earned INT,
    transaction_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Insert data
INSERT INTO Customers VALUES 
(1, 'Olivia Martinez', '2022-01-15'),
(2, 'William Taylor', '2022-03-20');

INSERT INTO Purchases VALUES 
(1, 1, 120.00, '2023-09-01'),
(2, 1, 75.50, '2023-09-15'),
(3, 2, 200.00, '2023-09-10');

-- Total spending and points
SELECT 
    c.customer_name,
    SUM(p.amount) as total_spending,
    SUM(p.amount) * 10 as total_points -- Assuming 10 points per dollar
FROM Customers c
JOIN Purchases p ON c.customer_id = p.customer_id
GROUP BY c.customer_id;

-- Loyalty levels
SELECT 
    customer_name,
    total_spending,
    CASE
        WHEN total_spending >= 500 THEN 'Gold'
        WHEN total_spending >= 200 THEN 'Silver'
        ELSE 'Bronze'
    END as loyalty_level
FROM (
    SELECT 
        c.customer_name,
        SUM(p.amount) as total_spending
    FROM Customers c
    JOIN Purchases p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id
) as customer_totals;

-- Top spender of the month
SELECT 
    c.customer_name,
    SUM(p.amount) as monthly_spending
FROM Customers c
JOIN Purchases p ON c.customer_id = p.customer_id
WHERE p.purchase_date BETWEEN '2023-09-01' AND '2023-09-30'
GROUP BY c.customer_id
ORDER BY monthly_spending DESC
LIMIT 1;

-- Insert points with purchase in transaction
START TRANSACTION;
-- Record purchase
INSERT INTO Purchases VALUES (4, 2, 150.00, CURRENT_DATE);
-- Record points (10 points per dollar)
INSERT INTO Points VALUES (1, 2, 1500, CURRENT_DATE);
COMMIT;




















# SQL QUERIES FOR 20 PRACTICAL SCENARIOS

/* 1. EMPLOYEE PERFORMANCE ANALYZER */
CREATE TABLE Departments (dept_id INT PRIMARY KEY, dept_name VARCHAR(50));
CREATE TABLE Employees (emp_id INT PRIMARY KEY, emp_name VARCHAR(100), dept_id INT, performance_score INT);
CREATE TABLE Salaries (salary_id INT PRIMARY KEY, emp_id INT, salary DECIMAL(10,2), effective_date DATE);

INSERT INTO Departments VALUES (1,'HR'),(2,'IT'),(3,'Finance');
INSERT INTO Employees VALUES (101,'John Doe',1,85),(102,'Jane Smith',2,92);
INSERT INTO Salaries VALUES (1,101,50000,'2023-01-01'),(2,102,65000,'2023-01-01');

-- High performers
SELECT e.emp_name, s.salary FROM Employees e JOIN Salaries s ON e.emp_id=s.emp_id 
WHERE e.performance_score>80 ORDER BY e.performance_score DESC;

-- Department averages
SELECT d.dept_name, AVG(s.salary) FROM Departments d 
JOIN Employees e ON d.dept_id=e.dept_id JOIN Salaries s ON e.emp_id=s.emp_id GROUP BY d.dept_name;

/* 2. ONLINE COURSE ENROLLMENT REPORT */
CREATE TABLE Students (student_id INT PRIMARY KEY, student_name VARCHAR(100));
CREATE TABLE Courses (course_id INT PRIMARY KEY, course_name VARCHAR(100));
CREATE TABLE Enrollments (enrollment_id INT PRIMARY KEY, student_id INT, course_id INT);
CREATE TABLE Grades (grade_id INT PRIMARY KEY, enrollment_id INT, score DECIMAL(5,2));

-- Students above average
SELECT s.student_name FROM Students s JOIN Enrollments e ON s.student_id=e.student_id 
JOIN Grades g ON e.enrollment_id=g.enrollment_id WHERE g.score > (SELECT AVG(score) FROM Grades);

/* 3. RETAIL ORDER SUMMARY DASHBOARD */
CREATE TABLE Customers (customer_id INT PRIMARY KEY, customer_name VARCHAR(100));
CREATE TABLE Products (product_id INT PRIMARY KEY, product_name VARCHAR(100), price DECIMAL(10,2));
CREATE TABLE Orders (order_id INT PRIMARY KEY, customer_id INT, order_date DATE);
CREATE TABLE OrderItems (order_item_id INT PRIMARY KEY, order_id INT, product_id INT, quantity INT);

-- Daily sales
SELECT o.order_date, SUM(oi.quantity*p.price) FROM Orders o 
JOIN OrderItems oi ON o.order_id=oi.order_id JOIN Products p ON oi.product_id=p.product_id 
GROUP BY o.order_date;

/* 4. LIBRARY BORROWING MANAGEMENT */
CREATE TABLE Books (book_id INT PRIMARY KEY, title VARCHAR(200), is_available BOOLEAN);
CREATE TABLE Members (member_id INT PRIMARY KEY, member_name VARCHAR(100));
CREATE TABLE BorrowRecords (record_id INT PRIMARY KEY, book_id INT, member_id INT, borrow_date DATE, return_date DATE);

-- Overdue books
SELECT b.title, m.member_name FROM BorrowRecords br 
JOIN Books b ON br.book_id=b.book_id JOIN Members m ON br.member_id=m.member_id 
WHERE br.return_date IS NULL AND br.borrow_date < DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY);

/* 5. HOSPITAL APPOINTMENT TRACKER */
CREATE TABLE Doctors (doctor_id INT PRIMARY KEY, doctor_name VARCHAR(100), specialty VARCHAR(100));
CREATE TABLE Patients (patient_id INT PRIMARY KEY, patient_name VARCHAR(100));
CREATE TABLE Appointments (appointment_id INT PRIMARY KEY, doctor_id INT, patient_id INT, appointment_date DATETIME);

-- Doctor schedules
SELECT d.doctor_name, a.appointment_date, p.patient_name FROM Appointments a 
JOIN Doctors d ON a.doctor_id=d.doctor_id JOIN Patients p ON a.patient_id=p.patient_id 
ORDER BY d.doctor_name, a.appointment_date;

/* 6. BANK TRANSACTION VERIFIER */
CREATE TABLE Accounts (account_id INT PRIMARY KEY, account_holder VARCHAR(100), balance DECIMAL(12,2));
CREATE TABLE Transactions (transaction_id INT PRIMARY KEY, account_id INT, amount DECIMAL(10,2), type ENUM('Deposit','Withdrawal'));

-- Transfer transaction
START TRANSACTION;
UPDATE Accounts SET balance=balance-300 WHERE account_id=1001;
UPDATE Accounts SET balance=balance+300 WHERE account_id=1002;
COMMIT;

/* 7. E-COMMERCE REFUND SYSTEM */
CREATE TABLE Orders (order_id INT PRIMARY KEY, customer_id INT, total_amount DECIMAL(10,2), status VARCHAR(20));
CREATE TABLE Payments (payment_id INT PRIMARY KEY, order_id INT, amount DECIMAL(10,2));
CREATE TABLE Refunds (refund_id INT PRIMARY KEY, order_id INT, amount DECIMAL(10,2), reason VARCHAR(200));

-- Refund processing
START TRANSACTION;
INSERT INTO Refunds VALUES (1,1001,150.00,'Customer request');
UPDATE Orders SET status='Refunded' WHERE order_id=1001;
COMMIT;

/* 8. WAREHOUSE STOCK SYSTEM */
CREATE TABLE Products (product_id INT PRIMARY KEY, product_name VARCHAR(100), current_stock INT);
CREATE TABLE Inward (inward_id INT PRIMARY KEY, product_id INT, quantity INT);
CREATE TABLE Outward (outward_id INT PRIMARY KEY, product_id INT, quantity INT);

-- Negative stock check
SELECT product_name FROM Products WHERE current_stock < 0;

/* 9. STUDENT MARK PROCESSING */
CREATE TABLE Students (student_id INT PRIMARY KEY, student_name VARCHAR(100));
CREATE TABLE Subjects (subject_id INT PRIMARY KEY, subject_name VARCHAR(100));
CREATE TABLE Marks (mark_id INT PRIMARY KEY, student_id INT, subject_id INT, score DECIMAL(5,2));

-- Student rankings
SELECT student_name, SUM(score) as total_marks FROM Students s 
JOIN Marks m ON s.student_id=m.student_id GROUP BY s.student_id ORDER BY total_marks DESC;

/* 10. LOYALTY POINTS SYSTEM */
CREATE TABLE Customers (customer_id INT PRIMARY KEY, customer_name VARCHAR(100));
CREATE TABLE Purchases (purchase_id INT PRIMARY KEY, customer_id INT, amount DECIMAL(10,2));
CREATE TABLE Points (point_id INT PRIMARY KEY, customer_id INT, points_earned INT);

-- Top spender
SELECT c.customer_name, SUM(p.amount) FROM Customers c 
JOIN Purchases p ON c.customer_id=p.customer_id GROUP BY c.customer_id ORDER BY SUM(p.amount) DESC LIMIT 1;

/* 11. UNIVERSITY COURSE CAPACITY */
CREATE TABLE Courses (course_id INT PRIMARY KEY, course_name VARCHAR(100), max_capacity INT);
CREATE TABLE Enrollments (enrollment_id INT PRIMARY KEY, course_id INT, student_id INT);

-- Over-capacity courses
SELECT c.course_name FROM Courses c JOIN 
(SELECT course_id, COUNT(*) as enrolled FROM Enrollments GROUP BY course_id) e 
ON c.course_id=e.course_id WHERE enrolled > max_capacity;

/* 12. HOTEL RESERVATION SYSTEM */
CREATE TABLE Rooms (room_id INT PRIMARY KEY, room_type VARCHAR(50));
CREATE TABLE Customers (customer_id INT PRIMARY KEY, customer_name VARCHAR(100));
CREATE TABLE Bookings (booking_id INT PRIMARY KEY, room_id INT, customer_id INT, check_in DATE, check_out DATE);

-- Overlapping bookings
SELECT b1.booking_id, b2.booking_id FROM Bookings b1 JOIN Bookings b2 
ON b1.room_id=b2.room_id WHERE b1.check_in < b2.check_out AND b1.check_out > b2.check_in AND b1.booking_id != b2.booking_id;

/* 13. DOCTOR SPECIALTY FILTER */
CREATE TABLE Doctors (doctor_id INT PRIMARY KEY, doctor_name VARCHAR(100), specialty VARCHAR(100));
CREATE TABLE Appointments (appointment_id INT PRIMARY KEY, doctor_id INT, patient_id INT);

-- Overloaded doctors
SELECT d.doctor_name, COUNT(*) as appointments FROM Doctors d 
JOIN Appointments a ON d.doctor_id=a.doctor_id GROUP BY d.doctor_id HAVING COUNT(*) > 5;

/* 14. COMPLAINT TICKETING SYSTEM */
CREATE TABLE Tickets (ticket_id INT PRIMARY KEY, user_id INT, issue_date DATE, status VARCHAR(20));
CREATE TABLE Responses (response_id INT PRIMARY KEY, ticket_id INT, response_date DATE);

-- Unresolved tickets
SELECT t.ticket_id FROM Tickets t LEFT JOIN Responses r ON t.ticket_id=r.ticket_id 
WHERE r.response_id IS NULL AND t.issue_date < DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY);

/* 15. TRANSPORT ROUTE ANALYZER */
CREATE TABLE Routes (route_id INT PRIMARY KEY, route_name VARCHAR(100));
CREATE TABLE Bookings (booking_id INT PRIMARY KEY, route_id INT, booking_date DATE);

-- Most booked route
SELECT r.route_name, COUNT(*) as bookings FROM Routes r 
JOIN Bookings b ON r.route_id=b.route_id GROUP BY r.route_id ORDER BY bookings DESC LIMIT 1;

/* 16. SALES INCENTIVE PROCESSOR */
CREATE TABLE Salespeople (salesperson_id INT PRIMARY KEY, salesperson_name VARCHAR(100));
CREATE TABLE Sales (sale_id INT PRIMARY KEY, salesperson_id INT, amount DECIMAL(10,2), sale_date DATE);

-- Bonus tiers
SELECT salesperson_name, SUM(amount),
  CASE
    WHEN SUM(amount) > 10000 THEN 'Gold'
    WHEN SUM(amount) > 5000 THEN 'Silver'
    ELSE 'Bronze'
  END as tier
FROM Salespeople s JOIN Sales sl ON s.salesperson_id=sl.salesperson_id GROUP BY s.salesperson_id;

/* 17. INSURANCE CLAIM SYSTEM */
CREATE TABLE Claims (claim_id INT PRIMARY KEY, policy_id INT, amount DECIMAL(10,2), document_received BOOLEAN);

-- Missing documents
SELECT claim_id FROM Claims WHERE document_received = FALSE;

/* 18. DAILY SALES COMPARISON */
CREATE TABLE DailySales (sale_id INT PRIMARY KEY, sale_date DATE, amount DECIMAL(10,2));

-- Sales comparison
SELECT today.sale_date, today.amount, yesterday.amount as prev_day_amount,
  CASE
    WHEN today.amount > yesterday.amount THEN 'Increase'
    WHEN today.amount < yesterday.amount THEN 'Decrease'
    ELSE 'No Change'
  END as trend
FROM DailySales today JOIN DailySales yesterday ON today.sale_date = DATE_ADD(yesterday.sale_date, INTERVAL 1 DAY);

/* 19. MULTI-STORE INVENTORY */
CREATE TABLE StoreInventory (inventory_id INT PRIMARY KEY, store_id INT, product_id INT, quantity INT);

-- Inventory differences
SELECT product_id FROM StoreInventory WHERE store_id=1
EXCEPT
SELECT product_id FROM StoreInventory WHERE store_id=2;

/* 20. EXAM RESULT PORTAL */
CREATE TABLE Candidates (candidate_id INT PRIMARY KEY, candidate_name VARCHAR(100));
CREATE TABLE ExamResults (result_id INT PRIMARY KEY, candidate_id INT, score DECIMAL(5,2));

-- Pass/Fail status
SELECT c.candidate_name, e.score,
  CASE WHEN e.score >= 50 THEN 'Pass' ELSE 'Fail' END as status
FROM Candidates c JOIN ExamResults e ON c.candidate_id=e.candidate_id;