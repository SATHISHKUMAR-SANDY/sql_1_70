-- Task 1: Create Employees table
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    dept_id INT,
    salary DECIMAL(10, 2)
);

-- Task 2: Insert 15 employee records
INSERT INTO Employees VALUES 
(1, 'John', 101, 50000),
(2, 'Jane', 102, 60000),
(3, 'Michael', 101, 55000),
(4, 'Sarah', 103, 65000),
(5, 'David', 102, 52000),
(6, 'Emily', 101, 58000),
(7, 'Robert', 103, 62000),
(8, 'Jennifer', 102, 54000),
(9, 'William', 101, 59000),
(10, 'Lisa', 103, 63000),
(11, 'James', 102, 56000),
(12, 'Jessica', 101, 61000),
(13, 'Thomas', 103, 57000),
(14, 'Amy', 102, 64000),
(15, 'Daniel', 101, 53000);

-- Task 3: Create index on emp_name
CREATE INDEX idx_emp_name ON Employees(emp_name);

-- Task 4: Run SELECT query with WHERE emp_name = 'John'
SELECT * FROM Employees WHERE emp_name = 'John';

-- Task 5: Use EXPLAIN to check index usage
EXPLAIN SELECT * FROM Employees WHERE emp_name = 'John';

-- Task 6: Create compound index on (dept_id, salary)
CREATE INDEX idx_dept_salary ON Employees(dept_id, salary);

-- Test compound index
SELECT * FROM Employees WHERE dept_id = 101 AND salary > 55000;

-- Task 7: Drop index on emp_name
DROP INDEX idx_emp_name ON Employees;

-- Task 8: Create Departments table
CREATE TABLE Departments (
    dept_id INT,
    dept_name VARCHAR(100)
);

-- Task 9: Create PRIMARY KEY on dept_id (clustered index)
ALTER TABLE Departments ADD PRIMARY KEY (dept_id);

-- Task 10: Create non-clustered index on dept_name
CREATE INDEX idx_dept_name ON Departments(dept_name);

-- Task 11: JOIN query between Employees and Departments
INSERT INTO Departments VALUES 
(101, 'HR'),
(102, 'IT'),
(103, 'Finance');

SELECT e.emp_name, d.dept_name, e.salary
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id;

-- Task 12: Compare JOIN performance with/without indexes
EXPLAIN SELECT e.emp_name, d.dept_name, e.salary
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id;

-- Task 13: SELECT with ORDER BY emp_name
-- Without index
EXPLAIN SELECT * FROM Employees ORDER BY emp_name;

-- With index
CREATE INDEX idx_emp_name_ordered ON Employees(emp_name);
EXPLAIN SELECT * FROM Employees ORDER BY emp_name;

-- Task 14: Insert 1,000+ dummy records and measure performance
-- This would be done with a loop or bulk insert in practice
-- For demonstration:
INSERT INTO Employees
SELECT 
    n + 15, 
    CONCAT('Employee', n), 
    FLOOR(RAND() * 3) + 101, 
    RAND() * 50000 + 30000
FROM (
    SELECT a.N + b.N * 10 + c.N * 100 AS n
    FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a
    CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
    CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) c
) numbers
WHERE n <= 1000;

-- Measure performance with index
SELECT * FROM Employees WHERE emp_name = 'Employee500'; -- Fast with index

-- Measure performance without index
DROP INDEX idx_emp_name_ordered ON Employees;
SELECT * FROM Employees WHERE emp_name = 'Employee500'; -- Slower without index

-- Task 15: Identify columns where indexing should be avoided
/*
Columns where indexing should be avoided:
1. Columns with very low cardinality (few unique values)
2. Columns that are frequently updated
3. Columns rarely used in WHERE, JOIN, or ORDER BY clauses
4. Very small tables where indexes wouldn't provide benefit
5. Binary/BLOB data types
*/






-- Task 16: Analyze full table scan and optimize with indexing
EXPLAIN SELECT * FROM Employees WHERE salary > 60000;
CREATE INDEX idx_salary ON Employees(salary);
EXPLAIN SELECT * FROM Employees WHERE salary > 60000;

-- Task 17: Optimize SELECT * by specifying only required columns
-- Before optimization
SELECT * FROM Employees;

-- After optimization
SELECT emp_id, emp_name, salary FROM Employees;

-- Task 18: Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE
);

-- Task 19: Insert 20+ sample orders and analyze with EXPLAIN
INSERT INTO Orders VALUES
(1, 101, '2023-01-15'),
(2, 102, '2023-01-16'),
(3, 103, '2023-01-17'),
(4, 101, '2023-01-18'),
(5, 104, '2023-01-19'),
(6, 102, '2023-01-20'),
(7, 105, '2023-01-21'),
(8, 103, '2023-01-22'),
(9, 101, '2023-01-23'),
(10, 106, '2023-01-24'),
(11, 102, '2023-01-25'),
(12, 104, '2023-01-26'),
(13, 107, '2023-01-27'),
(14, 103, '2023-01-28'),
(15, 101, '2023-01-29'),
(16, 105, '2023-01-30'),
(17, 102, '2023-01-31'),
(18, 108, '2023-02-01'),
(19, 104, '2023-02-02'),
(20, 101, '2023-02-03');

EXPLAIN SELECT * FROM Orders;

-- Task 20: Create index on order_date and rerun EXPLAIN
CREATE INDEX idx_order_date ON Orders(order_date);
EXPLAIN SELECT * FROM Orders WHERE order_date > '2023-01-25';

-- Task 21: Retrieve orders in last 7 days
SELECT * FROM Orders 
WHERE order_date BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY) AND CURRENT_DATE();

-- Task 22: Replace subquery with JOIN and compare performance
-- Subquery version
EXPLAIN SELECT * FROM Orders 
WHERE customer_id IN (SELECT customer_id FROM Customers WHERE customer_name LIKE 'A%');

-- JOIN version
EXPLAIN SELECT o.* FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE c.customer_name LIKE 'A%';

-- Task 23: Optimize complex query by reducing columns
-- Before optimization
SELECT e.*, d.* 
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
WHERE e.salary > 50000 AND d.dept_name = 'IT';

-- After optimization
SELECT e.emp_name, e.salary, d.dept_name
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
WHERE e.salary > 50000 AND d.dept_name = 'IT';

-- Task 24: Create view using optimized query
CREATE VIEW vw_high_paid_employees AS
SELECT e.emp_name, e.salary, d.dept_name
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
WHERE e.salary > 50000;

-- Task 25: Test performance with/without LIMIT
-- Without LIMIT
EXPLAIN SELECT * FROM Employees;

-- With LIMIT
EXPLAIN SELECT * FROM Employees LIMIT 10;




