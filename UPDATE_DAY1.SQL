-- CREATE DATABASE school;

-- USE school;

-- CREATE TABLE students(
-- ID INT PRIMARY KEY,
-- NAME VARCHAR(100),
-- AGE INT ,
-- DEPARTMENT VARCHAR(100)
-- );

-- SHOW tables;


-- TASK2


-- CREATE table COURSES(
-- COURSEID INT ,
-- TITLE varchar(100),
-- CREDITS INT
-- );
-- SHOW TABLES;




-- TASK3
-- select *
-- FROM STUDENTS

-- INSERT INTO STUDENTS (ID,NAME,AGE,DEPARTMENT)
-- VALUES
-- (1,"SATHISH",22,"BSC(IT)"),
-- (2,"SURESH",23,"CS");


-- SELECT *
-- FROM STUDENTS




-- TASK4


-- INSERT INTO COURSES(COURSE_ID,TITLE,CREDITS)
-- VALUES
-- (1,"DATA SCIENCE",3),
-- (2,"AWS",5);

-- SELECT *
-- FROM COURSES;




-- TASK 5

-- INSERT INTO STUDENTS(ID,NAME,AGE,DEPARTMENT)
-- VALUES
-- (3,"MUKESH",33,"MA"),
-- (4,"MURUGAN",30,"M.COM"),
-- (5,"SAKTHI",24,"B.COM"),
-- (6,"MAHA",19,"BA.ENGLISH");

-- SELECT *
-- FROM STUDENTS



--  Task 6

-- SELECT *
-- FROM STUDENTS;



-- TASK 7


-- SELECT NAME,AGE
-- FROM STUDENTS;


-- TASK8


-- SELECT DISTINCT AGE,NAME
-- FROM STUDENTS;


-- TASK 9

-- SELECT NAME,AGE
-- FROM STUDENTS
-- WHERE AGE=20;


-- TASK10

-- SELECT TITLE,CREDITS
-- FROM COURSES
-- WHERE CREDITS>3


-- TASK11

-- SELECT NAME,DEPARTMENT
-- FROM STUDENTS
-- WHERE DEPARTMENT = 'CS'


-- TASK12

-- SELECT AGE,NAME
-- FROM STUDENTS
-- WHERE AGE!=18

-- TASK13

-- SELECT NAME
-- FROM STUDENTS
-- WHERE NAME LIKE("S%")



-- TASK14
-- SELECT NAME
-- FROM STUDENTS
-- WHERE NAME LIKE ("%N%")


-- TASK15

-- SELECT NAME
-- FROM STUDENTS
-- WHERE NAME LIKE("S__DY")


-- TASK16
-- SELECT NAME,AGE
-- FROM STUDENTS
-- WHERE AGE>18 AND AGE<22

--  TASK17

-- SELECT COURSE_ID
-- FROM COURSES
-- WHERE COURSE_ID IN (101,102)


-- TASK18

-- SELECT NAME,DEPARTMENT
-- FROM STUDENTS
-- WHERE DEPARTMENT !='Physics';


-- TASK19

-- SELECT NAME,DEPARTMENT
-- FROM STUDENTS
-- WHERE DEPARTMENT IS NULL;




-- TASK 20

-- SELECT NAME,DEPARTMENT
-- FROM STUDENTS
-- WHERE DEPARTMENT IS NOT NULL


-- TASK21


-- SELECT NAME,DEPARTMENT
-- FROM STUDENTS
-- WHERE DEPARTMENT="MA" AND AGE>18

-- TASK22

-- SELECT NAME,DEPARTMENT
-- FROM STUDENTS
-- WHERE DEPARTMENT ="BIOLOGY" OR DEPARTMENT = "HEMISTRY"


-- TASK 23

-- SELECT NAME,DEPARTMENT,AGE
-- FROM STUDENTS
-- WHERE DEPARTMENT!="HISTORY" AND AGE<21

-- TASK 24

-- SELECT NAME
-- FROM STUDENTS
-- ORDER BY NAME ASC



-- TASK25


-- SELECT CREDITS
-- FROM COURSES
-- ORDER BY CREDITS DESC




-- TASK 26

-- SELECT DEPARTMENT,AGE
-- FROM STUDENTS
-- ORDER BY DEPARTMENT ASC,AGE DESC;


-- TASK 27

-- SELECT *
-- FROM STUDENTS
-- LIMIT 5



-- TASK28

-- SELECT *
-- FROM COURSES
-- ORDER BY CREDITS desc
-- LIMIT 3



-- TASK29

-- ALTER TABLE STUDENTS
-- ADD EMAIL VARCHAR(100)


-- TASK30

-- UPDATE STUDENTS
-- SET EMAIL = "SATHISH@HMAIL.COM"
-- WHERE ID =1;

-- SELECT * FROM STUDENTS;

-- TASK31
-- DELETE from STUDENTS
-- WHERE AGE>25 ;
-- SELECT * FROM STUDENTS;

-- TASK32

-- DELETE FROM courses
-- WHERE COURSE_ID =1;

-- SELECT * FROM COURSES;\


-- TASK 34

-- INSERT INTO students(ID,NAME,AGE,DEPARTMENT)
-- VALUES(8,"MANDY",44,NULL);
-- SELECT * FROM STUDENTS

-- TASK35

-- SELECT * FROM STUDENTS
-- WHERE DEPARTMENT IS NULL

-- TASK36
-- UPDATE  STUDENTS
-- SET DEPARTMENT = "COOK"
-- WHERE NAME = "SANDY";

-- SELECT * FROM STUDENTS

-- TASK 37

-- UPDATE STUDENTS
-- SET AGE = AGE+1
-- WHERE AGE IS NOT NULL;

-- SELECT * FROM STUDENTS 


-- TASK38


-- SELECT NAME
-- FROM STUDENTS
-- WHERE NAME LIKE("%A");



-- TASK 39

-- SELECT NAME
-- FROM STUDENTS
-- WHERE NAME LIKE("%AR%")


-- TASK40


-- SELECT AGE,DEPARTMENT
-- FROM STUDENTS
-- WHERE DEPARTMENT = 'Physics' OR DEPARTMENT = 'Mathematics'
-- ORDER BY AGE desc


-- TASK 41

-- SELECT distinct AGE
-- FROM STUDENTS
-- WHERE DEPARTMENT IS NOT NULL



-- TASK 42

-- SELECT * 
-- FROM STUDENTS
-- ORDER BY NAME
-- LIMIT 3





-- MINI 20 PROJECTS 

-- PROJECT 1


-- TASK43
-- DELETE FROM STUDENTS
-- WHERE DEPARTMENT IS NULL


-- 20 MINI PROJECTS


##Library Management System


-- Create tables
CREATE TABLE Authors (
    author_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    nationality VARCHAR(50)
);

CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author_id INT,
    isbn VARCHAR(20),
    published_year INT,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

CREATE TABLE Members (
    member_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    join_date DATE
);

CREATE TABLE Loans (
    loan_id INT PRIMARY KEY,
    book_id INT,
    member_id INT,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- Insert sample data
INSERT INTO Authors VALUES 
(1, 'J.K. Rowling', 'British'),
(2, 'George R.R. Martin', 'American'),
(3, 'Agatha Christie', 'British');

INSERT INTO Books VALUES 
(1, 'Harry Potter and the Philosopher''s Stone', 1, '9780747532743', 1997),
(2, 'A Game of Thrones', 2, '9780553103540', 1996),
(3, 'Murder on the Orient Express', 3, '9780062073501', 1934),
(4, 'Harry Potter and the Chamber of Secrets', 1, '9780747538493', 1998),
(5, 'The ABC Murders', 3, '9780062073563', 1936);

INSERT INTO Members VALUES 
(1, 'John Smith', 'john@email.com', '2020-01-15'),
(2, 'Sarah Johnson', 'sarah@email.com', '2020-03-22'),
(3, 'Michael Brown', 'michael@email.com', '2021-02-10');

INSERT INTO Loans VALUES 
(1, 1, 1, '2023-01-10', '2023-01-24', '2023-01-22'),
(2, 2, 2, '2023-02-05', '2023-02-19', NULL),
(3, 3, 3, '2023-02-15', '2023-03-01', NULL),
(4, 4, 1, '2023-01-20', '2023-02-03', '2023-02-01'),
(5, 1, 3, '2023-03-01', '2023-03-15', NULL);

-- Queries
-- Books currently loaned out
SELECT b.title, m.name AS member_name, l.loan_date, l.due_date
FROM Loans l
JOIN Books b ON l.book_id = b.book_id
JOIN Members m ON l.member_id = m.member_id
WHERE l.return_date IS NULL;

-- Overdue books
SELECT b.title, m.name AS member_name, l.due_date
FROM Loans l
JOIN Books b ON l.book_id = b.book_id
JOIN Members m ON l.member_id = m.member_id
WHERE l.return_date IS NULL AND l.due_date < CURRENT_DATE;

-- Members with most loans
SELECT m.name, COUNT(l.loan_id) AS loan_count
FROM Members m
JOIN Loans l ON m.member_id = l.member_id
GROUP BY m.name
ORDER BY loan_count DESC;



##Student Attendance Tracker

-- Create tables
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    enrollment_date DATE
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    instructor VARCHAR(100)
);

