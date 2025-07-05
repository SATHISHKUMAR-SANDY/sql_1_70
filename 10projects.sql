/**************************************/
/* PROJECT 1: Employee Management System */
/**************************************/

CREATE DATABASE EmployeeManagementSystem;
USE EmployeeManagementSystem;

-- Create tables with constraints
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL UNIQUE,
    Location VARCHAR(100),
    Budget DECIMAL(15, 2) CHECK (Budget >= 0)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20),
    HireDate DATE NOT NULL,
    JobTitle VARCHAR(100),
    Salary DECIMAL(10, 2) CHECK (Salary >= 0),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Insert sample data
INSERT INTO Departments VALUES 
(1, 'Human Resources', 'Floor 1', 500000),
(2, 'Information Technology', 'Floor 2', 750000),
(3, 'Finance', 'Floor 3', 600000),
(4, 'Marketing', 'Floor 4', 450000);

INSERT INTO Employees VALUES
(101, 'John', 'Doe', 'john.doe@company.com', '555-0101', '2020-01-15', 'HR Manager', 75000, 1),
(102, 'Jane', 'Smith', 'jane.smith@company.com', '555-0102', '2019-05-22', 'IT Director', 95000, 2),
(103, 'Robert', 'Johnson', 'robert.j@company.com', '555-0103', '2021-03-10', 'Financial Analyst', 65000, 3),
(104, 'Emily', 'Williams', 'emily.w@company.com', '555-0104', '2022-07-05', 'Marketing Specialist', 55000, 4),
(105, 'Michael', 'Brown', 'michael.b@company.com', '555-0105', '2020-11-18', 'Senior Developer', 80000, 2);

-- Update department and salary
UPDATE Employees
SET DepartmentID = 2, Salary = 85000
WHERE EmployeeID = 105;

-- Delete an employee
DELETE FROM Employees WHERE EmployeeID = 104;

-- Employee-department join
SELECT e.EmployeeID, e.FirstName, e.LastName, d.DepartmentName, e.Salary
FROM Employees e JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- Department-wise average salary
SELECT d.DepartmentName, AVG(e.Salary) AS AvgSalary
FROM Departments d JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName;

-- Salary update transaction
BEGIN TRANSACTION;
SAVEPOINT BeforeSalaryUpdate;

UPDATE Employees
SET Salary = Salary * 1.10
WHERE DepartmentID = 2;

-- Check if budget allows
DECLARE @ITSalaryTotal DECIMAL(15,2);
SELECT @ITSalaryTotal = SUM(Salary) FROM Employees WHERE DepartmentID = 2;

DECLARE @ITBudget DECIMAL(15,2);
SELECT @ITBudget = Budget FROM Departments WHERE DepartmentID = 2;

IF @ITSalaryTotal > @ITBudget
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Salary increase exceeds department budget';
END
ELSE
BEGIN
    COMMIT TRANSACTION;
    PRINT 'Salary updates committed successfully';
END

/**************************************/
/* PROJECT 2: Student Course Registration */
/**************************************/

CREATE DATABASE StudentCourseSystem;
USE StudentCourseSystem;

-- Create tables
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    EnrollmentDate DATE DEFAULT GETDATE()
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    CreditHours INT CHECK (CreditHours > 0),
    Department VARCHAR(50)
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE DEFAULT GETDATE(),
    Grade CHAR(2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    UNIQUE (StudentID, CourseID)
);

-- Insert data
INSERT INTO Students VALUES
(1001, 'Alice', 'Johnson', 'alice.j@university.edu', '2023-09-01'),
(1002, 'Bob', 'Smith', 'bob.s@university.edu', '2023-09-01'),
(1003, 'Carol', 'Williams', 'carol.w@university.edu', '2023-09-01');

INSERT INTO Courses VALUES
(101, 'Introduction to Computer Science', 3, 'CS'),
(102, 'Calculus I', 4, 'Math'),
(103, 'English Composition', 3, 'English');