-- Task 26: Create Customers table and retrieve first 5 customers
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO Customers VALUES
(101, 'Alice', 'alice@example.com'),
(102, 'Bob', 'bob@example.com'),
(103, 'Charlie', 'charlie@example.com'),
(104, 'David', 'david@example.com'),
(105, 'Eve', 'eve@example.com'),
(106, 'Frank', 'frank@example.com'),
(107, 'Grace', 'grace@example.com'),
(108, 'Henry', 'henry@example.com'),
(109, 'Ivy', 'ivy@example.com'),
(110, 'Jack', 'jack@example.com');

SELECT * FROM Customers LIMIT 5;

-- Task 27: Retrieve top 10 products by price
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

INSERT INTO Products VALUES
(1, 'Laptop', 999.99),
(2, 'Phone', 699.99),
(3, 'Tablet', 399.99),
(4, 'Monitor', 249.99),
(5, 'Keyboard', 49.99),
(6, 'Mouse', 29.99),
(7, 'Printer', 199.99),
(8, 'Scanner', 149.99),
(9, 'Headphones', 99.99),
(10, 'Speaker', 79.99),
(11, 'Camera', 499.99),
(12, 'Smartwatch', 199.99);

SELECT * FROM Products ORDER BY price DESC LIMIT 10;

-- Task 28: Combine WHERE, ORDER BY, and LIMIT
SELECT * FROM Products 
WHERE price > 100 
ORDER BY price DESC 
LIMIT 5;

-- Task 29: Test performance with LIMIT vs full query
-- Create a large table for testing
CREATE TABLE large_table AS
SELECT n AS id, CONCAT('Item', n) AS name, RAND() * 1000 AS value
FROM (
    SELECT a.N + b.N * 10 + c.N * 100 + d.N * 1000 AS n
    FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a
    CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
    CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) c
    CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) d
) numbers
WHERE n <= 10000;

-- Test performance
EXPLAIN SELECT * FROM large_table; -- Full table scan
EXPLAIN SELECT * FROM large_table LIMIT 5; -- Faster with LIMIT

-- Task 30: Implement pagination with LIMIT and OFFSET
-- Page 1 (records 1-10)
SELECT * FROM large_table ORDER BY id LIMIT 10 OFFSET 0;

-- Page 2 (records 11-20)
SELECT * FROM large_table ORDER BY id LIMIT 10 OFFSET 10;

-- Page 3 (records 21-30)
SELECT * FROM large_table ORDER BY id LIMIT 10 OFFSET 20;




