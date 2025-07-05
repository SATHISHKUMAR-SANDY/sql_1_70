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




/* 
SQL SYSTEMS 11-20 - COMPLETE IMPLEMENTATION 
Single file with proper alignment and formatting
*/

-- ======================================================================
-- 11. UNIVERSITY GRADING SYSTEM
-- ======================================================================
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE Subjects (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(100),
    credit_hours INT
);

CREATE TABLE Marks (
    mark_id INT PRIMARY KEY,
    student_id INT,
    subject_id INT,
    marks INT,
    semester VARCHAR(20),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
);

-- Convert marks to grades
SELECT 
    s.name, 
    sub.subject_name, 
    m.marks,
    CASE 
        WHEN m.marks >= 90 THEN 'A'
        WHEN m.marks >= 80 THEN 'B'
        WHEN m.marks >= 70 THEN 'C'
        WHEN m.marks >= 60 THEN 'D'
        ELSE 'F'
    END AS grade
FROM Marks m
JOIN Students s ON m.student_id = s.student_id
JOIN Subjects sub ON m.subject_id = sub.subject_id;

-- Calculate GPA per student
SELECT 
    s.student_id,
    s.name,
    AVG(
        CASE 
            WHEN m.marks >= 90 THEN 4.0
            WHEN m.marks >= 80 THEN 3.0
            WHEN m.marks >= 70 THEN 2.0
            WHEN m.marks >= 60 THEN 1.0
            ELSE 0.0
        END
    ) AS gpa
FROM Students s
JOIN Marks m ON s.student_id = m.student_id
GROUP BY s.student_id, s.name;


-- ======================================================================
-- 12. DONATION AND NGO SYSTEM
-- ======================================================================
CREATE TABLE Donors (
    donor_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT
);

CREATE TABLE Campaigns (
    campaign_id INT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    start_date DATE,
    end_date DATE
);

CREATE TABLE Donations (
    donation_id INT PRIMARY KEY,
    donor_id INT,
    campaign_id INT,
    amount DECIMAL(10,2),
    donation_date DATE,
    payment_method VARCHAR(50),
    FOREIGN KEY (donor_id) REFERENCES Donors(donor_id),
    FOREIGN KEY (campaign_id) REFERENCES Campaigns(campaign_id)
);

-- Sample donor record
INSERT INTO Donors VALUES (
    1,
    'John Doe',
    'john@example.com',
    '1234567890',
    '123 Main St'
);

-- Total donations per donor
SELECT 
    d.donor_id,
    d.name,
    SUM(dn.amount) AS total_donated
FROM Donors d
JOIN Donations dn ON d.donor_id = dn.donor_id
GROUP BY d.donor_id, d.name;

-- Classify donations by size
SELECT 
    donation_id,
    donor_id,
    amount,
    CASE 
        WHEN amount < 50 THEN 'Small'
        WHEN amount BETWEEN 50 AND 500 THEN 'Medium'
        ELSE 'Large'
    END AS donation_size
FROM Donations;


-- ======================================================================
-- 13. EVENT REGISTRATION SYSTEM
-- ======================================================================
CREATE TABLE Events (
    event_id INT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    date DATE,
    location VARCHAR(100),
    capacity INT
);

CREATE TABLE Participants (
    participant_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    city VARCHAR(50)
);

CREATE TABLE Registrations (
    registration_id INT PRIMARY KEY,
    event_id INT,
    participant_id INT,
    registration_date DATE,
    UNIQUE (event_id, participant_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (participant_id) REFERENCES Participants(participant_id)
);

-- List participants per event
SELECT 
    e.name AS event_name,
    p.name AS participant_name,
    p.email
FROM Events e
JOIN Registrations r ON e.event_id = r.event_id
JOIN Participants p ON r.participant_id = p.participant_id;

-- Distinct cities of participants
SELECT DISTINCT city FROM Participants;

-- Most popular event
SELECT 
    event_id,
    COUNT(*) AS registrations 
FROM Registrations 
GROUP BY event_id 
ORDER BY registrations DESC 
LIMIT 1;


-- ======================================================================
-- 14. TRANSPORT & TICKET BOOKING SYSTEM
-- ======================================================================
CREATE TABLE Routes (
    route_id INT PRIMARY KEY,
    origin VARCHAR(100),
    destination VARCHAR(100),
    distance_km INT,
    duration_minutes INT
);

CREATE TABLE Seats (
    seat_id INT PRIMARY KEY,
    route_id INT,
    seat_number VARCHAR(10),
    seat_class VARCHAR(20),
    CHECK (seat_number ~ '^[A-Z][0-9]+$'),
    FOREIGN KEY (route_id) REFERENCES Routes(route_id)
);

CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY,
    passenger_id INT,
    seat_id INT,
    route_id INT,
    booking_date TIMESTAMP,
    travel_date DATE,
    fare DECIMAL(10,2),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (seat_id) REFERENCES Seats(seat_id),
    FOREIGN KEY (route_id) REFERENCES Routes(route_id)
);

-- Available seats query
SELECT * FROM Seats 
WHERE seat_id NOT IN (
    SELECT seat_id FROM Tickets WHERE travel_date = '2023-11-15'
);


-- ======================================================================
-- 15. RETAIL CUSTOMER LOYALTY TRACKER
-- ======================================================================
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    join_date DATE,
    loyalty_tier VARCHAR(20) DEFAULT 'Bronze'
);

CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    amount DECIMAL(10,2),
    transaction_date TIMESTAMP,
    points_earned INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Rewards (
    reward_id INT PRIMARY KEY,
    name VARCHAR(100),
    points_required INT,
    description TEXT
);