INSERT INTO Enrollments VALUES
(1, 1001, 101, '2023-09-05', NULL),
(2, 1001, 102, '2023-09-05', NULL),
(3, 1002, 101, '2023-09-06', NULL),
(4, 1003, 103, '2023-09-06', NULL);

-- Student-course mapping
SELECT s.StudentID, s.FirstName, s.LastName, c.CourseName, e.EnrollmentDate
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID;

-- Filtering examples
-- Students with last name starting with 'J'
SELECT * FROM Students WHERE LastName LIKE 'J%';

-- Courses with 3-4 credit hours
SELECT * FROM Courses WHERE CreditHours BETWEEN 3 AND 4;

-- Count enrollments per course
SELECT c.CourseName, COUNT(e.EnrollmentID) AS EnrollmentCount
FROM Courses c LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseName;

-- Enrollment transaction
BEGIN TRANSACTION;
INSERT INTO Enrollments VALUES (5, 1002, 103, GETDATE(), NULL);

-- Check if student is already enrolled
IF EXISTS (SELECT 1 FROM Enrollments WHERE StudentID = 1002 AND CourseID = 103)
BEGIN
    ROLLBACK;
    PRINT 'Enrollment failed - student already enrolled';
END
ELSE
BEGIN
    COMMIT;
    PRINT 'Enrollment successful';
END

/**************************************/
/* PROJECT 3: Online Shopping Platform */
/**************************************/

CREATE DATABASE OnlineShopping;
USE OnlineShopping;

-- Create tables
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    JoinDate DATE DEFAULT GETDATE()
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) CHECK (Price >= 0),
    StockQuantity INT CHECK (StockQuantity >= 0),
    Category VARCHAR(50)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME DEFAULT GETDATE(),
    Status VARCHAR(20) DEFAULT 'Processing',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Insert data
INSERT INTO Customers VALUES
(1, 'David', 'Wilson', 'david.w@email.com', '2023-01-15'),
(2, 'Sarah', 'Miller', 'sarah.m@email.com', '2023-02-20');

INSERT INTO Products VALUES
(101, 'Wireless Headphones', 99.99, 50, 'Electronics'),
(102, 'Coffee Maker', 49.99, 30, 'Home'),
(103, 'Running Shoes', 79.99, 100, 'Sports');

INSERT INTO Orders VALUES
(1001, 1, '2023-10-01', 'Shipped'),
(1002, 2, '2023-10-02', 'Processing');

INSERT INTO OrderItems VALUES
(1, 1001, 101, 1, 99.99),
(2, 1001, 103, 2, 79.99),
(3, 1002, 102, 1, 49.99);

-- Customer order details
SELECT c.CustomerID, c.FirstName, c.LastName, o.OrderID, o.OrderDate, o.Status,
       p.ProductName, oi.Quantity, oi.UnitPrice
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Products p ON oi.ProductID = p.ProductID;

-- Order totals
SELECT o.OrderID, SUM(oi.Quantity * oi.UnitPrice) AS TotalAmount
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
GROUP BY o.OrderID;

-- Filter products
-- Products between $50-$100
SELECT * FROM Products WHERE Price BETWEEN 50 AND 100;

-- Available products (stock > 0)
SELECT * FROM Products WHERE StockQuantity > 0;

-- FULL OUTER JOIN example (showing all orders with or without items)
SELECT o.OrderID, o.OrderDate, oi.ProductID, oi.Quantity
FROM Orders o
LEFT JOIN OrderItems oi ON o.OrderID = oi.OrderID
UNION
SELECT o.OrderID, o.OrderDate, oi.ProductID, oi.Quantity
FROM OrderItems oi
RIGHT JOIN Orders o ON oi.OrderID = o.OrderID
WHERE o.OrderID IS NULL;

-- Top selling products (subquery)
SELECT p.ProductID, p.ProductName, SUM(oi.Quantity) AS TotalSold
FROM Products p
JOIN OrderItems oi ON p.ProductID = oi.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalSold DESC;