-- Task 31: Create Products table with PRIMARY KEY (clustered)
CREATE TABLE Products_clustered (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

-- Task 32: Add non-clustered index on product_name
CREATE INDEX idx_product_name ON Products_clustered(product_name);

-- Task 33: Insert 10 sample products and query
INSERT INTO Products_clustered VALUES
(1, 'Laptop', 999.99),
(2, 'Smartphone', 699.99),
(3, 'Tablet', 399.99),
(4, 'Monitor', 249.99),
(5, 'Keyboard', 49.99),
(6, 'Mouse', 29.99),
(7, 'Printer', 199.99),
(8, 'Headphones', 99.99),
(9, 'Speaker', 79.99),
(10, 'Webcam', 59.99);

SELECT * FROM Products_clustered WHERE product_name LIKE '%lap%';

-- Task 34: Explain execution difference using EXPLAIN
EXPLAIN SELECT * FROM Products_clustered WHERE product_id = 5; -- Uses clustered index
EXPLAIN SELECT * FROM Products_clustered WHERE product_name LIKE '%lap%'; -- Uses non-clustered index

-- Task 35: Drop non-clustered index and test impact
DROP INDEX idx_product_name ON Products_clustered;
EXPLAIN SELECT * FROM Products_clustered WHERE product_name LIKE '%lap%'; -- Now does full table scan


-- Task 36: Create unnormalized SalesData table
CREATE TABLE SalesData_unnormalized (
    order_id INT,
    order_date DATE,
    customer_name VARCHAR(100),
    product1_name VARCHAR(100),
    product1_price DECIMAL(10, 2),
    product1_qty INT,
    product2_name VARCHAR(100),
    product2_price DECIMAL(10, 2),
    product2_qty INT,
    product3_name VARCHAR(100),
    product3_price DECIMAL(10, 2),
    product3_qty INT
);

INSERT INTO SalesData_unnormalized VALUES
(101, '2023-01-15', 'Alice', 'Laptop', 999.99, 1, 'Mouse', 29.99, 2, 'Keyboard', 49.99, 1),
(102, '2023-01-16', 'Bob', 'Monitor', 249.99, 2, NULL, NULL, NULL, NULL, NULL, NULL),
(103, '2023-01-17', 'Charlie', 'Tablet', 399.99, 1, 'Headphones', 99.99, 1, NULL, NULL, NULL);

-- Task 37: Apply 1NF - Remove repeating groups
CREATE TABLE Orders_1NF (
    order_id INT,
    order_date DATE,
    customer_name VARCHAR(100)
);

CREATE TABLE OrderItems_1NF (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_name VARCHAR(100),
    product_price DECIMAL(10, 2),
    quantity INT
);

INSERT INTO Orders_1NF VALUES
(101, '2023-01-15', 'Alice'),
(102, '2023-01-16', 'Bob'),
(103, '2023-01-17', 'Charlie');

INSERT INTO OrderItems_1NF (order_id, product_name, product_price, quantity) VALUES
(101, 'Laptop', 999.99, 1),
(101, 'Mouse', 29.99, 2),
(101, 'Keyboard', 49.99, 1),
(102, 'Monitor', 249.99, 2),
(103, 'Tablet', 399.99, 1),
(103, 'Headphones', 99.99, 1);

-- Task 38: Apply 2NF - Remove partial dependency
CREATE TABLE Products_2NF (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

CREATE TABLE OrderItems_2NF (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (product_id) REFERENCES Products_2NF(product_id)
);

-- Populate Products table
INSERT INTO Products_2NF (product_name, price) VALUES
('Laptop', 999.99),
('Mouse', 29.99),
('Keyboard', 49.99),
('Monitor', 249.99),
('Tablet', 399.99),
('Headphones', 99.99);

-- Update OrderItems with product_id references
INSERT INTO OrderItems_2NF (order_id, product_id, quantity) VALUES
(101, 1, 1), -- Laptop
(101, 2, 2), -- Mouse
(101, 3, 1), -- Keyboard
(102, 4, 2), -- Monitor
(103, 5, 1), -- Tablet
(103, 6, 1); -- Headphones

-- Task 39: Apply 3NF - Remove transitive dependency
CREATE TABLE Customers_3NF (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100)
);

CREATE TABLE Orders_3NF (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers_3NF(customer_id)
);

-- Populate Customers
INSERT INTO Customers_3NF (customer_name) VALUES
('Alice'),
('Bob'),
('Charlie');

-- Update Orders with customer_id references
INSERT INTO Orders_3NF VALUES
(101, '2023-01-15', 1),
(102, '2023-01-16', 2),
(103, '2023-01-17', 3);

-- Task 40: Create fully normalized schema
-- This is essentially what we've done in Tasks 37-39, now with proper foreign keys

CREATE TABLE Customers_normalized (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE Products_normalized (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    category VARCHAR(50)
);

CREATE TABLE Orders_normalized (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers_normalized(customer_id)
);

CREATE TABLE OrderItems_normalized (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders_normalized(order_id),
    FOREIGN KEY (product_id) REFERENCES Products_normalized(product_id)
);


-- Task 41: Create denormalized table combining Orders, Customers, OrderItems
CREATE TABLE Sales_denormalized (
    order_id INT,
    order_date DATE,
    customer_id INT,
    customer_name VARCHAR(100),
    product_id INT,
    product_name VARCHAR(100),
    quantity INT,
    unit_price DECIMAL(10, 2),
    total_price DECIMAL(10, 2)
);

-- Task 42: Insert sample records with duplicated data
INSERT INTO Sales_denormalized VALUES
(101, '2023-01-15', 1, 'Alice', 1, 'Laptop', 1, 999.99, 999.99),
(101, '2023-01-15', 1, 'Alice', 2, 'Mouse', 2, 29.99, 59.98),
(101, '2023-01-15', 1, 'Alice', 3, 'Keyboard', 1, 49.99, 49.99),
(102, '2023-01-16', 2, 'Bob', 4, 'Monitor', 2, 249.99, 499.98),
(103, '2023-01-17', 3, 'Charlie', 5, 'Tablet', 1, 399.99, 399.99),
(103, '2023-01-17', 3, 'Charlie', 6, 'Headphones', 1, 99.99, 99.99);

-- Task 43: Query full order info without joins
SELECT * FROM Sales_denormalized WHERE order_id = 101;

-- Task 44: Compare performance normalized vs denormalized
-- Normalized query (requires joins)
EXPLAIN 
SELECT o.order_id, o.order_date, c.customer_name, p.product_name, oi.quantity, oi.unit_price
FROM Orders_normalized o
JOIN Customers_normalized c ON o.customer_id = c.customer_id
JOIN OrderItems_normalized oi ON o.order_id = oi.order_id
JOIN Products_normalized p ON oi.product_id = p.product_id
WHERE o.order_id = 101;

-- Denormalized query (no joins needed)
EXPLAIN 
SELECT * FROM Sales_denormalized WHERE order_id = 101;

-- Task 45: Document trade-offs
/*
Trade-offs between normalized and denormalized designs:

Normalized Pros:
- Minimizes data redundancy
- Reduces update anomalies
- Better for transactional systems with frequent writes

Normalized Cons:
- More complex queries with multiple joins
- Potentially slower read performance

Denormalized Pros:
- Faster read performance
- Simpler queries
- Better for reporting and analytics

Denormalized Cons:
- Data redundancy
- Potential update anomalies
- Larger storage requirements
*/


-- Task 46: JOIN without index and measure time
-- First, create Customers table if not exists
CREATE TABLE IF NOT EXISTS Customers_perf (
    customer_id INT,
    customer_name VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO Customers_perf VALUES
(101, 'Alice', 'alice@example.com'),
(102, 'Bob', 'bob@example.com'),
(103, 'Charlie', 'charlie@example.com'),
(104, 'David', 'david@example.com'),
(105, 'Eve', 'eve@example.com');

-- Measure time (this would be done with timing commands in your SQL client)
SELECT o.*, c.customer_name 
FROM Orders o
JOIN Customers_perf c ON o.customer_id = c.customer_id;

-- Task 47: Add indexes and rerun JOIN
CREATE INDEX idx_customer_id_orders ON Orders(customer_id);
CREATE INDEX idx_customer_id_customers ON Customers_perf(customer_id);

-- Measure time again
SELECT o.*, c.customer_name 
FROM Orders o
JOIN Customers_perf c ON o.customer_id = c.customer_id;

-- Task 48: Compare subquery vs JOIN
-- Subquery version
EXPLAIN
SELECT * FROM Orders 
WHERE customer_id IN (SELECT customer_id FROM Customers_perf WHERE customer_name LIKE 'A%');

-- JOIN version
EXPLAIN
SELECT o.* FROM Orders o
JOIN Customers_perf c ON o.customer_id = c.customer_id
WHERE c.customer_name LIKE 'A%';

-- Task 49: Analyze GROUP BY with/without index
-- Without index
EXPLAIN
SELECT customer_id, COUNT(*) as order_count
FROM Orders
GROUP BY customer_id;

-- With index (already created idx_customer_id_orders)
-- The index should help with the GROUP BY operation

-- Task 50: Highly optimized report query
SELECT 
    c.customer_name,
    COUNT(o.order_id) as total_orders,
    SUM(oi.quantity * oi.unit_price) as total_spent,
    MAX(o.order_date) as last_order_date
FROM Customers_normalized c
JOIN Orders_normalized o ON c.customer_id = o.customer_id
JOIN OrderItems_normalized oi ON o.order_id = oi.order_id
WHERE o.order_date > DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH)
GROUP BY c.customer_id, c.customer_name
HAVING total_orders > 1
ORDER BY total_spent DESC
LIMIT 10;




-- 1. EMPLOYEE SEARCH OPTIMIZATION SYSTEM (HRMS)
CREATE DATABASE IF NOT EXISTS HRMS; USE HRMS;
CREATE TABLE Departments (dept_id INT PRIMARY KEY, dept_name VARCHAR(100), location VARCHAR(100));
CREATE TABLE Employees (emp_id INT PRIMARY KEY, emp_name VARCHAR(100), dept_id INT, salary DECIMAL(10,2), joining_date DATE, FOREIGN KEY (dept_id) REFERENCES Departments(dept_id));
INSERT INTO Departments VALUES (101,'HR','Floor1'),(102,'IT','Floor2'),(103,'Finance','Floor3'),(104,'Marketing','Floor4');
INSERT INTO Employees VALUES (1,'John Smith',101,50000,'2020-01-15'),(2,'Jane Doe',102,65000,'2019-05-22'),(3,'Michael Johnson',101,55000,'2021-03-10');
CREATE INDEX idx_emp_name ON Employees(emp_name); CREATE INDEX idx_dept_id ON Employees(dept_id); CREATE INDEX idx_joining_date ON Employees(joining_date);
EXPLAIN SELECT * FROM Employees WHERE emp_name = 'John Smith';
CREATE VIEW vw_employee_department AS SELECT e.emp_id, e.emp_name, e.salary, e.joining_date, d.dept_name, d.location FROM Employees e JOIN Departments d ON e.dept_id = d.dept_id;

-- 2. E-COMMERCE PRODUCT SEARCH ENGINE
CREATE DATABASE IF NOT EXISTS ECommerce; USE ECommerce;
CREATE TABLE Categories (category_id INT PRIMARY KEY, category_name VARCHAR(100), description TEXT);
CREATE TABLE Products (product_id INT PRIMARY KEY, product_name VARCHAR(100), category_id INT, price DECIMAL(10,2), stock_quantity INT, FOREIGN KEY (category_id) REFERENCES Categories(category_id));
CREATE TABLE Inventory (inventory_id INT PRIMARY KEY, product_id INT, warehouse_id INT, quantity INT, last_updated DATETIME, FOREIGN KEY (product_id) REFERENCES Products(product_id));
INSERT INTO Categories VALUES (1,'Electronics','Devices'),(2,'Clothing','Apparel'),(3,'Home','Kitchenware');
INSERT INTO Products VALUES (101,'Smartphone',1,699.99,50),(102,'Headphones',1,149.99,100),(103,'T-Shirt',2,19.99,200);
INSERT INTO Inventory VALUES (1,101,1,30,NOW()),(2,101,2,20,NOW()),(3,102,1,60,NOW());
CREATE INDEX idx_product_name ON Products(product_name); CREATE INDEX idx_category_id ON Products(category_id); CREATE INDEX idx_price ON Products(price);
CREATE VIEW vw_products_with_category AS SELECT p.product_id, p.product_name, p.price, p.stock_quantity, c.category_name FROM Products p JOIN Categories c ON p.category_id = c.category_id;

-- 3. LIBRARY BOOK SEARCH SYSTEM
CREATE DATABASE IF NOT EXISTS Library; USE Library;
CREATE TABLE Authors (author_id INT PRIMARY KEY, author_name VARCHAR(100), nationality VARCHAR(50));
CREATE TABLE Books (book_id INT PRIMARY KEY, title VARCHAR(200), author_id INT, isbn VARCHAR(20), publish_year INT, FOREIGN KEY (author_id) REFERENCES Authors(author_id));
CREATE TABLE BorrowHistory (borrow_id INT PRIMARY KEY, book_id INT, user_id INT, borrow_date DATE, return_date DATE, FOREIGN KEY (book_id) REFERENCES Books(book_id));
INSERT INTO Authors VALUES (1,'J.K. Rowling','British'),(2,'Stephen King','American'),(3,'Haruki Murakami','Japanese');
INSERT INTO Books VALUES (1,'Harry Potter',1,'1234567890',1997),(2,'The Shining',2,'2345678901',1977),(3,'Norwegian Wood',3,'3456789012',1987);
INSERT INTO BorrowHistory VALUES (1,1,101,'2023-01-15','2023-02-15'),(2,2,102,'2023-02-20','2023-03-20'),(3,3,103,'2023-03-10','2023-04-10');
CREATE INDEX idx_book_title ON Books(title); CREATE INDEX idx_author_name ON Authors(author_name); CREATE INDEX idx_borrow_date ON BorrowHistory(borrow_date);
CREATE VIEW vw_book_author AS SELECT b.book_id, b.title, a.author_name, b.publish_year FROM Books b JOIN Authors a ON b.author_id = a.author_id;

-- 4. SALES DASHBOARD WITH PERFORMANCE TUNING
CREATE DATABASE IF NOT EXISTS SalesDB; USE SalesDB;
CREATE TABLE Customers (customer_id INT PRIMARY KEY, customer_name VARCHAR(100), email VARCHAR(100));
CREATE TABLE Products (product_id INT PRIMARY KEY, product_name VARCHAR(100), price DECIMAL(10,2));
CREATE TABLE Sales (sale_id INT PRIMARY KEY, customer_id INT, product_id INT, sale_date DATE, quantity INT, amount DECIMAL(10,2), FOREIGN KEY (customer_id) REFERENCES Customers(customer_id), FOREIGN KEY (product_id) REFERENCES Products(product_id));
INSERT INTO Customers VALUES (1,'Alice','alice@example.com'),(2,'Bob','bob@example.com'),(3,'Charlie','charlie@example.com');
INSERT INTO Products VALUES (101,'Laptop',999.99),(102,'Phone',699.99),(103,'Tablet',399.99);
INSERT INTO Sales VALUES (1,1,101,'2023-01-15',1,999.99),(2,2,102,'2023-01-16',1,699.99),(3,3,103,'2023-01-17',2,799.98);
CREATE INDEX idx_sale_date ON Sales(sale_date); CREATE INDEX idx_product_id ON Sales(product_id); CREATE INDEX idx_customer_id ON Sales(customer_id);
CREATE VIEW vw_sales_report AS SELECT s.sale_id, c.customer_name, p.product_name, s.sale_date, s.quantity, s.amount FROM Sales s JOIN Customers c ON s.customer_id = c.customer_id JOIN Products p ON s.product_id = p.product_id;

-- 5. HOSPITAL PATIENT RECORDS SYSTEM
CREATE DATABASE IF NOT EXISTS Hospital; USE Hospital;
CREATE TABLE Patients (patient_id INT PRIMARY KEY, patient_name VARCHAR(100), dob DATE, gender CHAR(1));
CREATE TABLE Doctors (doctor_id INT PRIMARY KEY, doctor_name VARCHAR(100), specialization VARCHAR(100));
CREATE TABLE Visits (visit_id INT PRIMARY KEY, patient_id INT, doctor_id INT, visit_date DATE, diagnosis VARCHAR(200), FOREIGN KEY (patient_id) REFERENCES Patients(patient_id), FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id));
INSERT INTO Patients VALUES (1,'John Smith','1980-05-15','M'),(2,'Jane Doe','1975-08-22','F'),(3,'Michael Johnson','1990-03-10','M');
INSERT INTO Doctors VALUES (101,'Dr. Williams','Cardiology'),(102,'Dr. Brown','Neurology'),(103,'Dr. Lee','Orthopedics');
INSERT INTO Visits VALUES (1,1,101,'2023-01-15','Hypertension'),(2,2,102,'2023-01-16','Migraine'),(3,3,103,'2023-01-17','Fracture');
CREATE INDEX idx_patient_name ON Patients(patient_name); CREATE INDEX idx_doctor_id ON Visits(doctor_id); CREATE INDEX idx_visit_date ON Visits(visit_date);
CREATE VIEW vw_patient_visits AS SELECT v.visit_id, p.patient_name, d.doctor_name, v.visit_date, v.diagnosis FROM Visits v JOIN Patients p ON v.patient_id = p.patient_id JOIN Doctors d ON v.doctor_id = d.doctor_id;

-- 6. ONLINE COURSE ENROLLMENT PLATFORM
CREATE DATABASE IF NOT EXISTS ELearning; USE ELearning;
CREATE TABLE Students (student_id INT PRIMARY KEY, student_name VARCHAR(100), email VARCHAR(100));
CREATE TABLE Courses (course_id INT PRIMARY KEY, course_name VARCHAR(100), instructor VARCHAR(100), credit_hours INT);
CREATE TABLE Enrollments (enrollment_id INT PRIMARY KEY, student_id INT, course_id INT, enroll_date DATE, grade CHAR(2), FOREIGN KEY (student_id) REFERENCES Students(student_id), FOREIGN KEY (course_id) REFERENCES Courses(course_id));
INSERT INTO Students VALUES (1,'Alice','alice@school.com'),(2,'Bob','bob@school.com'),(3,'Charlie','charlie@school.com');
INSERT INTO Courses VALUES (101,'Database Systems','Dr. Smith',3),(102,'Web Development','Dr. Johnson',4),(103,'Data Science','Dr. Williams',3);
INSERT INTO Enrollments VALUES (1,1,101,'2023-01-15','A'),(2,2,102,'2023-01-16','B'),(3,3,103,'2023-01-17','A');
CREATE INDEX idx_student_name ON Students(student_name); CREATE INDEX idx_course_name ON Courses(course_name); CREATE INDEX idx_enroll_date ON Enrollments(enroll_date);
CREATE VIEW vw_student_courses AS SELECT e.enrollment_id, s.student_name, c.course_name, e.enroll_date, e.grade FROM Enrollments e JOIN Students s ON e.student_id = s.student_id JOIN Courses c ON e.course_id = c.course_id;

-- 7. TICKET BOOKING SYSTEM (BUS/TRAIN)
CREATE DATABASE IF NOT EXISTS Transport; USE Transport;
CREATE TABLE Passengers (passenger_id INT PRIMARY KEY, passenger_name VARCHAR(100), phone VARCHAR(20));
CREATE TABLE Routes (route_id INT PRIMARY KEY, origin VARCHAR(100), destination VARCHAR(100), departure_time TIME, arrival_time TIME);
CREATE TABLE Bookings (booking_id INT PRIMARY KEY, passenger_id INT, route_id INT, booking_date DATE, seat_number VARCHAR(10), FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id), FOREIGN KEY (route_id) REFERENCES Routes(route_id));
INSERT INTO Passengers VALUES (1,'Alice','555-0101'),(2,'Bob','555-0102'),(3,'Charlie','555-0103');
INSERT INTO Routes VALUES (101,'New York','Boston','08:00:00','11:00:00'),(102,'Chicago','St. Louis','09:30:00','13:45:00'),(103,'Seattle','Portland','07:15:00','09:30:00');
INSERT INTO Bookings VALUES (1,1,101,'2023-01-15','A12'),(2,2,102,'2023-01-16','B05'),(3,3,103,'2023-01-17','C08');
CREATE INDEX idx_passenger_name ON Passengers(passenger_name); CREATE INDEX idx_route_id ON Bookings(route_id); CREATE INDEX idx_booking_date ON Bookings(booking_date);
CREATE VIEW vw_booking_details AS SELECT b.booking_id, p.passenger_name, r.origin, r.destination, b.booking_date, b.seat_number FROM Bookings b JOIN Passengers p ON b.passenger_id = p.passenger_id JOIN Routes r ON b.route_id = r.route_id;