CREATE TABLE Attendance (
    attendance_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    date DATE NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Present', 'Absent')),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Insert sample data
INSERT INTO Students VALUES 
(1, 'Alice Johnson', 'alice@school.edu', '2022-09-01'),
(2, 'Bob Smith', 'bob@school.edu', '2022-09-01'),
(3, 'Charlie Brown', 'charlie@school.edu', '2022-09-01'),
(4, 'Diana Miller', 'diana@school.edu', '2022-09-01'),
(5, 'Ethan Wilson', 'ethan@school.edu', '2022-09-01');

INSERT INTO Courses VALUES 
(1, 'Mathematics', 'Dr. Smith'),
(2, 'English Literature', 'Prof. Johnson'),
(3, 'Computer Science', 'Dr. Davis');

-- Insert attendance records for 10 days
-- For simplicity, inserting sample records for 2 students in 1 course
INSERT INTO Attendance VALUES 
(1, 1, 1, '2023-01-01', 'Present'),
(2, 1, 1, '2023-01-02', 'Present'),
(3, 1, 1, '2023-01-03', 'Present'),
(4, 1, 1, '2023-01-04', 'Present'),
(5, 1, 1, '2023-01-05', 'Absent'),
(6, 2, 1, '2023-01-01', 'Present'),
(7, 2, 1, '2023-01-02', 'Absent'),
(8, 2, 1, '2023-01-03', 'Present'),
(9, 2, 1, '2023-01-04', 'Absent'),
(10, 2, 1, '2023-01-05', 'Present');

-- Queries
-- Students with >90% attendance in a course
SELECT s.name, c.name AS course_name,
       COUNT(CASE WHEN a.status = 'Present' THEN 1 END) * 100.0 / COUNT(*) AS attendance_percentage
FROM Students s
JOIN Attendance a ON s.student_id = a.student_id
JOIN Courses c ON a.course_id = c.course_id
GROUP BY s.name, c.name
HAVING COUNT(CASE WHEN a.status = 'Present' THEN 1 END) * 100.0 / COUNT(*) > 90;

-- Students absent on a specific date
SELECT s.name, c.name AS course_name
FROM Students s
JOIN Attendance a ON s.student_id = a.student_id
JOIN Courses c ON a.course_id = c.course_id
WHERE a.date = '2023-01-05' AND a.status = 'Absent';





#Employee Payroll System


-- Create tables
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    hire_date DATE,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

CREATE TABLE Salaries (
    salary_id INT PRIMARY KEY,
    emp_id INT,
    amount DECIMAL(10,2) NOT NULL,
    effective_date DATE NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

-- Insert sample data
INSERT INTO Departments VALUES 
(1, 'Engineering', 'Floor 1'),
(2, 'Marketing', 'Floor 2'),
(3, 'Finance', 'Floor 3');

INSERT INTO Employees VALUES 
(1, 'John Doe', 'john@company.com', '2020-01-15', 1),
(2, 'Jane Smith', 'jane@company.com', '2019-05-22', 1),
(3, 'Robert Johnson', 'robert@company.com', '2021-03-10', 2),
(4, 'Emily Davis', 'emily@company.com', '2018-11-05', 2),
(5, 'Michael Brown', 'michael@company.com', '2022-02-18', 3),
(6, 'Sarah Wilson', 'sarah@company.com', '2020-07-30', 3),
(7, 'David Miller', 'david@company.com', '2021-09-12', 1),
(8, 'Lisa Taylor', 'lisa@company.com', '2019-12-01', 2),
(9, 'James Anderson', 'james@company.com', '2022-04-15', 3),
(10, 'Jennifer Thomas', 'jennifer@company.com', '2020-08-20', 1);

INSERT INTO Salaries VALUES 
(1, 1, 75000.00, '2023-01-01'),
(2, 2, 85000.00, '2023-01-01'),
(3, 3, 65000.00, '2023-01-01'),
(4, 4, 70000.00, '2023-01-01'),
(5, 5, 72000.00, '2023-01-01'),
(6, 6, 68000.00, '2023-01-01'),
(7, 7, 78000.00, '2023-01-01'),
(8, 8, 72000.00, '2023-01-01'),
(9, 9, 69000.00, '2023-01-01'),
(10, 10, 82000.00, '2023-01-01');

-- Queries
-- Employees in a department earning above a certain salary
SELECT e.name, d.name AS department, s.amount AS salary
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
JOIN Salaries s ON e.emp_id = s.emp_id
WHERE d.name = 'Engineering' AND s.amount > 80000;

-- Update salary for employees based on performance (10% raise)
UPDATE Salaries
SET amount = amount * 1.10
WHERE emp_id IN (1, 2, 10); -- Top performers
 
 
 
 
##Online Store Product Catalog


-- Create tables
CREATE TABLE Categories (
    category_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL,
    category_id INT,
    supplier_id INT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

-- Insert sample data
INSERT INTO Categories VALUES 
(1, 'Electronics', 'Electronic devices and accessories'),
(2, 'Clothing', 'Apparel and fashion items'),
(3, 'Home & Garden', 'Home improvement and garden supplies');

INSERT INTO Suppliers VALUES 
(1, 'TechGadgets Inc.', 'sales@techgadgets.com', '555-1234'),
(2, 'FashionWorld Ltd.', 'contact@fashionworld.com', '555-5678'),
(3, 'HomeEssentials Co.', 'info@homeessentials.com', '555-9012');

INSERT INTO Products VALUES 
(1, 'Smartphone X', 'Latest model smartphone', 799.99, 50, 1, 1),
(2, 'Wireless Earbuds', 'Noise cancelling wireless earbuds', 149.99, 100, 1, 1),
(3, 'Men''s T-Shirt', 'Cotton crew neck t-shirt', 24.99, 200, 2, 2),
(4, 'Women''s Jeans', 'Slim fit denim jeans', 49.99, 150, 2, 2),
(5, 'Lawn Mower', 'Electric lawn mower', 199.99, 30, 3, 3),
(6, 'Coffee Maker', '12-cup programmable coffee maker', 89.99, 40, 3, 3),
(7, 'Smart Watch', 'Fitness tracking smartwatch', 129.99, 60, 1, 1),
(8, 'Desk Lamp', 'LED adjustable desk lamp', 39.99, 80, 3, 3);

-- Queries
-- Products by category
SELECT p.name, p.price, c.name AS category
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
WHERE c.name = 'Electronics';

-- Products in price range
SELECT name, price
FROM Products
WHERE price BETWEEN 50.00 AND 150.00
ORDER BY price;

-- Top 5 most expensive products
SELECT name, price
FROM Products
ORDER BY price DESC
LIMIT 5;




##Hospital Patient Record Management



-- Create tables
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dob DATE,
    gender VARCHAR(10),
    phone VARCHAR(20),
    address TEXT
);

CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    purpose TEXT,
    status VARCHAR(20) DEFAULT 'Scheduled',
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Insert sample data
INSERT INTO Patients VALUES 
(1, 'John Smith', '1980-05-15', 'Male', '555-1111', '123 Main St'),
(2, 'Sarah Johnson', '1975-08-22', 'Female', '555-2222', '456 Oak Ave'),
(3, 'Michael Brown', '1990-03-10', 'Male', '555-3333', '789 Pine Rd'),
(4, 'Emily Davis', '1988-11-05', 'Female', '555-4444', '321 Elm St'),
(5, 'David Wilson', '1972-07-30', 'Male', '555-5555', '654 Maple Dr');

INSERT INTO Doctors VALUES 
(1, 'Dr. Robert Miller', 'Cardiology', '555-6666', 'dr.miller@hospital.com'),
(2, 'Dr. Lisa Taylor', 'Pediatrics', '555-7777', 'dr.taylor@hospital.com'),
(3, 'Dr. James Anderson', 'Orthopedics', '555-8888', 'dr.anderson@hospital.com');

INSERT INTO Appointments VALUES 
(1, 1, 1, '2023-04-01', '09:00:00', 'Annual checkup', 'Completed'),
(2, 2, 2, '2023-04-01', '10:30:00', 'Child vaccination', 'Completed'),
(3, 3, 3, '2023-04-02', '14:00:00', 'Knee pain consultation', 'Scheduled'),
(4, 4, 1, '2023-04-03', '11:00:00', 'Heart palpitations', 'Scheduled'),
(5, 5, 2, '2023-04-03', '15:30:00', 'New patient consultation', 'Scheduled'),
(6, 1, 3, '2023-04-04', '13:00:00', 'Follow-up on back pain', 'Scheduled'),
(7, 2, 1, '2023-04-05', '09:30:00', 'Cardiac stress test', 'Scheduled');

-- Queries
-- Appointments for a doctor within a date range
SELECT a.appointment_date, a.appointment_time, p.name AS patient_name, a.purpose
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
WHERE a.doctor_id = 1 
AND a.appointment_date BETWEEN '2023-04-01' AND '2023-04-03'
ORDER BY a.appointment_date, a.appointment_time;

-- Patients without assigned doctors (no appointments)
SELECT p.name, p.phone
FROM Patients p
LEFT JOIN Appointments a ON p.patient_id = a.patient_id
WHERE a.appointment_id IS NULL;




##Movie Rental System

-- Create tables
CREATE TABLE Movies (
    movie_id INT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    genre VARCHAR(100),
    release_year INT,
    director VARCHAR(100),
    rating VARCHAR(10)
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    join_date DATE
);

CREATE TABLE Rentals (
    rental_id INT PRIMARY KEY,
    movie_id INT,
    customer_id INT,
    rental_date DATE NOT NULL,
    return_date DATE,
    due_date DATE NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Insert sample data
INSERT INTO Movies VALUES 
(1, 'The Shawshank Redemption', 'Drama', 1994, 'Frank Darabont', 'R'),
(2, 'The Godfather', 'Crime', 1972, 'Francis Ford Coppola', 'R'),
(3, 'Pulp Fiction', 'Crime', 1994, 'Quentin Tarantino', 'R'),
(4, 'The Dark Knight', 'Action', 2008, 'Christopher Nolan', 'PG-13'),
(5, 'Inception', 'Sci-Fi', 2010, 'Christopher Nolan', 'PG-13'),
(6, 'Toy Story', 'Animation', 1995, 'John Lasseter', 'G'),
(7, 'The Matrix', 'Sci-Fi', 1999, 'Lana Wachowski', 'R');

INSERT INTO Customers VALUES 
(1, 'John Smith', 'john@email.com', '555-1111', '2022-01-15'),
(2, 'Sarah Johnson', 'sarah@email.com', '555-2222', '2022-03-22'),
(3, 'Michael Brown', 'michael@email.com', '555-3333', '2022-05-10'),
(4, 'Emily Davis', 'emily@email.com', '555-4444', '2022-07-05'),
(5, 'David Wilson', 'david@email.com', '555-5555', '2022-09-30');

INSERT INTO Rentals VALUES 
(1, 1, 1, '2023-03-01', '2023-03-05', '2023-03-08'),
(2, 2, 2, '2023-03-10', '2023-03-15', '2023-03-17'),
(3, 3, 3, '2023-03-15', NULL, '2023-03-22'),
(4, 4, 4, '2023-03-20', NULL, '2023-03-27'),
(5, 5, 5, '2023-03-25', NULL, '2023-04-01'),
(6, 6, 1, '2023-03-28', NULL, '2023-04-04'),
(7, 7, 2, '2023-04-01', NULL, '2023-04-08');

-- Queries
-- Overdue rentals
SELECT m.title, c.name AS customer_name, r.due_date
FROM Rentals r
JOIN Movies m ON r.movie_id = m.movie_id
JOIN Customers c ON r.customer_id = c.customer_id
WHERE r.return_date IS NULL AND r.due_date < CURRENT_DATE;

-- Customers who rented specific genres
SELECT DISTINCT c.name, c.phone
FROM Customers c
JOIN Rentals r ON c.customer_id = r.customer_id
JOIN Movies m ON r.movie_id = m.movie_id
WHERE m.genre = 'Sci-Fi';

-- Top 3 most rented movies
SELECT m.title, COUNT(r.rental_id) AS rental_count
FROM Movies m
JOIN Rentals r ON m.movie_id = r.movie_id
GROUP BY m.title
ORDER BY rental_count DESC
LIMIT 3;




##Restaurant Reservation System


-- Create tables
CREATE TABLE Tables (
    table_id INT PRIMARY KEY,
    capacity INT NOT NULL,
    location VARCHAR(100)
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100)
);

CREATE TABLE Reservations (
    reservation_id INT PRIMARY KEY,
    table_id INT,
    customer_id INT,
    reservation_date DATE NOT NULL,
    reservation_time TIME NOT NULL,
    party_size INT NOT NULL,
    special_requests TEXT,
    FOREIGN KEY (table_id) REFERENCES Tables(table_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Insert sample data
INSERT INTO Tables VALUES 
(1, 2, 'Window'),
(2, 2, 'Center'),
(3, 4, 'Window'),
(4, 4, 'Center'),
(5, 6, 'Private Room'),
(6, 8, 'Private Room');

INSERT INTO Customers VALUES 
(1, 'John Smith', '555-1111', 'john@email.com'),
(2, 'Sarah Johnson', '555-2222', 'sarah@email.com'),
(3, 'Michael Brown', '555-3333', 'michael@email.com'),
(4, 'Emily Davis', '555-4444', 'emily@email.com'),
(5, 'David Wilson', '555-5555', 'david@email.com');

INSERT INTO Reservations VALUES 
(1, 1, 1, '2023-04-15', '18:00:00', 2, 'Anniversary celebration'),
(2, 3, 2, '2023-04-15', '19:30:00', 4, ''),
(3, 5, 3, '2023-04-16', '20:00:00', 6, 'Birthday party'),
(4, 2, 4, '2023-04-16', '18:30:00', 2, 'Vegetarian options needed'),
(5, 4, 5, '2023-04-17', '19:00:00', 4, ''),
(6, 1, 2, '2023-04-18', '18:00:00', 2, ''),
(7, 3, 1, '2023-04-19', '19:30:00', 4, '');

-- Queries
-- Available tables at a given time
SELECT t.table_id, t.capacity, t.location
FROM Tables t
WHERE t.table_id NOT IN (
    SELECT r.table_id
    FROM Reservations r
    WHERE r.reservation_date = '2023-04-15' 
    AND r.reservation_time BETWEEN '18:00:00' AND '20:00:00'
)
AND t.capacity >= 2; -- Assuming party size is 2

-- Customers with more than 2 reservations
SELECT c.name, COUNT(r.reservation_id) AS reservation_count
FROM Customers c
JOIN Reservations r ON c.customer_id = r.customer_id
GROUP BY c.name
HAVING COUNT(r.reservation_id) > 2;



##School Grading System

-- Create tables
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    enrollment_year INT
);

CREATE TABLE Subjects (
    subject_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    teacher VARCHAR(100),
    credit_hours INT
);

CREATE TABLE Grades (
    grade_id INT PRIMARY KEY,
    student_id INT,
    subject_id INT,
    grade DECIMAL(4,2) CHECK (grade BETWEEN 0 AND 100),
    semester VARCHAR(20),
    academic_year INT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
);

-- Insert sample data
INSERT INTO Students VALUES 
(1, 'Alice Johnson', 'alice@school.edu', 2022),
(2, 'Bob Smith', 'bob@school.edu', 2022),
(3, 'Charlie Brown', 'charlie@school.edu', 2023),
(4, 'Diana Miller', 'diana@school.edu', 2021),
(5, 'Ethan Wilson', 'ethan@school.edu', 2023);

INSERT INTO Subjects VALUES 
(1, 'Mathematics', 'Mr. Davis', 4),
(2, 'English Literature', 'Ms. Thompson', 3),
(3, 'Computer Science', 'Dr. Lee', 4),
(4, 'Physics', 'Dr. Garcia', 4),
(5, 'History', 'Mr. Wilson', 3);

INSERT INTO Grades VALUES 
(1, 1, 1, 92.5, 'Fall', 2022),
(2, 1, 2, 88.0, 'Fall', 2022),
(3, 2, 1, 76.5, 'Fall', 2022),
(4, 2, 3, 81.0, 'Fall', 2022),
(5, 3, 4, 65.5, 'Spring', 2023),
(6, 3, 5, 72.0, 'Spring', 2023),
(7, 4, 1, 95.0, 'Fall', 2022),
(8, 4, 4, 89.5, 'Fall', 2022),
(9, 5, 2, 68.0, 'Spring', 2023),
(10, 5, 3, 74.5, 'Spring', 2023);

-- Queries
-- Students with highest grade per subject
SELECT s.name AS student_name, sub.name AS subject_name, g.grade
FROM Grades g
JOIN Students s ON g.student_id = s.student_id
JOIN Subjects sub ON g.subject_id = sub.subject_id
WHERE (g.subject_id, g.grade) IN (
    SELECT subject_id, MAX(grade)
    FROM Grades
    GROUP BY subject_id
)
ORDER BY sub.name;

-- Students who failed (grade below passing threshold of 70)
SELECT s.name AS student_name, sub.name AS subject_name, g.grade
FROM Grades g
JOIN Students s ON g.student_id = s.student_id
JOIN Subjects sub ON g.subject_id = sub.subject_id
WHERE g.grade < 70;




#Travel Agency Booking System

-- Create tables
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    join_date DATE
);

CREATE TABLE Trips (
    trip_id INT PRIMARY KEY,
    destination VARCHAR(100) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    price DECIMAL(10,2),
    capacity INT
);

CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY,
    customer_id INT,
    trip_id INT,
    booking_date DATE NOT NULL,
    travelers INT,
    total_price DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'Confirmed',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (trip_id) REFERENCES Trips(trip_id)
);

-- Insert sample data
INSERT INTO Customers VALUES 
(1, 'John Smith', 'john@email.com', '555-1111', '2022-01-15'),
(2, 'Sarah Johnson', 'sarah@email.com', '555-2222', '2022-03-22'),
(3, 'Michael Brown', 'michael@email.com', '555-3333', '2022-05-10'),
(4, 'Emily Davis', 'emily@email.com', '555-4444', '2022-07-05'),
(5, 'David Wilson', 'david@email.com', '555-5555', '2022-09-30');

INSERT INTO Trips VALUES 
(1, 'Paris', 'Romantic getaway in the City of Lights', '2023-05-15', '2023-05-22', 1200.00, 20),
(2, 'Tokyo', 'Explore modern and traditional Japan', '2023-06-10', '2023-06-20', 2500.00, 15),
(3, 'Rome', 'Historical tour of ancient Rome', '2023-07-05', '2023-07-12', 1500.00, 25),
(4, 'Bali', 'Relaxing beach vacation', '2023-08-15', '2023-08-25', 1800.00, 18),
(5, 'New York', 'City that never sleeps', '2023-09-01', '2023-09-08', 1300.00, 30);

INSERT INTO Bookings VALUES 
(1, 1, 1, '2023-01-10', 2, 2400.00, 'Confirmed'),
(2, 2, 2, '2023-02-15', 1, 2500.00, 'Confirmed'),
(3, 3, 3, '2023-03-01', 4, 6000.00, 'Confirmed'),
(4, 4, 1, '2023-03-10', 2, 2400.00, 'Confirmed'),
(5, 5, 4, '2023-03-20', 3, 5400.00, 'Confirmed'),
(6, 1, 5, '2023-04-01', 2, 2600.00, 'Pending'),
(7, 2, 3, '2023-04-05', 2, 3000.00, 'Confirmed');

-- Queries
-- All trips booked by a customer
SELECT t.destination, t.start_date, t.end_date, b.travelers, b.total_price
FROM Bookings b
JOIN Trips t ON b.trip_id = t.trip_id
WHERE b.customer_id = 1;

-- Trips with no bookings
SELECT t.destination, t.start_date, t.end_date
FROM Trips t
LEFT JOIN Bookings b ON t.trip_id = b.trip_id
WHERE b.booking_id IS NULL;


##Gym Membership Management

-- Create tables
CREATE TABLE Members (
    member_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    join_date DATE,
    dob DATE
);

CREATE TABLE MembershipTypes (
    type_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    duration_months INT,
    price DECIMAL(10,2)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    member_id INT,
    type_id INT,
    payment_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    next_payment_due DATE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    FOREIGN KEY (type_id) REFERENCES MembershipTypes(type_id)
);

-- Insert sample data
INSERT INTO Members VALUES 
(1, 'John Smith', 'john@gym.com', '555-1111', '2022-01-15', '1985-05-20'),
(2, 'Sarah Johnson', 'sarah@gym.com', '555-2222', '2022-03-22', '1990-08-12'),
(3, 'Michael Brown', 'michael@gym.com', '555-3333', '2022-05-10', '1988-03-05'),
(4, 'Emily Davis', 'emily@gym.com', '555-4444', '2022-07-05', '1992-11-18'),
(5, 'David Wilson', 'david@gym.com', '555-5555', '2022-09-30', '1980-07-22');

INSERT INTO MembershipTypes VALUES 
(1, 'Basic Monthly', 1, 30.00),
(2, 'Premium Monthly', 1, 50.00),
(3, 'Annual', 12, 500.00),
(4, 'Student', 1, 25.00);

INSERT INTO Payments VALUES 
(1, 1, 1, '2023-01-01', 30.00, '2023-02-01'),
(2, 1, 1, '2023-02-01', 30.00, '2023-03-01'),
(3, 1, 1, '2023-03-01', 30.00, '2023-04-01'),
(4, 2, 3, '2023-01-15', 500.00, '2024-01-15'),
(5, 3, 2, '2023-02-10', 50.00, '2023-03-10'),
(6, 3, 2, '2023-03-10', 50.00, '2023-04-10'),
(7, 4, 4, '2023-01-20', 25.00, '2023-02-20'),
(8, 4, 4, '2023-02-20', 25.00, '2023-03-20'),
(9, 5, 1, '2023-03-01', 30.00, '2023-04-01');

-- Queries
-- Members with expired memberships
SELECT m.name, m.phone, p.next_payment_due
FROM Members m
JOIN Payments p ON m.member_id = p.member_id
WHERE p.next_payment_due < CURRENT_DATE
AND p.payment_id = (
    SELECT MAX(payment_id)
    FROM Payments
    WHERE member_id = m.member_id
);

-- Members who haven't made a payment in the last month
SELECT m.name, m.email, MAX(p.payment_date) AS last_payment_date
FROM Members m
JOIN Payments p ON m.member_id = p.member_id
GROUP BY m.name, m.email
HAVING MAX(p.payment_date) < DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH);