/**************************************/
/* PROJECT 4: Library Management System */
/**************************************/

CREATE DATABASE LibraryManagement;
USE LibraryManagement;

-- Create tables
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(200) NOT NULL,
    Author VARCHAR(100),
    ISBN VARCHAR(20) UNIQUE,
    PublicationYear INT,
    Status VARCHAR(20) DEFAULT 'Available'
);

CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    MembershipDate DATE DEFAULT GETDATE()
);

CREATE TABLE BorrowRecords (
    BorrowID INT PRIMARY KEY,
    BookID INT,
    MemberID INT,
    BorrowDate DATE DEFAULT GETDATE(),
    DueDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    CHECK (DueDate > BorrowDate)
);

-- Insert data
INSERT INTO Books VALUES
(1, 'The Great Gatsby', 'F. Scott Fitzgerald', '9780743273565', 1925, 'Available'),
(2, 'To Kill a Mockingbird', 'Harper Lee', '9780061120084', 1960, 'Available'),
(3, '1984', 'George Orwell', '9780451524935', 1949, 'Available');

INSERT INTO Members VALUES
(101, 'Emma', 'Thompson', 'emma.t@email.com', '2023-01-10'),
(102, 'James', 'Wilson', 'james.w@email.com', '2023-02-15');

-- Borrow a book
INSERT INTO BorrowRecords VALUES
(1, 1, 101, '2023-10-01', '2023-10-15', NULL);

UPDATE Books SET Status = 'Borrowed' WHERE BookID = 1;

-- Return a book
UPDATE BorrowRecords SET ReturnDate = GETDATE() WHERE BorrowID = 1;
UPDATE Books SET Status = 'Available' WHERE BookID = 1;

-- Current borrowings
SELECT b.Title, b.Author, m.FirstName, m.LastName, br.BorrowDate, br.DueDate
FROM BorrowRecords br
JOIN Books b ON br.BookID = b.BookID
JOIN Members m ON br.MemberID = m.MemberID
WHERE br.ReturnDate IS NULL;

-- Book status with CASE
SELECT BookID, Title, 
       CASE 
           WHEN Status = 'Available' THEN 'Ready to borrow'
           WHEN Status = 'Borrowed' THEN 'Currently checked out'
           ELSE Status
       END AS AvailabilityStatus
FROM Books;

-- Most borrowed books
SELECT b.BookID, b.Title, COUNT(br.BorrowID) AS TimesBorrowed
FROM Books b
LEFT JOIN BorrowRecords br ON b.BookID = br.BookID
GROUP BY b.BookID, b.Title
ORDER BY TimesBorrowed DESC;

/**************************************/
/* PROJECT 5: Sales and Inventory System */
/**************************************/

CREATE DATABASE SalesInventory;
USE SalesInventory;

-- Create tables
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    UnitPrice DECIMAL(10,2) CHECK (UnitPrice >= 0),
    StockQuantity INT CHECK (StockQuantity >= 0)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    SaleDate DATETIME DEFAULT GETDATE(),
    CustomerName VARCHAR(100),
    TotalAmount DECIMAL(12,2)
);