-- 8. BANKING TRANSACTION MONITOR
CREATE DATABASE IF NOT EXISTS Banking; USE Banking;
CREATE TABLE Customers (customer_id INT PRIMARY KEY, customer_name VARCHAR(100), account_type VARCHAR(50));
CREATE TABLE Accounts (account_id INT PRIMARY KEY, customer_id INT, balance DECIMAL(15,2), open_date DATE, FOREIGN KEY (customer_id) REFERENCES Customers(customer_id));
CREATE TABLE Transactions (transaction_id INT PRIMARY KEY, account_id INT, transaction_date DATETIME, amount DECIMAL(15,2), transaction_type VARCHAR(20), FOREIGN KEY (account_id) REFERENCES Accounts(account_id));
INSERT INTO Customers VALUES (1,'Alice','Checking'),(2,'Bob','Savings'),(3,'Charlie','Checking');
INSERT INTO Accounts VALUES (101,1,5000.00,'2020-01-15'),(102,2,15000.00,'2019-05-22'),(103,3,7500.00,'2021-03-10');
INSERT INTO Transactions VALUES (1,101,NOW(),100.00,'Deposit'),(2,102,NOW(),-50.00,'Withdrawal'),(3,103,NOW(),200.00,'Deposit');
CREATE INDEX idx_customer_name ON Customers(customer_name); CREATE INDEX idx_account_id ON Transactions(account_id); CREATE INDEX idx_transaction_date ON Transactions(transaction_date);
CREATE VIEW vw_account_transactions AS SELECT t.transaction_id, c.customer_name, a.account_id, t.transaction_date, t.amount, t.transaction_type FROM Transactions t JOIN Accounts a ON t.account_id = a.account_id JOIN Customers c ON a.customer_id = c.customer_id;