##E-Commerce Order Tracking

--- Create tables
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    join_date DATE
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATETIME NOT NULL,
    status VARCHAR(20) DEFAULT 'Processing',
    total_amount DECIMAL(10,2),
    shipping_address TEXT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Insert sample data
INSERT INTO Customers VALUES 
(1, 'John Smith', 'john@email.com', '555-1111', '123 Main St, Anytown', '2022-01-15'),
(2, 'Sarah Johnson', 'sarah@email.com', '555-2222', '456 Oak Ave, Somewhere', '2022-03-22'),
(3, 'Michael Brown', 'michael@email.com', '555-3333', '789 Pine Rd, Nowhere', '2022-05-10'),
(4, 'Emily Davis', 'emily@email.com', '555-4444', '321 Elm St, Anywhere', '2022-07-05'),
(5, 'David Wilson', 'david@email.com', '555-5555', '654 Maple Dr, Everywhere', '2022-09-30');

INSERT INTO Products VALUES 
(1, 'Wireless Headphones', 'Noise-cancelling Bluetooth headphones', 199.99, 50),
(2, 'Smart Watch', 'Fitness tracking smartwatch', 129.99, 100),
(3, 'Laptop Backpack', 'Water-resistant backpack for laptops', 59.99, 200),
(4, 'USB-C Cable', '3ft USB-C charging cable', 12.99, 500),
(5, 'Wireless Mouse', 'Ergonomic wireless mouse', 29.99, 150),
(6, 'External SSD', '1TB portable solid state drive', 149.99, 75),
(7, 'Bluetooth Speaker', 'Portable waterproof speaker', 79.99, 120);