CREATE TABLE SalesItems (
    SaleItemID INT PRIMARY KEY,
    SaleID INT,
    ProductID INT,
    Quantity INT CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2),
    FOREIGN KEY (SaleID) REFERENCES Sales(SaleID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Insert data
INSERT INTO Products VALUES
(1, 'Laptop', 'Electronics', 999.99, 50),
(2, 'Desk Chair', 'Furniture', 149.99, 30),
(3, 'Notebook', 'Office Supplies', 4.99, 200);

INSERT INTO Sales VALUES
(101, '2023-10-01', 'John Smith', 1149.98),
(102, '2023-10-02', 'Alice Johnson', 154.98);

INSERT INTO SalesItems VALUES
(1, 101, 1, 1, 999.99),
(2, 101, 2, 1, 149.99),
(3, 102, 2, 1, 149.99),
(4, 102, 3, 1, 4.99);

-- Update stock after sale
UPDATE Products
SET StockQuantity = StockQuantity - (
    SELECT SUM(Quantity) 
    FROM SalesItems 
    WHERE ProductID = Products.ProductID
);

-- Sales by product category
SELECT p.Category, SUM(si.Quantity * si.UnitPrice) AS TotalSales
FROM Products p
JOIN SalesItems si ON p.ProductID = si.ProductID
GROUP BY p.Category
HAVING SUM(si.Quantity * si.UnitPrice) > 1000  -- Filter categories with sales > $1000
ORDER BY TotalSales DESC;

-- Multi-column ordering
SELECT * FROM Products
ORDER BY Category, UnitPrice DESC;

-- Invoice generation transaction
BEGIN TRANSACTION;
DECLARE @NewSaleID INT = 103;

INSERT INTO Sales (SaleID, SaleDate, CustomerName, TotalAmount)
VALUES (@NewSaleID, GETDATE(), 'Robert Brown', 0);

INSERT INTO SalesItems (SaleItemID, SaleID, ProductID, Quantity, UnitPrice)
VALUES 
(5, @NewSaleID, 1, 1, (SELECT UnitPrice FROM Products WHERE ProductID = 1)),
(6, @NewSaleID, 3, 5, (SELECT UnitPrice FROM Products WHERE ProductID = 3));

-- Calculate total
UPDATE Sales
SET TotalAmount = (
    SELECT SUM(Quantity * UnitPrice) 
    FROM SalesItems 
    WHERE SaleID = @NewSaleID
)
WHERE SaleID = @NewSaleID;

-- Update inventory
UPDATE Products
SET StockQuantity = StockQuantity - (
    SELECT Quantity 
    FROM SalesItems 
    WHERE ProductID = Products.ProductID AND SaleID = @NewSaleID
)
WHERE ProductID IN (
    SELECT ProductID 
    FROM SalesItems 
    WHERE SaleID = @NewSaleID
);

COMMIT TRANSACTION;

/**************************************/
/* PROJECT 6: Banking System */
/**************************************/

CREATE DATABASE BankingSystem;
USE BankingSystem;

-- Create tables
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    SSN VARCHAR(11) UNIQUE,
    JoinDate DATE DEFAULT GETDATE()
);

CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,
    CustomerID INT,
    AccountType VARCHAR(20),
    Balance DECIMAL(15,2) DEFAULT 0 CHECK (Balance >= 0),
    OpenDate DATE DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    AccountID INT,
    TransactionDate DATETIME DEFAULT GETDATE(),
    Amount DECIMAL(12,2),
    TransactionType VARCHAR(20),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

-- Insert data
INSERT INTO Customers VALUES
(1, 'Michael', 'Davis', '123-45-6789', '2020-05-15'),
(2, 'Jennifer', 'Lee', '987-65-4321', '2021-02-20');

INSERT INTO Accounts VALUES
(1001, 1, 'Checking', 2500.00, '2020-05-15'),
(1002, 1, 'Savings', 10000.00, '2020-05-15'),
(1003, 2, 'Checking', 5000.00, '2021-02-20');

-- Deposit transaction
BEGIN TRANSACTION;
INSERT INTO Transactions VALUES (1, 1001, GETDATE(), 500.00, 'Deposit');
UPDATE Accounts SET Balance = Balance + 500.00 WHERE AccountID = 1001;
COMMIT TRANSACTION;

-- Withdrawal transaction
BEGIN TRANSACTION;
DECLARE @WithdrawAmount DECIMAL(12,2) = 200.00;
DECLARE @CurrentBalance DECIMAL(15,2);

SELECT @CurrentBalance = Balance FROM Accounts WHERE AccountID = 1001;