-- 9. WAREHOUSE INVENTORY OPTIMIZER
CREATE DATABASE IF NOT EXISTS Warehouse; USE Warehouse;
CREATE TABLE Items (item_id INT PRIMARY KEY, item_name VARCHAR(100), category VARCHAR(50), unit_price DECIMAL(10,2));
CREATE TABLE Warehouses (warehouse_id INT PRIMARY KEY, warehouse_name VARCHAR(100), location VARCHAR(100));
CREATE TABLE StockMovements (movement_id INT PRIMARY KEY, item_id INT, warehouse_id INT, movement_date DATE, quantity INT, movement_type VARCHAR(20), FOREIGN KEY (item_id) REFERENCES Items(item_id), FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id));
INSERT INTO Items VALUES (1,'Laptop','Electronics',999.99),(2,'Desk Chair','Furniture',199.99),(3,'Printer','Office',299.99);
INSERT INTO Warehouses VALUES (1,'Main Warehouse','New York'),(2,'West Warehouse','Los Angeles'),(3,'South Warehouse','Houston');
INSERT INTO StockMovements VALUES (1,1,1,'2023-01-15',50,'Inbound'),(2,2,2,'2023-01-16',100,'Inbound'),(3,3,3,'2023-01-17',30,'Inbound');
CREATE INDEX idx_item_name ON Items(item_name); CREATE INDEX idx_warehouse_id ON StockMovements(warehouse_id); CREATE INDEX idx_movement_date ON StockMovements(movement_date);
CREATE VIEW vw_inventory_status AS SELECT m.movement_id, i.item_name, w.warehouse_name, m.movement_date, m.quantity, m.movement_type FROM StockMovements m JOIN Items i ON m.item_id = i.item_id JOIN Warehouses w ON m.warehouse_id = w.warehouse_id;