INSERT INTO Orders VALUES 
(1, 1, '2023-03-01 10:15:00', 'Shipped', 259.98, '123 Main St, Anytown'),
(2, 2, '2023-03-05 14:30:00', 'Delivered', 89.98, '456 Oak Ave, Somewhere'),
(3, 3, '2023-03-10 09:45:00', 'Processing', 149.99, '789 Pine Rd, Nowhere'),
(4, 4, '2023-03-15 16:20:00', 'Shipped', 239.97, '321 Elm St, Anywhere'),
(5, 5, '2023-03-20 11:10:00', 'Processing', 42.97, '654 Maple Dr, Everywhere'),
(6, 1, '2023-03-25 13:25:00', 'Processing', 149.99, '123 Main St, Anytown');

INSERT INTO OrderItems VALUES 
(1, 1, 1, 1, 199.99),
(2, 1, 4, 1, 12.99),
(3, 1, 5, 1, 29.99),
(4, 2, 3, 1, 59.99),
(5, 2, 7, 1, 29.99),
(6, 3, 6, 1, 149.99),
(7, 4, 2, 1, 129.99),
(8, 4, 7, 1, 79.99),
(9, 4, 5, 1, 29.99),
(10, 5, 4, 2, 12.99),
(11, 5, 5, 1, 29.99),
(12, 6, 6, 1, 149.99);

-- Queries
-- Pending orders
SELECT o.order_id, c.name AS customer_name, o.order_date, o.total_amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE o.status = 'Processing';

-- Order history for a customer
SELECT o.order_id, o.order_date, o.status, o.total_amount
FROM Orders o
WHERE o.customer_id = 1
ORDER BY o.order_date DESC;

-- Products ordered more than 10 times
SELECT p.name, SUM(oi.quantity) AS total_ordered
FROM Products p
JOIN OrderItems oi ON p.product_id = oi.product_id
GROUP BY p.name
HAVING SUM(oi.quantity) > 10;



##Hotel Room Booking System


-- Create tables
CREATE TABLE Rooms (
    room_id INT PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL,
    room_type VARCHAR(50) NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL,
    max_occupancy INT,
    amenities TEXT
);