IF @CurrentBalance >= @WithdrawAmount
BEGIN
    INSERT INTO Transactions VALUES (2, 1001, GETDATE(), @WithdrawAmount, 'Withdrawal');
    UPDATE Accounts SET Balance = Balance - @WithdrawAmount WHERE AccountID = 1001;
    COMMIT TRANSACTION;
    PRINT 'Withdrawal successful';
END
ELSE
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Insufficient funds';
END

-- Fund transfer transaction
BEGIN TRANSACTION;
DECLARE @TransferAmount DECIMAL(12,2) = 1000.00;
DECLARE @SourceBalance DECIMAL(15,2);

SELECT @SourceBalance = Balance FROM Accounts WHERE AccountID = 1002;

IF @SourceBalance >= @TransferAmount
BEGIN
    -- Withdraw from source
    INSERT INTO Transactions VALUES (3, 1002, GETDATE(), @TransferAmount, 'Transfer Out');
    UPDATE Accounts SET Balance = Balance - @TransferAmount WHERE AccountID = 1002;
    
    -- Deposit to target
    INSERT INTO Transactions VALUES (4, 1003, GETDATE(), @TransferAmount, 'Transfer In');
    UPDATE Accounts SET Balance = Balance + @TransferAmount WHERE AccountID = 1003;
    
    COMMIT TRANSACTION;
    PRINT 'Transfer completed successfully';
END
ELSE
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Transfer failed - insufficient funds';
END

-- Customer account summary
SELECT c.CustomerID, c.FirstName, c.LastName, 
       a.AccountID, a.AccountType, a.Balance
FROM Customers c
JOIN Accounts a ON c.CustomerID = a.CustomerID;

-- Highest balance customers (subquery)
SELECT c.CustomerID, c.FirstName, c.LastName, 
       (SELECT SUM(Balance) FROM Accounts WHERE CustomerID = c.CustomerID) AS TotalBalance
FROM Customers c
ORDER BY TotalBalance DESC;

/**************************************/
/* PROJECT 7: Hospital Patient System */
/**************************************/

CREATE DATABASE HospitalSystem;
USE HospitalSystem;

-- Create tables
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DOB DATE,
    InsuranceProvider VARCHAR(50)
);

CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Specialty VARCHAR(50),
    LicenseNumber VARCHAR(20) UNIQUE
);

CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATETIME,
    Status VARCHAR(20) DEFAULT 'Scheduled',
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Insert data
INSERT INTO Patients VALUES
(1, 'David', 'Brown', '1985-07-15', 'Blue Cross'),
(2, 'Sarah', 'Wilson', '1990-11-22', 'Aetna'),
(3, 'Robert', 'Johnson', '1978-03-10', 'Medicare');

INSERT INTO Doctors VALUES
(101, 'James', 'Smith', 'Cardiology', 'MD123456'),
(102, 'Emily', 'Davis', 'Pediatrics', 'MD654321'),
(103, 'Michael', 'Taylor', 'Orthopedics', 'MD789012');

INSERT INTO Appointments VALUES
(1, 1, 101, '2023-10-05 09:00:00', 'Completed'),
(2, 2, 102, '2023-10-06 10:30:00', 'Scheduled'),
(3, 3, 101, '2023-10-07 14:00:00', 'Scheduled'),
(4, 1, 103, '2023-10-10 11:00:00', 'Cancelled');

-- Patient-doctor appointments
SELECT p.PatientID, p.FirstName + ' ' + p.LastName AS PatientName,
       d.DoctorID, d.FirstName + ' ' + d.LastName AS DoctorName,
       a.AppointmentDate, a.Status
FROM Appointments a
JOIN Patients p ON a.PatientID = p.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID;

-- Filter appointments
-- Upcoming appointments
SELECT * FROM Appointments 
WHERE AppointmentDate > GETDATE() 
AND Status = 'Scheduled';

-- Appointments in date range
SELECT * FROM Appointments
WHERE AppointmentDate BETWEEN '2023-10-01' AND '2023-10-31';