-- 10. ONLINE FORUM OR BLOG PLATFORM
CREATE DATABASE IF NOT EXISTS Forum; USE Forum;
CREATE TABLE Users (user_id INT PRIMARY KEY, username VARCHAR(50), join_date DATE, post_count INT);
CREATE TABLE Posts (post_id INT PRIMARY KEY, user_id INT, post_title VARCHAR(200), post_content TEXT, post_date DATETIME, FOREIGN KEY (user_id) REFERENCES Users(user_id));
CREATE TABLE Comments (comment_id INT PRIMARY KEY, post_id INT, user_id INT, comment_text TEXT, comment_date DATETIME, FOREIGN KEY (post_id) REFERENCES Posts(post_id), FOREIGN KEY (user_id) REFERENCES Users(user_id));
INSERT INTO Users VALUES (1,'alice','2022-01-15',10),(2,'bob','2022-03-22',5),(3,'charlie','2022-05-10',8);
INSERT INTO Posts VALUES (1,1,'First Post','Welcome to the forum!',NOW()),(2,2,'Question','How to use SQL?',NOW()),(3,3,'Tutorial','Basic SQL commands',NOW());
INSERT INTO Comments VALUES (1,1,2,'Great post!',NOW()),(2,2,3,'Check the documentation',NOW()),(3,3,1,'Very helpful',NOW());
CREATE INDEX idx_username ON Users(username); CREATE INDEX idx_post_date ON Posts(post_date); CREATE INDEX idx_comment_date ON Comments(comment_date);
CREATE VIEW vw_post_comments AS SELECT p.post_id, p.post_title, u.username, p.post_date, c.comment_text, c.comment_date FROM Posts p JOIN Users u ON p.user_id = u.user_id JOIN Comments c ON p.post_id = c.post_id;

-- 11. ORDER FULFILLMENT SYSTEM
CREATE DATABASE IF NOT EXISTS OrderSystem; USE OrderSystem;
CREATE TABLE Customers (customer_id INT PRIMARY KEY, customer_name VARCHAR(100), email VARCHAR(100));
CREATE TABLE Orders (order_id INT PRIMARY KEY, customer_id INT, order_date DATE, status VARCHAR(20), FOREIGN KEY (customer_id) REFERENCES Customers(customer_id));
CREATE TABLE OrderItems (order_item_id INT PRIMARY KEY, order_id INT, product_name VARCHAR(100), quantity INT, price DECIMAL(10,2), FOREIGN KEY (order_id) REFERENCES Orders(order_id));
INSERT INTO Customers VALUES (1,'Alice','alice@example.com'),(2,'Bob','bob@example.com'),(3,'Charlie','charlie@example.com');
INSERT INTO Orders VALUES (1,1,'2023-01-15','Shipped'),(2,2,'2023-01-16','Processing'),(3,3,'2023-01-17','Delivered');
INSERT INTO OrderItems VALUES (1,1,'Laptop',1,999.99),(2,2,'Phone',2,699.99),(3,3,'Tablet',1,399.99);
CREATE INDEX idx_customer_name ON Customers(customer_name); CREATE INDEX idx_order_date ON Orders(order_date); CREATE INDEX idx_order_status ON Orders(status);
CREATE VIEW vw_order_details AS SELECT o.order_id, c.customer_name, o.order_date, o.status, oi.product_name, oi.quantity, oi.price FROM Orders o JOIN Customers c ON o.customer_id = c.customer_id JOIN OrderItems oi ON o.order_id = oi.order_id;

-- 12. GYM MEMBERSHIP AND ATTENDANCE TRACKER
CREATE DATABASE IF NOT EXISTS Gym; USE Gym;
CREATE TABLE Members (member_id INT PRIMARY KEY, member_name VARCHAR(100), join_date DATE, membership_type VARCHAR(50));
CREATE TABLE Trainers (trainer_id INT PRIMARY KEY, trainer_name VARCHAR(100), specialization VARCHAR(100));
CREATE TABLE CheckIns (checkin_id INT PRIMARY KEY, member_id INT, trainer_id INT, checkin_date DATETIME, duration_minutes INT, FOREIGN KEY (member_id) REFERENCES Members(member_id), FOREIGN KEY (trainer_id) REFERENCES Trainers(trainer_id));
INSERT INTO Members VALUES (1,'Alice','2023-01-15','Premium'),(2,'Bob','2023-02-20','Standard'),(3,'Charlie','2023-03-10','Premium');
INSERT INTO Trainers VALUES (101,'John','Weight Training'),(102,'Sarah','Yoga'),(103,'Mike','Cardio');
INSERT INTO CheckIns VALUES (1,1,101,NOW(),60),(2,2,102,NOW(),45),(3,3,103,NOW(),30);
CREATE INDEX idx_member_name ON Members(member_name); CREATE INDEX idx_checkin_date ON CheckIns(checkin_date); CREATE INDEX idx_trainer_id ON CheckIns(trainer_id);
CREATE VIEW vw_member_checkins AS SELECT c.checkin_id, m.member_name, t.trainer_name, c.checkin_date, c.duration_minutes FROM CheckIns c JOIN Members m ON c.member_id = m.member_id JOIN Trainers t ON c.trainer_id = t.trainer_id;

-- 13. RESTAURANT ORDER & KITCHEN MONITOR
CREATE DATABASE IF NOT EXISTS Restaurant; USE Restaurant;
CREATE TABLE Tables (table_id INT PRIMARY KEY, table_name VARCHAR(20), capacity INT);
CREATE TABLE MenuItems (item_id INT PRIMARY KEY, item_name VARCHAR(100), category VARCHAR(50), price DECIMAL(10,2));
CREATE TABLE Orders (order_id INT PRIMARY KEY, table_id INT, order_time DATETIME, status VARCHAR(20), FOREIGN KEY (table_id) REFERENCES Tables(table_id));
CREATE TABLE OrderItems (order_item_id INT PRIMARY KEY, order_id INT, item_id INT, quantity INT, special_requests TEXT, FOREIGN KEY (order_id) REFERENCES Orders(order_id), FOREIGN KEY (item_id) REFERENCES MenuItems(item_id));
INSERT INTO Tables VALUES (1,'Table 1',4),(2,'Table 2',6),(3,'Table 3',2);
INSERT INTO MenuItems VALUES (1,'Burger','Main',12.99),(2,'Salad','Starter',8.99),(3,'Pizza','Main',14.99);
INSERT INTO Orders VALUES (1,1,NOW(),'Preparing'),(2,2,NOW(),'Ready'),(3,3,NOW(),'Served');
INSERT INTO OrderItems VALUES (1,1,1,1,'No onions'),(2,2,2,2,'Dressing on side'),(3,3,3,1,'Extra cheese');
CREATE INDEX idx_table_id ON Orders(table_id); CREATE INDEX idx_order_status ON Orders(status); CREATE INDEX idx_item_name ON MenuItems(item_name);
CREATE VIEW vw_kitchen_orders AS SELECT o.order_id, t.table_name, mi.item_name, oi.quantity, oi.special_requests, o.status FROM Orders o JOIN Tables t ON o.table_id = t.table_id JOIN OrderItems oi ON o.order_id = oi.order_id JOIN MenuItems mi ON oi.item_id = mi.item_id;