CREATE TABLE Guests (
    guest_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20) NOT NULL,
    address TEXT
);

CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY,
    room_id INT,
    guest_id INT,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    num_guests INT NOT NULL,
    total_price DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'Confirmed',
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id),
    FOREIGN KEY (guest_id) REFERENCES Guests(guest_id)
);

-- Insert sample data
INSERT INTO Rooms VALUES 
(1, '101', 'Standard', 99.99, 2, 'TV, WiFi, Coffee Maker'),
(2, '102', 'Standard', 99.99, 2, 'TV, WiFi, Coffee Maker'),
(3, '201', 'Deluxe', 149.99, 4, 'TV, WiFi, Mini Fridge, Coffee Maker'),
(4, '202', 'Deluxe', 149.99, 4, 'TV, WiFi, Mini Fridge, Coffee Maker'),
(5, '301', 'Suite', 249.99, 6, 'TV, WiFi, Mini Bar, Coffee Maker, Sofa'),
(6, '302', 'Suite', 249.99, 6, 'TV, WiFi, Mini Bar, Coffee Maker, Sofa');

INSERT INTO Guests VALUES 
(1, 'John Smith', 'john@email.com', '555-1111', '123 Main St'),
(2, 'Sarah Johnson', 'sarah@email.com', '555-2222', '456 Oak Ave'),
(3, 'Michael Brown', 'michael@email.com', '555-3333', '789 Pine Rd'),
(4, 'Emily Davis', 'emily@email.com', '555-4444', '321 Elm St'),
(5, 'David Wilson', 'david@email.com', '555-5555', '654 Maple Dr');

INSERT INTO Bookings VALUES 
(1, 1, 1, '2023-04-15', '2023-04-17', 2, 199.98, 'Confirmed'),
(2, 3, 2, '2023-04-16', '2023-04-20', 3, 599.97, 'Confirmed'),
(3, 5, 3, '2023-04-18', '2023-04-22', 4, 999.96, 'Confirmed'),
(4, 2, 4, '2023-04-20', '2023-04-22', 2, 199.98, 'Confirmed'),
(5, 4, 5, '2023-04-21', '2023-04-25', 3, 599.97, 'Confirmed'),
(6, 1, 2, '2023-05-01', '2023-05-05', 2, 399.96, 'Pending'),
(7, 3, 1, '2023-05-02', '2023-05-06', 4, 599.97, 'Confirmed');

-- Queries
-- Available rooms for a given date range
SELECT r.room_number, r.room_type, r.price_per_night
FROM Rooms r
WHERE r.room_id NOT IN (
    SELECT b.room_id
    FROM Bookings b
    WHERE b.status = 'Confirmed'
    AND (
        (b.check_in_date <= '2023-04-20' AND b.check_out_date > '2023-04-20') OR
        (b.check_in_date < '2023-04-25' AND b.check_out_date >= '2023-04-25') OR
        (b.check_in_date >= '2023-04-20' AND b.check_out_date <= '2023-04-25')
    )
)
AND r.max_occupancy >= 2; -- Assuming 2 guests

-- Guests with more than 3 bookings
SELECT g.name, COUNT(b.booking_id) AS booking_count
FROM Guests g
JOIN Bookings b ON g.guest_id = b.guest_id
GROUP BY g.name
HAVING COUNT(b.booking_id) > 3;


## Inventory Management for a Grocery Store

-- Create tables
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    category VARCHAR(100),
    unit_price DECIMAL(10,2) NOT NULL,
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

CREATE TABLE Stock (
    stock_id INT PRIMARY KEY,
    product_id INT,
    quantity INT NOT NULL,
    last_restocked DATE,
    reorder_level INT,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Insert sample data
INSERT INTO Suppliers VALUES 
(1, 'Fresh Farms', 'Bob Johnson', '555-1234', 'bob@freshfarms.com'),
(2, 'Dairy Delight', 'Alice Smith', '555-5678', 'alice@dairydelight.com'),
(3, 'Bakery Goods', 'Charlie Brown', '555-9012', 'charlie@bakerygoods.com'),
(4, 'Beverage World', 'Diana Miller', '555-3456', 'diana@beverageworld.com'),
(5, 'Snack Suppliers', 'Ethan Wilson', '555-7890', 'ethan@snacksuppliers.com');

INSERT INTO Products VALUES 
(1, 'Apples', 'Fruits', 1.99, 1),
(2, 'Milk', 'Dairy', 3.49, 2),
(3, 'Bread', 'Bakery', 2.99, 3),
(4, 'Orange Juice', 'Beverages', 4.99, 4),
(5, 'Potato Chips', 'Snacks', 2.49, 5),
(6, 'Bananas', 'Fruits', 0.59, 1),
(7, 'Cheese', 'Dairy', 4.99, 2),
(8, 'Cookies', 'Bakery', 3.99, 3),
(9, 'Soda', 'Beverages', 1.99, 4),
(10, 'Crackers', 'Snacks', 2.99, 5);

INSERT INTO Stock VALUES 
(1, 1, 50, '2023-03-15', 20),
(2, 2, 30, '2023-03-20', 15),
(3, 3, 40, '2023-03-18', 10),
(4, 4, 25, '2023-03-22', 5),
(5, 5, 60, '2023-03-10', 30),
(6, 6, 45, '2023-03-16', 25),
(7, 7, 20, '2023-03-21', 10),
(8, 8, 35, '2023-03-19', 15),
(9, 9, 50, '2023-03-17', 20),
(10, 10, 40, '2023-03-14', 25);

-- Queries
-- Low-stock products (below threshold)
SELECT p.name, p.category, s.quantity, s.reorder_level
FROM Products p
JOIN Stock s ON p.product_id = s.product_id
WHERE s.quantity < s.reorder_level;

-- Suppliers providing more than 5 products
SELECT sup.name, COUNT(p.product_id) AS product_count
FROM Suppliers sup
JOIN Products p ON sup.supplier_id = p.supplier_id
GROUP BY sup.name
HAVING COUNT(p.product_id) > 5;



#Vehicle Service Center Database


-- Create tables
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    address TEXT
);

CREATE TABLE Vehicles (
    vehicle_id INT PRIMARY KEY,
    customer_id INT,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INT,
    license_plate VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Services (
    service_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    estimated_duration INT, -- in minutes
    base_price DECIMAL(10,2)
);

CREATE TABLE ServiceRecords (
    record_id INT PRIMARY KEY,
    vehicle_id INT,
    service_id INT,
    service_date DATETIME NOT NULL,
    technician VARCHAR(100),
    actual_duration INT,
    total_cost DECIMAL(10,2),
    notes TEXT,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id),
    FOREIGN KEY (service_id) REFERENCES Services(service_id)
);

-- Insert sample data
INSERT INTO Customers VALUES 
(1, 'John Smith', '555-1111', 'john@email.com', '123 Main St'),
(2, 'Sarah Johnson', '555-2222', 'sarah@email.com', '456 Oak Ave'),
(3, 'Michael Brown', '555-3333', 'michael@email.com', '789 Pine Rd'),
(4, 'Emily Davis', '555-4444', 'emily@email.com', '321 Elm St'),
(5, 'David Wilson', '555-5555', 'david@email.com', '654 Maple Dr');

INSERT INTO Vehicles VALUES 
(1, 1, 'Toyota', 'Camry', 2018, 'ABC123'),
(2, 2, 'Honda', 'Civic', 2020, 'DEF456'),
(3, 3, 'Ford', 'F-150', 2019, 'GHI789'),
(4, 4, 'Chevrolet', 'Malibu', 2021, 'JKL012'),
(5, 5, 'Nissan', 'Altima', 2017, 'MNO345'),
(6, 1, 'BMW', 'X5', 2022, 'PQR678');

INSERT INTO Services VALUES 
(1, 'Oil Change', 'Standard oil and filter change', 30, 49.99),
(2, 'Tire Rotation', 'Rotate all four tires', 20, 29.99),
(3, 'Brake Inspection', 'Inspect brake pads and rotors', 45, 39.99),
(4, 'Battery Replacement', 'Replace vehicle battery', 30, 129.99),
(5, 'Full Synthetic Oil Change', 'Synthetic oil and filter change', 30, 79.99),
(6, 'Air Filter Replacement', 'Replace engine air filter', 15, 24.99);

INSERT INTO ServiceRecords VALUES 
(1, 1, 1, '2023-01-15 09:00:00', 'Mike Johnson', 35, 49.99, 'Customer requested premium oil'),
(2, 2, 2, '2023-01-20 10:30:00', 'Sarah Williams', 25, 29.99, ''),
(3, 3, 3, '2023-02-05 13:00:00', 'Mike Johnson', 50, 39.99, 'Brake pads at 50%'),
(4, 4, 1, '2023-02-10 11:00:00', 'David Brown', 30, 49.99, ''),
(5, 5, 4, '2023-02-15 14:30:00', 'Sarah Williams', 35, 129.99, 'Battery tested weak'),
(6, 1, 5, '2023-03-01 10:00:00', 'Mike Johnson', 30, 79.99, ''),
(7, 2, 6, '2023-03-10 09:30:00', 'David Brown', 20, 24.99, ''),
(8, 6, 1, '2023-03-15 13:00:00', 'Sarah Williams', 30, 49.99, ''),
(9, 3, 2, '2023-03-20 11:30:00', 'Mike Johnson', 25, 29.99, ''),
(10, 4, 3, '2023-03-25 14:00:00', 'David Brown', 45, 39.99, 'Brakes in good condition');