-- Appointments with cardiologist
SELECT a.AppointmentID, p.FirstName, p.LastName, a.AppointmentDate
FROM Appointments a
JOIN Patients p ON a.PatientID = p.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID
WHERE d.Specialty = 'Cardiology';

-- Appointment status with CASE
SELECT AppointmentID, PatientID, DoctorID, AppointmentDate,
       CASE Status
           WHEN 'Scheduled' THEN 'Upcoming'
           WHEN 'Completed' THEN 'Done'
           WHEN 'Cancelled' THEN 'Cancelled'
           ELSE Status
       END AS AppointmentStatus
FROM Appointments;

-- Bulk appointment updates (reschedule)
BEGIN TRANSACTION;
UPDATE Appointments
SET AppointmentDate = DATEADD(HOUR, 1, AppointmentDate)
WHERE DoctorID = 101 
AND AppointmentDate > GETDATE()
AND Status = 'Scheduled';

-- Verify no overlaps
IF EXISTS (
    SELECT 1 FROM Appointments a1
    JOIN Appointments a2 ON a1.DoctorID = a2.DoctorID
    AND a1.AppointmentID <> a2.AppointmentID
    WHERE a1.AppointmentDate < DATEADD(MINUTE, 30, a2.AppointmentDate)
    AND a2.AppointmentDate < DATEADD(MINUTE, 30, a1.AppointmentDate)
    AND a1.DoctorID = 101
)
BEGIN
    ROLLBACK;
    PRINT 'Reschedule failed - appointment overlaps';
END
ELSE
BEGIN
    COMMIT;
    PRINT 'Appointments rescheduled successfully';
END

/**************************************/
/* PROJECT 8: Gym Membership System */
/**************************************/

CREATE DATABASE GymManagement;
USE GymManagement;

-- Create tables
CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    JoinDate DATE DEFAULT GETDATE(),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20)
);

CREATE TABLE Plans (
    PlanID INT PRIMARY KEY,
    PlanName VARCHAR(50) NOT NULL,
    MonthlyFee DECIMAL(8,2) CHECK (MonthlyFee >= 0),
    DurationMonths INT CHECK (DurationMonths > 0)
);

CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY,
    MemberID INT,
    PlanID INT,
    StartDate DATE DEFAULT GETDATE(),
    EndDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (PlanID) REFERENCES Plans(PlanID),
    UNIQUE (MemberID, PlanID) -- Prevent duplicate memberships
);

-- Insert data
INSERT INTO Plans VALUES
(1, 'Basic', 29.99, 1),
(2, 'Standard', 59.99, 3),
(3, 'Premium', 99.99, 12);

INSERT INTO Members VALUES
(101, 'Emma', 'Thompson', '2023-01-10', 'emma.t@email.com', '555-1001'),
(102, 'James', 'Wilson', '2023-02-15', 'james.w@email.com', '555-1002'),
(103, 'Olivia', 'Brown', '2023-03-20', 'olivia.b@email.com', '555-1003');

INSERT INTO Bookings VALUES
(1, 101, 2, '2023-01-10', '2023-04-10'),
(2, 102, 3, '2023-02-15', '2024-02-15'),
(3, 103, 1, '2023-03-20', '2023-04-20');

-- Member plan details
SELECT m.MemberID, m.FirstName, m.LastName, 
       p.PlanName, p.MonthlyFee, b.StartDate, b.EndDate
FROM Members m
JOIN Bookings b ON m.MemberID = b.MemberID
JOIN Plans p ON b.PlanID = p.PlanID;

-- Plan-wise member count
SELECT p.PlanName, COUNT(b.MemberID) AS MemberCount
FROM Plans p
LEFT JOIN Bookings b ON p.PlanID = b.PlanID
GROUP BY p.PlanName
ORDER BY MemberCount DESC;

-- Member name filter
SELECT * FROM Members 
WHERE LastName LIKE 'W%' OR FirstName LIKE 'J%';

-- Incomplete registrations (members without plans)
SELECT m.*
FROM Members m
LEFT JOIN Bookings b ON m.MemberID = b.MemberID
WHERE b.BookingID IS NULL;