-- 14. VEHICLE SERVICE BOOKING SYSTEM
CREATE DATABASE IF NOT EXISTS AutoService; USE AutoService;
CREATE TABLE Customers (customer_id INT PRIMARY KEY, customer_name VARCHAR(100), phone VARCHAR(20));
CREATE TABLE Vehicles (vehicle_id INT PRIMARY KEY, customer_id INT, make VARCHAR(50), model VARCHAR(50), year INT, FOREIGN KEY (customer_id) REFERENCES Customers(customer_id));
CREATE TABLE Services (service_id INT PRIMARY KEY, vehicle_id INT, service_date DATE, service_type VARCHAR(100), cost DECIMAL(10,2), FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id));
INSERT INTO Customers VALUES (1,'Alice','555-0101'),(2,'Bob','555-0102'),(3,'Charlie','555-0103');
INSERT INTO Vehicles VALUES (1,1,'Toyota','Camry',2018),(2,2,'Honda','Accord',2020),(3,3,'Ford','F-150',2019);
INSERT INTO Services VALUES (1,1,'2023-01-15','Oil Change',49.99),(2,2,'2023-01-16','Tire Rotation',29.99),(3,3,'2023-01-17','Brake Service',199.99);
CREATE INDEX idx_customer_name ON Customers(customer_name); CREATE INDEX idx_service_date ON Services(service_date); CREATE INDEX idx_vehicle_make ON Vehicles(make);
CREATE VIEW vw_service_history AS SELECT s.service_id, c.customer_name, v.make, v.model, s.service_date, s.service_type, s.cost FROM Services s JOIN Vehicles v ON s.vehicle_id = v.vehicle_id JOIN Customers c ON v.customer_id = c.customer_id;

-- 15. ONLINE MOVIE TICKET BOOKING
CREATE DATABASE IF NOT EXISTS Cinema; USE Cinema;
CREATE TABLE Movies (movie_id INT PRIMARY KEY, title VARCHAR(100), genre VARCHAR(50), duration_minutes INT);
CREATE TABLE Shows (show_id INT PRIMARY KEY, movie_id INT, show_time DATETIME, hall_id INT, available_seats INT, FOREIGN KEY (movie_id) REFERENCES Movies(movie_id));
CREATE TABLE Bookings (booking_id INT PRIMARY KEY, show_id INT, user_id INT, booking_date DATETIME, seats_booked INT, FOREIGN KEY (show_id) REFERENCES Shows(show_id));
INSERT INTO Movies VALUES (1,'The Avengers','Action',143),(2,'Inception','Sci-Fi',148),(3,'Titanic','Drama',195);
INSERT INTO Shows VALUES (1,1,NOW(),1,50),(2,2,NOW(),2,75),(3,3,NOW(),3,60);
INSERT INTO Bookings VALUES (1,1,101,NOW(),2),(2,2,102,NOW(),3),(3,3,103,NOW(),1);
CREATE INDEX idx_movie_title ON Movies(title); CREATE INDEX idx_show_time ON Shows(show_time); CREATE INDEX idx_booking_date ON Bookings(booking_date);
CREATE VIEW vw_show_bookings AS SELECT b.booking_id, m.title, s.show_time, s.hall_id, b.seats_booked FROM Bookings b JOIN Shows s ON b.show_id = s.show_id JOIN Movies m ON s.movie_id = m.movie_id;

-- 16. FREELANCER PAYMENT AND PROJECT PORTAL
CREATE DATABASE IF NOT EXISTS Freelance; USE Freelance;
CREATE TABLE Freelancers (freelancer_id INT PRIMARY KEY, freelancer_name VARCHAR(100), skills VARCHAR(200));
CREATE TABLE Clients (client_id INT PRIMARY KEY, client_name VARCHAR(100), industry VARCHAR(100));
CREATE TABLE Projects (project_id INT PRIMARY KEY, freelancer_id INT, client_id INT, project_name VARCHAR(100), start_date DATE, end_date DATE, budget DECIMAL(15,2), FOREIGN KEY (freelancer_id) REFERENCES Freelancers(freelancer_id), FOREIGN KEY (client_id) REFERENCES Clients(client_id));
CREATE TABLE Invoices (invoice_id INT PRIMARY KEY, project_id INT, invoice_date DATE, amount DECIMAL(15,2), status VARCHAR(20), FOREIGN KEY (project_id) REFERENCES Projects(project_id));
INSERT INTO Freelancers VALUES (1,'Alice','Web Development'),(2,'Bob','Graphic Design'),(3,'Charlie','Content Writing');
INSERT INTO Clients VALUES (1,'Acme Corp','Retail'),(2,'Globex','Technology'),(3,'Soylent','Food');
INSERT INTO Projects VALUES (1,1,1,'Website Redesign','2023-01-15','2023-03-15',5000.00),(2,2,2,'Logo Design','2023-02-01','2023-02-15',1000.00),(3,3,3,'Blog Content','2023-01-20','2023-04-20',3000.00);
INSERT INTO Invoices VALUES (1,1,'2023-03-01',2500.00,'Paid'),(2,2,'2023-02-10',1000.00,'Paid'),(3,3,'2023-02-15',1500.00,'Pending');
CREATE INDEX idx_freelancer_name ON Freelancers(freelancer_name); CREATE INDEX idx_project_name ON Projects(project_name); CREATE INDEX idx_invoice_status ON Invoices(status);
CREATE VIEW vw_project_invoices AS SELECT i.invoice_id, f.freelancer_name, c.client_name, p.project_name, i.invoice_date, i.amount, i.status FROM Invoices i JOIN Projects p ON i.project_id = p.project_id JOIN Freelancers f ON p.freelancer_id = f.freelancer_id JOIN Clients c ON p.client_id = c.client_id;

-- 17. ONLINE EXAM MANAGEMENT SYSTEM
CREATE DATABASE IF NOT EXISTS ExamSystem; USE ExamSystem;
CREATE TABLE Students (student_id INT PRIMARY KEY, student_name VARCHAR(100), class VARCHAR(50));
CREATE TABLE Exams (exam_id INT PRIMARY KEY, exam_name VARCHAR(100), exam_date DATE, total_marks INT);
CREATE TABLE Scores (score_id INT PRIMARY KEY, student_id INT, exam_id INT, score INT, grade CHAR(2), FOREIGN KEY (student_id) REFERENCES Students(student_id), FOREIGN KEY (exam_id) REFERENCES Exams(exam_id));
INSERT INTO Students VALUES (1,'Alice','Class A'),(2,'Bob','Class B'),(3,'Charlie','Class A');
INSERT INTO Exams VALUES (1,'Midterm','2023-03-15',100),(2,'Final','2023-06-20',100),(3,'Quiz 1','2023-02-10',50);
INSERT INTO Scores VALUES (1,1,1,85,'B'),(2,2,2,92,'A'),(3,3,3,45,'C');
CREATE INDEX idx_student_name ON Students(student_name); CREATE INDEX idx_exam_date ON Exams(exam_date); CREATE INDEX idx_score ON Scores(score);
CREATE VIEW vw_exam_results AS SELECT s.score_id, st.student_name, e.exam_name, e.exam_date, s.score, s.grade FROM Scores s JOIN Students st ON s.student_id = st.student_id JOIN Exams e ON s.exam_id = e.exam_id;