-- Queries
-- Vehicles serviced in the last month
SELECT v.make, v.model, v.license_plate, sr.service_date, s.name AS service_name
FROM ServiceRecords sr
JOIN Vehicles v ON sr.vehicle_id = v.vehicle_id
JOIN Services s ON sr.service_id = s.service_id
WHERE sr.service_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)
ORDER BY sr.service_date DESC;

-- Customers with more than 2 services in a year
SELECT c.name, COUNT(sr.record_id) AS service_count
FROM Customers c
JOIN Vehicles v ON c.customer_id = v.customer_id
JOIN ServiceRecords sr ON v.vehicle_id = sr.vehicle_id
WHERE sr.service_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
GROUP BY c.name
HAVING COUNT(sr.record_id) > 2;



##Bookstore Sales System
-- Create tables
CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100),
    genre VARCHAR(50),
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    join_date DATE
);

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    sale_date DATETIME NOT NULL,
    total_amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE SaleItems (
    sale_item_id INT PRIMARY KEY,
    sale_id INT,
    book_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (sale_id) REFERENCES Sales(sale_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

-- Insert sample data
INSERT INTO Books VALUES 
(1, 'To Kill a Mockingbird', 'Harper Lee', 'Fiction', 12.99, 50),
(2, '1984', 'George Orwell', 'Dystopian', 10.99, 40),
(3, 'The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', 11.99, 35),
(4, 'Pride and Prejudice', 'Jane Austen', 'Romance', 9.99, 45),
(5, 'The Hobbit', 'J.R.R. Tolkien', 'Fantasy', 14.99, 30),
(6, 'The Catcher in the Rye', 'J.D. Salinger', 'Fiction', 10.99, 25),
(7, 'To the Lighthouse', 'Virginia Woolf', 'Modernist', 11.99, 20),
(8, 'Moby-Dick', 'Herman Melville', 'Adventure', 13.99, 15),
(9, 'War and Peace', 'Leo Tolstoy', 'Historical', 15.99, 10),
(10, 'The Odyssey', 'Homer', 'Epic', 9.99, 20);

INSERT INTO Customers VALUES 
(1, 'John Smith', 'john@email.com', '555-1111', '2022-01-15'),
(2, 'Sarah Johnson', 'sarah@email.com', '555-2222', '2022-03-22'),
(3, 'Michael Brown', 'michael@email.com', '555-3333', '2022-05-10'),
(4, 'Emily Davis', 'emily@email.com', '555-4444', '2022-07-05'),
(5, 'David Wilson', 'david@email.com', '555-5555', '2022-09-30');

INSERT INTO Sales VALUES 
(1, 1, '2023-03-01 10:15:00', 25.98, 'Credit Card'),
(2, 2, '2023-03-05 14:30:00', 32.97, 'Cash'),
(3, 3, '2023-03-10 09:45:00', 14.99, 'Debit Card'),
(4, 4, '2023-03-15 16:20:00', 44.97, 'Credit Card'),
(5, 5, '2023-03-20 11:10:00', 21.98, 'Cash'),
(6, 1, '2023-03-25 13:25:00', 30.97, 'Debit Card');

INSERT INTO SaleItems VALUES 
(1, 1, 1, 1, 12.99),
(2, 1, 4, 1, 9.99),
(3, 2, 2, 1, 10.99),
(4, 2, 3, 1, 11.99),
(5, 2, 5, 1, 14.99),
(6, 3, 5, 1, 14.99),
(7, 4, 1, 1, 12.99),
(8, 4, 2, 1, 10.99),
(9, 4, 3, 1, 11.99),
(10, 5, 4, 1, 9.99),
(11, 5, 6, 1, 10.99),
(12, 6, 7, 1, 11.99),
(13, 6, 8, 1, 13.99),
(14, 6, 10, 1, 9.99);

-- Queries
-- Best-selling books
SELECT b.title, b.author, SUM(si.quantity) AS total_sold
FROM Books b
JOIN SaleItems si ON b.book_id = si.book_id
GROUP BY b.title, b.author
ORDER BY total_sold DESC
LIMIT 5;

-- Customers who purchased more than 3 books
SELECT c.name, SUM(si.quantity) AS books_purchased
FROM Customers c
JOIN Sales s ON c.customer_id = s.customer_id
JOIN SaleItems si ON s.sale_id = si.sale_id
GROUP BY c.name
HAVING SUM(si.quantity) > 3;


##University Course Enrollment System


-- Create tables
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    major VARCHAR(100),
    enrollment_year INT
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    code VARCHAR(20) NOT NULL,
    name VARCHAR(100) NOT NULL,
    credits INT,
    department VARCHAR(100)
);

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    semester VARCHAR(20),
    academic_year INT,
    grade VARCHAR(2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Insert sample data
INSERT INTO Students VALUES 
(1, 'Alice Johnson', 'alice@university.edu', 'Computer Science', 2022),
(2, 'Bob Smith', 'bob@university.edu', 'Mathematics', 2021),
(3, 'Charlie Brown', 'charlie@university.edu', 'Physics', 2022),
(4, 'Diana Miller', 'diana@university.edu', 'Biology', 2023),
(5, 'Ethan Wilson', 'ethan@university.edu', 'Chemistry', 2021),
(6, 'Fiona Davis', 'fiona@university.edu', 'English', 2022),
(7, 'George Taylor', 'george@university.edu', 'History', 2023);

INSERT INTO Courses VALUES 
(1, 'CS101', 'Introduction to Programming', 4, 'Computer Science'),
(2, 'MATH201', 'Calculus II', 4, 'Mathematics'),
(3, 'PHYS101', 'General Physics', 4, 'Physics'),
(4, 'BIO101', 'General Biology', 4, 'Biology'),
(5, 'CHEM101', 'General Chemistry', 4, 'Chemistry'),
(6, 'ENG201', 'British Literature', 3, 'English'),
(7, 'HIST101', 'World History', 3, 'History'),
(8, 'CS201', 'Data Structures', 4, 'Computer Science'),
(9, 'MATH301', 'Linear Algebra', 4, 'Mathematics');

INSERT INTO Enrollments VALUES 
(1, 1, 1, 'Fall', 2022, 'A'),
(2, 1, 8, 'Spring', 2023, 'B+'),
(3, 2, 2, 'Fall', 2022, 'A-'),
(4, 2, 9, 'Spring', 2023, 'A'),
(5, 3, 3, 'Fall', 2022, 'B'),
(6, 4, 4, 'Fall', 2023, 'A'),
(7, 5, 5, 'Fall', 2021, 'C+'),
(8, 5, 5, 'Fall', 2022, 'B'),
(9, 6, 6, 'Spring', 2023, 'A-'),
(10, 7, 7, 'Fall', 2023, 'B+'),
(11, 1, 2, 'Spring', 2023, 'A'),
(12, 2, 1, 'Spring', 2023, 'B'),
(13, 3, 2, 'Spring', 2023, 'A-'),
(14, 4, 3, 'Spring', 2023, 'B+'),
(15, 6, 1, 'Fall', 2022, 'A'),
(16, 7, 6, 'Spring', 2023, 'A');

-- Queries
-- Number of students per course
SELECT c.code, c.name, COUNT(e.student_id) AS student_count
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.code, c.name
ORDER BY student_count DESC;

-- Courses with no enrollments
SELECT c.code, c.name
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;

-- Students enrolled in more than 2 courses
SELECT s.name, s.major, COUNT(e.enrollment_id) AS course_count
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
GROUP BY s.name, s.major
HAVING COUNT(e.enrollment_id) > 2;

##Parking Lot Management


-- Create tables
CREATE TABLE Lots (
    lot_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(200),
    capacity INT NOT NULL,
    hourly_rate DECIMAL(10,2)
);

CREATE TABLE Vehicles (
    vehicle_id INT PRIMARY KEY,
    license_plate VARCHAR(20) NOT NULL,
    vehicle_type VARCHAR(50),
    owner_name VARCHAR(100)
);

CREATE TABLE ParkingRecords (
    record_id INT PRIMARY KEY,
    lot_id INT,
    vehicle_id INT,
    entry_time DATETIME NOT NULL,
    exit_time DATETIME,
    amount_charged DECIMAL(10,2),
    payment_status VARCHAR(20) DEFAULT 'Unpaid',
    FOREIGN KEY (lot_id) REFERENCES Lots(lot_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)
);

-- Insert sample data
INSERT INTO Lots VALUES 
(1, 'Main Campus Lot', 'Near University Building', 200, 2.50),
(2, 'Downtown Garage', '123 Main Street', 500, 3.00),
(3, 'Northside Lot', '456 Oak Avenue', 150, 2.00),
(4, 'Airport Parking', 'Near Terminal A', 1000, 5.00),
(5, 'Hospital Garage', '789 Medical Center Drive', 300, 4.00);

INSERT INTO Vehicles VALUES 
(1, 'ABC123', 'Sedan', 'John Smith'),
(2, 'DEF456', 'SUV', 'Sarah Johnson'),
(3, 'GHI789', 'Truck', 'Michael Brown'),
(4, 'JKL012', 'Sedan', 'Emily Davis'),
(5, 'MNO345', 'Motorcycle', 'David Wilson'),
(6, 'PQR678', 'SUV', 'Lisa Taylor'),
(7, 'STU901', 'Sedan', 'James Anderson');

INSERT INTO ParkingRecords VALUES 
(1, 1, 1, '2023-04-01 08:15:00', '2023-04-01 17:30:00', 22.50, 'Paid'),
(2, 2, 2, '2023-04-01 09:30:00', '2023-04-01 14:45:00', 15.00, 'Paid'),
(3, 3, 3, '2023-04-02 10:00:00', '2023-04-02 12:30:00', 5.00, 'Paid'),
(4, 1, 4, '2023-04-03 07:45:00', '2023-04-03 18:15:00', 25.00, 'Paid'),
(5, 4, 5, '2023-04-04 15:30:00', '2023-04-04 18:45:00', 15.00, 'Unpaid'),
(6, 5, 6, '2023-04-05 06:00:00', '2023-04-05 14:00:00', 32.00, 'Paid'),
(7, 2, 7, '2023-04-06 11:15:00', NULL, NULL, 'Unpaid'),
(8, 1, 2, '2023-04-06 08:30:00', '2023-04-06 16:45:00', 20.00, 'Paid'),
(9, 3, 4, '2023-04-07 13:00:00', NULL, NULL, 'Unpaid'),
(10, 4, 1, '2023-04-08 09:45:00', '2023-04-08 12:15:00', 12.50, 'Paid');

-- Queries
-- Currently parked vehicles
SELECT v.license_plate, v.owner_name, l.name AS lot_name, pr.entry_time
FROM ParkingRecords pr
JOIN Vehicles v ON pr.vehicle_id = v.vehicle_id
JOIN Lots l ON pr.lot_id = l.lot_id
WHERE pr.exit_time IS NULL;

-- Lots that are full (assuming we can calculate occupancy)
SELECT l.name, l.capacity, COUNT(pr.record_id) AS current_occupancy
FROM Lots l
LEFT JOIN ParkingRecords pr ON l.lot_id = pr.lot_id AND pr.exit_time IS NULL
GROUP BY l.name, l.capacity
HAVING COUNT(pr.record_id) >= l.capacity;


##Music Streaming Database

-- Create tables
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    join_date DATE,
    subscription_type VARCHAR(50)
);

CREATE TABLE Songs (
    song_id INT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    artist VARCHAR(100) NOT NULL,
    album VARCHAR(200),
    duration INT, -- in seconds
    genre VARCHAR(50),
    release_year INT
);

CREATE TABLE Playlists (
    playlist_id INT PRIMARY KEY,
    user_id INT,
    name VARCHAR(100) NOT NULL,
    created_date DATE,
    description TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE PlaylistSongs (
    playlist_song_id INT PRIMARY KEY,
    playlist_id INT,
    song_id INT,
    added_date DATETIME,
    position INT,
    FOREIGN KEY (playlist_id) REFERENCES Playlists(playlist_id),
    FOREIGN KEY (song_id) REFERENCES Songs(song_id)
);

CREATE TABLE Plays (
    play_id INT PRIMARY KEY,
    user_id INT,
    song_id INT,
    play_date DATETIME NOT NULL,
    device_type VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (song_id) REFERENCES Songs(song_id)
);

-- Insert sample data
INSERT INTO Users VALUES 
(1, 'musiclover', 'music@email.com', '2022-01-15', 'Premium'),
(2, 'songfan', 'song@email.com', '2022-03-22', 'Free'),
(3, 'tunemaster', 'tune@email.com', '2022-05-10', 'Premium'),
(4, 'melodyqueen', 'melody@email.com', '2022-07-05', 'Premium'),
(5, 'beatking', 'beat@email.com', '2022-09-30', 'Free');

INSERT INTO Songs VALUES 
(1, 'Bohemian Rhapsody', 'Queen', 'A Night at the Opera', 354, 'Rock', 1975),
(2, 'Imagine', 'John Lennon', 'Imagine', 183, 'Pop', 1971),
(3, 'Billie Jean', 'Michael Jackson', 'Thriller', 294, 'Pop', 1982),
(4, 'Sweet Child O'' Mine', 'Guns N'' Roses', 'Appetite for Destruction', 356, 'Rock', 1987),
(5, 'Smells Like Teen Spirit', 'Nirvana', 'Nevermind', 301, 'Grunge', 1991),
(6, 'Like a Rolling Stone', 'Bob Dylan', 'Highway 61 Revisited', 369, 'Folk Rock', 1965),
(7, 'Hotel California', 'Eagles', 'Hotel California', 390, 'Rock', 1976),
(8, 'Hey Jude', 'The Beatles', 'Hey Jude', 431, 'Rock', 1968),
(9, 'Rolling in the Deep', 'Adele', '21', 228, 'Pop', 2010),
(10, 'Uptown Funk', 'Mark Ronson ft. Bruno Mars', 'Uptown Special', 270, 'Funk', 2014);

INSERT INTO Playlists VALUES 
(1, 1, 'My Favorites', '2023-01-10', 'All my favorite songs'),
(2, 1, 'Workout Mix', '2023-02-15', 'High energy songs for workouts'),
(3, 2, 'Chill Vibes', '2023-03-01', 'Relaxing music for evenings'),
(4, 3, 'Road Trip', '2023-03-10', 'Great songs for long drives'),
(5, 4, 'Party Time', '2023-03-20', 'Upbeat songs for parties'),
(6, 5, 'Study Focus', '2023-04-01', 'Instrumental music for studying');

INSERT INTO PlaylistSongs VALUES 
(1, 1, 1, '2023-01-10 10:15:00', 1),
(2, 1, 3, '2023-01-10 10:20:00', 2),
(3, 1, 8, '2023-01-12 14:30:00', 3),
(4, 2, 4, '2023-02-15 09:45:00', 1),
(5, 2, 5, '2023-02-15 09:50:00', 2),
(6, 2, 10, '2023-02-16 11:20:00', 3),
(7, 3, 2, '2023-03-01 16:00:00', 1),
(8, 3, 6, '2023-03-02 10:30:00', 2),
(9, 4, 7, '2023-03-10 08:15:00', 1),
(10, 4, 1, '2023-03-10 08:20:00', 2),
(11, 5, 3, '2023-03-20 19:00:00', 1),
(12, 5, 9, '2023-03-20 19:05:00', 2),
(13, 5, 10, '2023-03-21 20:30:00', 3),
(14, 6, 2, '2023-04-01 13:45:00', 1),
(15, 6, 6, '2023-04-02 09:30:00', 2);

INSERT INTO Plays VALUES 
(1, 1, 1, '2023-04-01 08:15:00', 'Mobile'),
(2, 1, 3, '2023-04-01 10:30:00', 'Mobile'),
(3, 2, 2, '2023-04-01 12:45:00', 'Desktop'),
(4, 3, 4, '2023-04-02 09:00:00', 'Mobile'),
(5, 4, 5, '2023-04-02 11:15:00', 'Tablet'),
(6, 5, 6, '2023-04-02 14:30:00', 'Desktop'),
(7, 1, 8, '2023-04-03 16:45:00', 'Mobile'),
(8, 2, 9, '2023-04-03 19:00:00', 'Mobile'),
(9, 3, 10, '2023-04-04 08:15:00', 'Desktop'),
(10, 4, 1, '2023-04-04 10:30:00', 'Mobile'),
(11, 1, 3, '2023-04-05 12:45:00', 'Mobile'),
(12, 1, 3, '2023-04-05 14:00:00', 'Mobile'),
(13, 2, 2, '2023-04-06 09:15:00', 'Desktop'),
(14, 3, 4, '2023-04-06 11:30:00', 'Mobile'),
(15, 4, 5, '2023-04-07 13:45:00', 'Tablet');

-- Queries
-- Most played songs
SELECT s.title, s.artist, COUNT(p.play_id) AS play_count
FROM Songs s
JOIN Plays p ON s.song_id = p.song_id
GROUP BY s.title, s.artist
ORDER BY play_count DESC
LIMIT 5;

-- Users with more than 2 playlists
SELECT u.username, COUNT(p.playlist_id) AS playlist_count
FROM Users u
JOIN Playlists p ON u.user_id = p.user_id
GROUP BY u.username
HAVING COUNT(p.playlist_id) > 2;



##Event Management System


-- Create tables
CREATE TABLE Events (
    event_id INT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    location VARCHAR(200),
    event_date DATE,
    start_time TIME,
    end_time TIME,
    capacity INT,
    organizer VARCHAR(100)
);

CREATE TABLE Attendees (
    attendee_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    organization VARCHAR(100)
);

CREATE TABLE Registrations (
    registration_id INT PRIMARY KEY,
    event_id INT,
    attendee_id INT,
    registration_date DATETIME NOT NULL,
    status VARCHAR(20) DEFAULT 'Confirmed',
    payment_status VARCHAR(20),
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (attendee_id) REFERENCES Attendees(attendee_id)
);

-- Insert sample data
INSERT INTO Events VALUES 
(1, 'Tech Conference 2023', 'Annual technology conference', 'Convention Center', '2023-05-15', '09:00:00', '17:00:00', 500, 'Tech Org'),
(2, 'Marketing Summit', 'Marketing trends and strategies', 'Grand Hotel', '2023-06-10', '08:30:00', '16:00:00', 300, 'Marketing Association'),
(3, 'Startup Workshop', 'Workshop for new entrepreneurs', 'Innovation Hub', '2023-07-05', '10:00:00', '15:00:00', 100, 'Startup Incubator'),
(4, 'Design Expo', 'Showcase of design work', 'Art Gallery', '2023-08-15', '11:00:00', '18:00:00', 200, 'Design Collective'),
(5, 'Health & Wellness Fair', 'Health and wellness products', 'Community Center', '2023-09-01', '09:00:00', '14:00:00', 400, 'Health Foundation');

INSERT INTO Attendees VALUES 
(1, 'John Smith', 'john@company.com', '555-1111', 'ABC Corp'),
(2, 'Sarah Johnson', 'sarah@agency.com', '555-2222', 'XYZ Agency'),
(3, 'Michael Brown', 'michael@startup.com', '555-3333', 'New Ventures'),
(4, 'Emily Davis', 'emily@design.com', '555-4444', 'Creative Designs'),
(5, 'David Wilson', 'david@health.com', '555-5555', 'Wellness Clinic'),
(6, 'Lisa Taylor', 'lisa@tech.com', '555-6666', 'Tech Solutions'),
(7, 'James Anderson', 'james@marketing.com', '555-7777', 'Digital Marketing'),
(8, 'Jennifer Thomas', 'jennifer@business.com', '555-8888', 'Business Growth');

INSERT INTO Registrations VALUES 
(1, 1, 1, '2023-01-10 10:15:00', 'Confirmed', 'Paid'),
(2, 1, 2, '2023-02-15 14:30:00', 'Confirmed', 'Paid'),
(3, 1, 3, '2023-03-01 09:45:00', 'Confirmed', 'Paid'),
(4, 1, 4, '2023-03-10 16:20:00', 'Confirmed', 'Paid'),
(5, 1, 5, '2023-03-20 11:10:00', 'Confirmed', 'Paid'),
(6, 2, 2, '2023-02-01 13:25:00', 'Confirmed', 'Paid'),
(7, 2, 7, '2023-02-05 10:30:00', 'Confirmed', 'Paid'),
(8, 2, 8, '2023-02-10 15:45:00', 'Confirmed', 'Paid'),
(9, 3, 3, '2023-03-15 11:00:00', 'Confirmed', 'Paid'),
(10, 3, 6, '2023-03-20 14:15:00', 'Confirmed', 'Paid'),
(11, 4, 4, '2023-04-01 09:30:00', 'Confirmed', 'Paid'),
(12, 4, 1, '2023-04-05 16:45:00', 'Confirmed', 'Paid'),
(13, 5, 5, '2023-05-10 10:00:00', 'Confirmed', 'Paid'),
(14, 5, 2, '2023-05-15 14:30:00', 'Confirmed', 'Paid'),
(15, 5, 7, '2023-05-20 11:45:00', 'Confirmed', 'Paid');

-- Queries
-- Events with more than 100 attendees
SELECT e.name, e.event_date, COUNT(r.registration_id) AS attendee_count
FROM Events e
JOIN Registrations r ON e.event_id = r.event_id
WHERE r.status = 'Confirmed'
GROUP BY e.name, e.event_date
HAVING COUNT(r.registration_id) > 100
ORDER BY e.event_date;

-- Attendees registered for multiple events
SELECT a.name, a.email, COUNT(r.registration_id) AS event_count
FROM Attendees a
JOIN Registrations r ON a.attendee_id = r.attendee_id
WHERE r.status = 'Confirmed'
GROUP BY a.name, a.email
HAVING COUNT(r.registration_id) > 1
ORDER BY event_count DESC;



## Clinic Appointment Scheduling
-- Create tables
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dob DATE,
    gender VARCHAR(10),
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    address TEXT
);

CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    purpose TEXT,
    status VARCHAR(20) DEFAULT 'Scheduled',
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Insert sample data
INSERT INTO Patients VALUES 
(1, 'John Smith', '1980-05-15', 'Male', '555-1111', 'john@email.com', '123 Main St'),
(2, 'Sarah Johnson', '1975-08-22', 'Female', '555-2222', 'sarah@email.com', '456 Oak Ave'),
(3, 'Michael Brown', '1990-03-10', 'Male', '555-3333', 'michael@email.com', '789 Pine Rd'),
(4, 'Emily Davis', '1988-11-05', 'Female', '555-4444', 'emily@email.com', '321 Elm St'),
(5, 'David Wilson', '1972-07-30', 'Male', '555-5555', 'david@email.com', '654 Maple Dr'),
(6, 'Lisa Taylor', '1985-09-18', 'Female', '555-6666', 'lisa@email.com', '987 Cedar Ln'),
(7, 'James Anderson', '1978-04-25', 'Male', '555-7777', 'james@email.com', '159 Birch St'),
(8, 'Jennifer Thomas', '1992-12-10', 'Female', '555-8888', 'jennifer@email.com', '753 Oak Dr');

INSERT INTO Doctors VALUES 
(1, 'Dr. Robert Miller', 'Cardiology', '555-1234', 'dr.miller@clinic.com'),
(2, 'Dr. Lisa Taylor', 'Pediatrics', '555-5678', 'dr.taylor@clinic.com'),
(3, 'Dr. James Anderson', 'Orthopedics', '555-9012', 'dr.anderson@clinic.com'),
(4, 'Dr. Susan Wilson', 'Dermatology', '555-3456', 'dr.wilson@clinic.com'),
(5, 'Dr. Mark Johnson', 'Neurology', '555-7890', 'dr.johnson@clinic.com');

INSERT INTO Appointments VALUES 
(1, 1, 1, '2023-04-01', '09:00:00', 'Annual checkup', 'Completed'),
(2, 2, 2, '2023-04-01', '10:30:00', 'Child vaccination', 'Completed'),
(3, 3, 3, '2023-04-02', '14:00:00', 'Knee pain consultation', 'Scheduled'),
(4, 4, 1, '2023-04-03', '11:00:00', 'Heart palpitations', 'Scheduled'),
(5, 5, 2, '2023-04-03', '15:30:00', 'New patient consultation', 'Scheduled'),
(6, 6, 3, '2023-04-04', '13:00:00', 'Follow-up on back pain', 'Scheduled'),
(7, 7, 4, '2023-04-05', '09:30:00', 'Skin rash evaluation', 'Scheduled'),
(8, 8, 5, '2023-04-05', '14:30:00', 'Headache consultation', 'Scheduled'),
(9, 1, 1, '2023-04-08', '10:00:00', 'Follow-up on blood pressure', 'Scheduled'),
(10, 2, 2, '2023-04-08', '11:30:00', 'Annual physical', 'Scheduled'),
(11, 3, 3, '2023-04-09', '15:00:00', 'Post-surgery checkup', 'Scheduled'),
(12, 4, 4, '2023-04-10', '10:30:00', 'Mole examination', 'Scheduled'),
(13, 5, 5, '2023-04-10', '14:00:00', 'Neurological evaluation', 'Scheduled'),
(14, 6, 1, '2023-04-11', '09:00:00', 'Cardiac screening', 'Scheduled'),
(15, 7, 2, '2023-04-12', '11:00:00', 'Child wellness check', 'Scheduled');

-- Queries
-- Doctors with most appointments in a week
SELECT d.name, d.specialization, COUNT(a.appointment_id) AS appointment_count
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
WHERE a.appointment_date BETWEEN '2023-04-03' AND '2023-04-09'
GROUP BY d.name, d.specialization
ORDER BY appointment_count DESC
LIMIT 3;

-- Patients with missed appointments (no-shows)
SELECT p.name, p.phone, a.appointment_date, a.appointment_time
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
WHERE a.status = 'No-show'
ORDER BY a.appointment_date DESC;