-- Highest paying member (subquery)
SELECT m.MemberID, m.FirstName, m.LastName,
       (SELECT SUM(p.MonthlyFee * 
        (DATEDIFF(MONTH, b.StartDate, 
         CASE WHEN b.EndDate > GETDATE() THEN GETDATE() ELSE b.EndDate END) + 1)
        FROM Bookings b
        JOIN Plans p ON b.PlanID = p.PlanID
        WHERE b.MemberID = m.MemberID) AS TotalPaid
FROM Members m
ORDER BY TotalPaid DESC;

/**************************************/
/* PROJECT 9: Restaurant Order System */
/**************************************/

CREATE DATABASE RestaurantSystem;
USE RestaurantSystem;

-- Create tables
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Phone VARCHAR(20),
    Email VARCHAR(100)
);

CREATE TABLE MenuItems (
    ItemID INT PRIMARY KEY,
    ItemName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Price DECIMAL(8,2) CHECK (Price >= 0),
    Description VARCHAR(200)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME DEFAULT GETDATE(),
    Status VARCHAR(20) DEFAULT 'Received',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ItemID INT,
    Quantity INT CHECK (Quantity > 0),
    SpecialRequests VARCHAR(200),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ItemID) REFERENCES MenuItems(ItemID)
);

-- Insert data
INSERT INTO Customers VALUES
(1, 'John', 'Smith', '555-2001', 'john.s@email.com'),
(2, 'Emily', 'Davis', '555-2002', 'emily.d@email.com');

INSERT INTO MenuItems VALUES
(101, 'Margherita Pizza', 'Pizza', 12.99, 'Classic tomato and mozzarella'),
(102, 'Caesar Salad', 'Salad', 8.99, 'Romaine lettuce with Caesar dressing'),
(103, 'Pasta Carbonara', 'Pasta', 14.99, 'Spaghetti with creamy egg sauce'),
(104, 'Tiramisu', 'Dessert', 6.99, 'Italian coffee-flavored dessert');

-- Multiple order insertion
INSERT INTO Orders VALUES
(1001, 1, '2023-10-05 18:30:00', 'Completed'),
(1002, 2, '2023-10-05 19:15:00', 'In Progress');

INSERT INTO OrderDetails VALUES
(1, 1001, 101, 1, 'Extra cheese'),
(2, 1001, 104, 2, NULL),
(3, 1002, 102, 1, 'Dressing on the side'),
(4, 1002, 103, 1, 'No bacon');

-- Full order details
SELECT o.OrderID, c.FirstName, c.LastName, o.OrderDate, o.Status,
       mi.ItemName, mi.Category, od.Quantity, mi.Price,
       od.Quantity * mi.Price AS ItemTotal,
       od.SpecialRequests
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN MenuItems mi ON od.ItemID = mi.ItemID;

-- Order totals
SELECT o.OrderID, SUM(od.Quantity * mi.Price) AS TotalBill
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN MenuItems mi ON od.ItemID = mi.ItemID
GROUP BY o.OrderID;

-- High-value customers
SELECT c.CustomerID, c.FirstName, c.LastName,
       SUM(od.Quantity * mi.Price) AS TotalSpent,
       COUNT(DISTINCT o.OrderID) AS OrderCount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN MenuItems mi ON od.ItemID = mi.ItemID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING SUM(od.Quantity * mi.Price) > 50
ORDER BY TotalSpent DESC;

-- Order placement transaction
BEGIN TRANSACTION;
DECLARE @NewOrderID INT = 1003;

-- Create order
INSERT INTO Orders (OrderID, CustomerID, OrderDate, Status)
VALUES (@NewOrderID, 2, GETDATE(), 'Received');

-- Add order items
INSERT INTO OrderDetails (OrderDetailID, OrderID, ItemID, Quantity, SpecialRequests)
VALUES 
(5, @NewOrderID, 101, 1, 'Well done'),
(6, @NewOrderID, 104, 1, NULL);