-- 18. REAL ESTATE LISTING PLATFORM
CREATE DATABASE IF NOT EXISTS RealEstate; USE RealEstate;
CREATE TABLE Properties (property_id INT PRIMARY KEY, address VARCHAR(200), city VARCHAR(100), state VARCHAR(50), zip_code VARCHAR(20), price DECIMAL(15,2), bedrooms INT, bathrooms INT, square_feet INT);
CREATE TABLE Agents (agent_id INT PRIMARY KEY, agent_name VARCHAR(100), phone VARCHAR(20), email VARCHAR(100));
CREATE TABLE Listings (listing_id INT PRIMARY KEY, property_id INT, agent_id INT, list_date DATE, status VARCHAR(20), FOREIGN KEY (property_id) REFERENCES Properties(property_id), FOREIGN KEY (agent_id) REFERENCES Agents(agent_id));
INSERT INTO Properties VALUES (1,'123 Main St','Anytown','CA','12345',500000.00,3,2,1500),(2,'456 Oak Ave','Somewhere','NY','54321',750000.00,4,3,2200),(3,'789 Pine Rd','Nowhere','TX','67890',350000.00,2,1,1200);
INSERT INTO Agents VALUES (1,'John Smith','555-0101','john@agency.com'),(2,'Sarah Johnson','555-0102','sarah@agency.com'),(3,'Mike Brown','555-0103','mike@agency.com');
INSERT INTO Listings VALUES (1,1,1,'2023-01-15','Active'),(2,2,2,'2023-02-01','Pending'),(3,3,3,'2023-01-20','Sold');
CREATE INDEX idx_property_price ON Properties(price); CREATE INDEX idx_property_bedrooms ON Properties(bedrooms); CREATE INDEX idx_listing_status ON Listings(status);
CREATE VIEW vw_property_listings AS SELECT l.listing_id, p.address, p.city, p.price, p.bedrooms, p.bathrooms, a.agent_name, l.list_date, l.status FROM Listings l JOIN Properties p ON l.property_id = p.property_id JOIN Agents a ON l.agent_id = a.agent_id;

-- 19. INSURANCE POLICY MANAGEMENT SYSTEM
CREATE DATABASE IF NOT EXISTS Insurance; USE Insurance;
CREATE TABLE Clients (client_id INT PRIMARY KEY, client_name VARCHAR(100), dob DATE, phone VARCHAR(20));
CREATE TABLE Policies (policy_id INT PRIMARY KEY, client_id INT, policy_type VARCHAR(50), start_date DATE, end_date DATE, premium DECIMAL(10,2), FOREIGN KEY (client_id) REFERENCES Clients(client_id));
CREATE TABLE Claims (claim_id INT PRIMARY KEY, policy_id INT, claim_date DATE, amount DECIMAL(15,2), status VARCHAR(20), FOREIGN KEY (policy_id) REFERENCES Policies(policy_id));
INSERT INTO Clients VALUES (1,'Alice','1980-05-15','555-0101'),(2,'Bob','1975-08-22','555-0102'),(3,'Charlie','1990-03-10','555-0103');
INSERT INTO Policies VALUES (1,1,'Auto','2023-01-01','2024-01-01',1200.00),(2,2,'Home','2023-02-01','2024-02-01',2500.00),(3,3,'Life','2023-03-01','2033-03-01',500.00);
INSERT INTO Claims VALUES (1,1,'2023-05-15',5000.00,'Approved'),(2,2,'2023-06-01',15000.00,'Pending'),(3,3,'2023-04-10',100000.00,'Denied');
CREATE INDEX idx_client_name ON Clients(client_name); CREATE INDEX idx_policy_type ON Policies(policy_type); CREATE INDEX idx_claim_status ON Claims(status);
CREATE VIEW vw_policy_claims AS SELECT c.claim_id, cl.client_name, p.policy_type, c.claim_date, c.amount, c.status FROM Claims c JOIN Policies p ON c.policy_id = p.policy_id JOIN Clients cl ON p.client_id = cl.client_id;

-- 20. NGO DONATION AND CAMPAIGN TRACKER
CREATE DATABASE IF NOT EXISTS NGO; USE NGO;
CREATE TABLE Donors (donor_id INT PRIMARY KEY, donor_name VARCHAR(100), email VARCHAR(100), phone VARCHAR(20));
CREATE TABLE Campaigns (campaign_id INT PRIMARY KEY, campaign_name VARCHAR(100), start_date DATE, end_date DATE, target_amount DECIMAL(15,2));
CREATE TABLE Donations (donation_id INT PRIMARY KEY, donor_id INT, campaign_id INT, donation_date DATE, amount DECIMAL(15,2), payment_method VARCHAR(50), FOREIGN KEY (donor_id) REFERENCES Donors(donor_id), FOREIGN KEY (campaign_id) REFERENCES Campaigns(campaign_id));
INSERT INTO Donors VALUES (1,'Alice','alice@example.com','555-0101'),(2,'Bob','bob@example.com','555-0102'),(3,'Charlie','charlie@example.com','555-0103');
INSERT INTO Campaigns VALUES (1,'Education Fund','2023-01-01','2023-06-30',50000.00),(2,'Food Drive','2023-03-01','2023-05-31',25000.00),(3,'Medical Aid','2023-02-01','2023-12-31',100000.00);
INSERT INTO Donations VALUES (1,1,1,'2023-02-15',1000.00,'Credit Card'),(2,2,2,'2023-04-01',500.00,'PayPal'),(3,3,3,'2023-03-10',2500.00,'Bank Transfer');
CREATE INDEX idx_donor_name ON Donors(donor_name); CREATE INDEX idx_campaign_name ON Campaigns(campaign_name); CREATE INDEX idx_donation_date ON Donations(donation_date);
CREATE VIEW vw_campaign_donations AS SELECT d.donation_id, dr.donor_name, c.campaign_name, d.donation_date, d.amount, d.payment_method FROM Donations d JOIN Donors dr ON d.donor_id = dr.donor_id JOIN Campaigns c ON d.campaign_id = c.campaign_id;