-- Update loyalty tier
UPDATE Customers
SET loyalty_tier = CASE
    WHEN (SELECT SUM(points_earned) FROM Transactions WHERE customer_id = 1) >= 1000 THEN 'Gold'
    WHEN (SELECT SUM(points_earned) FROM Transactions WHERE customer_id = 1) >= 500 THEN 'Silver'
    ELSE 'Bronze'
END
WHERE customer_id = 1;


-- ======================================================================
-- 16. ATTENDANCE MANAGEMENT SYSTEM
-- ======================================================================
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    position VARCHAR(50)
);

CREATE TABLE Attendance (
    attendance_id INT PRIMARY KEY,
    employee_id INT,
    check_in TIMESTAMP,
    check_out TIMESTAMP,
    date DATE,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

-- Find late check-ins (after 9:30 AM)
SELECT 
    e.name,
    a.check_in
FROM Attendance a
JOIN Employees e ON a.employee_id = e.employee_id
WHERE TIME(a.check_in) BETWEEN '09:30:00' AND '17:00:00';

-- Most punctual employee
SELECT 
    e.employee_id,
    e.name,
    COUNT(*) AS on_time_days
FROM Attendance a
JOIN Employees e ON a.employee_id = e.employee_id
WHERE TIME(a.check_in) <= '09:00:00'
GROUP BY e.employee_id, e.name
ORDER BY on_time_days DESC
LIMIT 1;


-- ======================================================================
-- 17. MOVIE TICKET BOOKING SYSTEM
-- ======================================================================
CREATE TABLE Movies (
    movie_id INT PRIMARY KEY,
    title VARCHAR(100),
    genre VARCHAR(50),
    duration_min INT,
    rating VARCHAR(10)
);

CREATE TABLE Shows (
    show_id INT PRIMARY KEY,
    movie_id INT,
    show_time TIMESTAMP,
    theater_id INT,
    available_seats INT,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY,
    show_id INT,
    customer_id INT,
    seat_number VARCHAR(10),
    booking_time TIMESTAMP,
    price DECIMAL(10,2),
    FOREIGN KEY (show_id) REFERENCES Shows(show_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Most watched movie
SELECT 
    m.title,
    COUNT(t.ticket_id) AS tickets_sold
FROM Movies m
JOIN Shows s ON m.movie_id = s.movie_id
JOIN Tickets t ON s.show_id = t.show_id
GROUP BY m.title
ORDER BY tickets_sold DESC
LIMIT 1;


-- ======================================================================
-- 18. FREELANCE PROJECT TRACKER
-- ======================================================================
CREATE TABLE Freelancers (
    freelancer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    skills TEXT,
    hourly_rate DECIMAL(10,2)
);

CREATE TABLE Projects (
    project_id INT PRIMARY KEY,
    freelancer_id INT,
    title VARCHAR(100),
    description TEXT,
    start_date DATE,
    deadline DATE,
    status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (freelancer_id) REFERENCES Freelancers(freelancer_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    project_id INT,
    amount DECIMAL(10,2),
    payment_date DATE,
    payment_method VARCHAR(50),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);

-- Earnings per freelancer
SELECT 
    f.freelancer_id,
    f.name,
    SUM(p.amount) AS total_earnings
FROM Freelancers f
JOIN Projects pr ON f.freelancer_id = pr.freelancer_id
JOIN Payments p ON pr.project_id = p.project_id
GROUP BY f.freelancer_id, f.name;


-- ======================================================================
-- 19. CLINIC AND MEDICAL RECORD SYSTEM
-- ======================================================================
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    name VARCHAR(100),
    dob DATE,
    gender VARCHAR(10),
    contact VARCHAR(20)
);

CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    name VARCHAR(100),
    specialization VARCHAR(100),
    contact VARCHAR(20)
);

CREATE TABLE Visits (
    visit_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    visit_date DATE,
    diagnosis TEXT,
    follow_up_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

CREATE TABLE Prescriptions (
    prescription_id INT PRIMARY KEY,
    visit_id INT,
    medication VARCHAR(100),
    dosage VARCHAR(50),
    duration VARCHAR(50),
    FOREIGN KEY (visit_id) REFERENCES Visits(visit_id)
);

-- Patients without follow-up
SELECT 
    p.patient_id,
    p.name,
    v.visit_date
FROM Patients p
JOIN Visits v ON p.patient_id = v.patient_id
WHERE v.follow_up_date IS NULL;


-- ======================================================================
-- 20. WAREHOUSE PRODUCT MOVEMENT SYSTEM
-- ======================================================================
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    category VARCHAR(50),
    unit_price DECIMAL(10,2)
);

CREATE TABLE Inward (
    inward_id INT PRIMARY KEY,
    product_id INT,
    quantity INT,
    date DATE,
    supplier VARCHAR(100),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Outward (
    outward_id INT PRIMARY KEY,
    product_id INT,
    quantity INT,
    date DATE,
    customer VARCHAR(100),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE StockLevels (
    stock_id INT PRIMARY KEY,
    product_id INT,
    current_quantity INT,
    last_updated DATE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Most moved products
SELECT 
    p.product_id,
    p.name,
    (SUM(i.quantity) + SUM(o.quantity)) AS total_movement
FROM Products p
LEFT JOIN Inward i ON p.product_id = i.product_id
LEFT JOIN Outward o ON p.product_id = o.product_id
GROUP BY p.product_id, p.name
ORDER BY total_movement DESC
LIMIT 5;