-- Update order total (if stored)
-- In a real system, you might update a TotalAmount column in Orders

COMMIT TRANSACTION;
PRINT 'Order placed successfully';

-- Order cancellation transaction
BEGIN TRANSACTION;
DECLARE @CancelOrderID INT = 1002;

-- Check if order can be cancelled (not completed)
IF EXISTS (SELECT 1 FROM Orders WHERE OrderID = @CancelOrderID AND Status NOT IN ('Completed', 'Cancelled'))
BEGIN
    UPDATE Orders SET Status = 'Cancelled' WHERE OrderID = @CancelOrderID;
    COMMIT TRANSACTION;
    PRINT 'Order cancelled successfully';
END
ELSE
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Order cannot be cancelled - already completed or cancelled';
END

/**************************************/
/* PROJECT 10: Hotel Booking System */
/**************************************/

CREATE DATABASE HotelBookingSystem;
USE HotelBookingSystem;

-- Create tables
CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY,
    RoomNumber VARCHAR(10) UNIQUE,
    RoomType VARCHAR(50),
    RatePerNight DECIMAL(8,2) CHECK (RatePerNight >= 0),
    Capacity INT CHECK (Capacity > 0),
    Status VARCHAR(20) DEFAULT 'Available'
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20)
);

CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY,
    RoomID INT,
    CustomerID INT,
    CheckInDate DATE,
    CheckOutDate DATE,
    TotalAmount DECIMAL(10,2),
    Status VARCHAR(20) DEFAULT 'Confirmed',
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CHECK (CheckOutDate > CheckInDate)
);

-- Insert data
INSERT INTO Rooms VALUES
(101, '101', 'Standard', 99.99, 2, 'Available'),
(102, '102', 'Standard', 99.99, 2, 'Available'),
(201, '201', 'Deluxe', 149.99, 4, 'Available'),
(202, '202', 'Deluxe', 149.99, 4, 'Available');

INSERT INTO Customers VALUES
(1, 'Robert', 'Johnson', 'robert.j@email.com', '555-3001'),
(2, 'Sarah', 'Williams', 'sarah.w@email.com', '555-3002');

-- New booking
INSERT INTO Bookings VALUES
(1, 101, 1, '2023-10-15', '2023-10-18', 
 (SELECT RatePerNight * DATEDIFF(DAY, '2023-10-15', '2023-10-18') FROM Rooms WHERE RoomID = 101),
 'Confirmed');

UPDATE Rooms SET Status = 'Booked' WHERE RoomID = 101;

-- Booking within date range
SELECT * FROM Bookings
WHERE CheckInDate BETWEEN '2023-10-01' AND '2023-10-31'
OR CheckOutDate BETWEEN '2023-10-01' AND '2023-10-31';

-- Room availability check (subquery)
SELECT * FROM Rooms
WHERE RoomID NOT IN (
    SELECT RoomID FROM Bookings
    WHERE Status = 'Confirmed'
    AND (
        ('2023-10-20' BETWEEN CheckInDate AND CheckOutDate)
        OR ('2023-10-25' BETWEEN CheckInDate AND CheckOutDate)
        OR (CheckInDate BETWEEN '2023-10-20' AND '2023-10-25')
    )
)
AND RoomType = 'Deluxe';

-- Bookings sorted by check-in date
SELECT b.BookingID, r.RoomNumber, r.RoomType,
       c.FirstName, c.LastName, 
       b.CheckInDate, b.CheckOutDate, b.TotalAmount
FROM Bookings b
JOIN Rooms r ON b.RoomID = r.RoomID
JOIN Customers c ON b.CustomerID = c.CustomerID
ORDER BY b.CheckInDate;

-- Booking update (extend stay)
BEGIN TRANSACTION;
DECLARE @OriginalCheckOut DATE;
SELECT @OriginalCheckOut = CheckOutDate FROM Bookings WHERE BookingID = 1;

UPDATE Bookings