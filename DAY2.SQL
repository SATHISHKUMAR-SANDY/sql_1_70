-- USE DAY21;

-- CREATE TABLE EMPLOYEES(
-- EMP_ID INT PRIMARY KEY ,
-- EMP_NAME VARCHAR(100),
-- EMP_ROLE VARCHAR(100),
-- EMP_SALARY INT
-- );


-- INSERT INTO EMPLOYEES
-- VALUES
-- (1,'SATHISH','IT',20000),
-- (2,'KUMAR','MARKETING',30000),
-- (3,'SURESH','IT',40000),
-- (4,'RAJESH','MARKETING',50000)
-- SELECT * FROM EMPLOYEES;



## TASK1

-- SELECT COUNT(*) AS COUNT_EMPLOYEES
-- FROM EMPLOYEES



## TASK2

-- SELECT COUNT(*) AS EMPLOYE_COUNT,EMP_ROLE
-- FROM EMPLOYEES
-- group by EMP_ROLE
-- HAVING EMP_ROLE = "IT"




## TASK3

-- SELECT SUM(EMP_SALARY) AS TOTAL_EM_SALRY
-- FROM EMPLOYEES


##TASK4

-- SELECT SUM(EMP_SALARY),EMP_ROLE
-- FROM EMPLOYEES
-- group by EMP_ROLE
-- HAVING EMP_ROLE = 'HR'



##TASK5

-- SELECT AVG(EMP_SALARY)
-- FROM EMPLOYEES



## TASK6

-- SELECT AVG(EMP_SALARY),EMP_ROLE
-- FROM EMPLOYEES
-- GROUP BY EMP_ROLE
-- HAVING EMP_ROLE = 'MARKETING'




#TASK7

-- SELECT MIN(EMP_SALARY)
-- FROM EMPLOYEES




## TASK8

-- SELECT MAX(EMP_SALARY)
-- FROM EMPLOYEES


##TASK9

-- SELECT MIN(JOIN_DATE)
-- FROM employees



## TASK10

-- SELECT MAX(JOIN_DATE)
-- FROM EMPLOYEES

## GROUP BY

## TASK11


-- SELECT SUM(EMP_SALARY),EMP_ROLE
-- FROM EMPLOYEES 
-- GROUP BY EMP_ROLE



#TASK12

-- SELECT AVG(EMP_SALARY),EMP_ROLE
-- FROM EMPLOYEES
-- GROUP BY EMP_ROLE



##TASK13


-- SELECT COUNT(*),EMP_ROLE
-- FROM EMPLOYEES
-- GROUP BY EMP_ROLE



##TASK14

-- SELECT COUNT(*)AS ALL_COUNT,EMP_ROLE
-- FROM EMPLOYEES
-- GROUP BY EMP_ROLE
-- HAVING ALL_COUNT>2



#TASK15

-- SELECT MIN(EMP_SALARY),EMP_ROLE
-- FROM EMPLOYEES
-- GROUP BY EMP_ROLE



#TASK16

-- SELECT MAX(EMP_SALARY),EMP_ROLE
-- FROM EMPLOYEES
-- GROUP BY EMP_ROLE



##TASK17
-- SELECT YEAR(JOIN_DATE),COUNT(*)AS NUM_EMPLOYE
-- FROM EMPLOYEES
-- GROUP BY YEAR(JOIN_DATE)
-- ORDER BY YEAR(JOIN_DATE)



##TASK18

-- SELECT SUM(EMP_SALARY)AS TOTAL_SALARY,EMP_ROLE
-- FROM EMPLOYEES
-- GROUP BY EMP_ROLE
-- HAVING TOTAL_SALARY>100000


## TASK19 
-- SELECT AVG(EMP_SALARY)AS AVG_SALARY,EMP_ROLE AS DP
-- FROM EMPLOYEES
-- GROUP BY DP
-- HAVING AVG_SALARY>60000




#TASK20

-- SELECT YEAR(JOIN_DATE) AS HIRE_YEAR,COUNT(*)
-- FROM EMPLOYEES
-- GROUP BY HIRE_YEAR






#TASK21

-- SELECT department_id
-- FROM employees
-- GROUP BY department_id
-- HAVING SUM(salary) < 120000;



#TASK22

SELECT department_id
FROM employees
GROUP BY department_id
HAVING AVG(salary) < 55000;

##TASK23

SELECT department_id
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 3 AND SUM(salary) > 150000;

##TASK24
SELECT department_id
FROM employees
GROUP BY department_id
HAVING MAX(salary) >= 70000;

##TASK25

SELECT department_id
FROM employees
GROUP BY department_id
HAVING MIN(salary) > 50000;


##TASK26

SELECT MAX(salary)
FROM employees
WHERE join_date > '2020-01-01';

##TASK27

SELECT COUNT(*)
FROM employees
WHERE salary < (SELECT AVG(salary) FROM employees);

##TASK28

SELECT department_id, SUM(salary)
FROM employees
GROUP BY department_id;

##TASK29

SELECT department_id
FROM employees
GROUP BY department_id
ORDER BY COUNT(*) DESC
LIMIT 1;

##TASK30

SELECT department_id
FROM employees
GROUP BY department_id
ORDER BY SUM(salary) ASC
LIMIT 1;

##TASK31

SELECT e.*, d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;

##TASK32

SELECT e.*, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;

##TASK33

SELECT e.*, d.department_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id;

##TASK34

SELECT d.department_name
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
WHERE e.employee_id IS NULL;

##TASK35

SELECT d.department_name, COUNT(e.employee_id)
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;

##TASK36

SELECT e.*, d.department_name, s.amount
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN salaries s ON e.employee_id = s.employee_id
WHERE s.date_paid = (SELECT MAX(date_paid) FROM salaries WHERE employee_id = e.employee_id);

##TASK37

SELECT d.department_name, s.amount
FROM departments d
JOIN employees e ON d.department_id = e.department_id
JOIN salaries s ON e.employee_id = s.employee_id;

##TASK38
SELECT e.*
FROM employees e
LEFT JOIN salaries s ON e.employee_id = s.employee_id
WHERE s.employee_id IS NULL;

##TASK39
SELECT d.department_name, SUM(s.amount)
FROM departments d
JOIN employees e ON d.department_id = e.department_id
JOIN salaries s ON e.employee_id = s.employee_id
GROUP BY d.department_name;


##TASK40

SELECT d.department_name, AVG(s.amount)
FROM departments d
JOIN employees e ON d.department_id = e.department_id
JOIN salaries s ON e.employee_id = s.employee_id
GROUP BY d.department_name;

##TASK41

SELECT e.*, m.name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;

##TASK42

SELECT DISTINCT m.*
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id;

##TASK43
SELECT e1.*, e2.*
FROM employees e1
JOIN employees e2 ON e1.manager_id = e2.manager_id AND e1.employee_id <> e2.employee_id;


##TASK44
SELECT m.name, COUNT(e.employee_id)
FROM employees m
JOIN employees e ON m.employee_id = e.manager_id
GROUP BY m.name;

##TASK45

SELECT e.*
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
JOIN departments d ON m.department_id = d.department_id
WHERE d.department_name = 'IT';

##TASK46

SELECT d.department_name, MAX(e.salary)
FROM departments d
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;

##TASK47
SELECT e.*
FROM employees e
JOIN (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) dept ON e.department_id = dept.department_id
WHERE e.salary > dept.avg_salary;
##TASK48

SELECT d.department_name, SUM(e.salary)
FROM departments d
JOIN employees e ON d.department_id = e.department_id
WHERE e.join_date < '2020-01-01'
GROUP BY d.department_name;

##TASK49
SELECT d.department_name
FROM departments d
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING MIN(e.salary) > 50000;


##TASK50
SELECT m.name
FROM employees m
JOIN employees e ON m.employee_id = e.manager_id
GROUP BY m.name
ORDER BY COUNT(*) DESC
LIMIT 1;


#1. Company Payroll Analytics

-- Total, average, min, and max salaries by department
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS employee_count,
    SUM(e.salary) AS total_salary,
    AVG(e.salary) AS avg_salary,
    MIN(e.salary) AS min_salary,
    MAX(e.salary) AS max_salary
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;

-- Departments with total salary above $200,000
SELECT 
    d.department_name,
    SUM(e.salary) AS total_salary
FROM departments d
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING SUM(e.salary) > 200000;

-- Top 3 highest paid employees
SELECT 
    name,
    salary,
    department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
ORDER BY salary DESC
LIMIT 3;


##School Performance Dashboard


-- Average grade per student
SELECT 
    s.student_name,
    AVG(g.grade) AS average_grade
FROM students s
JOIN grades g ON s.student_id = g.student_id
GROUP BY s.student_name;

-- Average grade per class
SELECT 
    c.class_name,
    AVG(g.grade) AS average_grade
FROM classes c
JOIN grades g ON c.class_id = g.class_id
GROUP BY c.class_name;

-- Classes where average grade is below 70
SELECT 
    c.class_name,
    AVG(g.grade) AS average_grade
FROM classes c
JOIN grades g ON c.class_id = g.class_id
GROUP BY c.class_name
HAVING AVG(g.grade) < 70;

-- Students with highest and lowest grades
(SELECT 'Highest' AS type, s.student_name, g.grade, c.class_name
 FROM students s
 JOIN grades g ON s.student_id = g.student_id
 JOIN classes c ON g.class_id = c.class_id
 ORDER BY g.grade DESC LIMIT 1)
UNION
(SELECT 'Lowest' AS type, s.student_name, g.grade, c.class_name
 FROM students s
 JOIN grades g ON s.student_id = g.student_id
 JOIN classes c ON g.class_id = c.class_id
 ORDER BY g.grade ASC LIMIT 1);
 
 
 #3. E-Commerce Sales Summary
 
 
 -- Total sales per product
SELECT 
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC;

-- Total sales per customer
SELECT 
    c.customer_name,
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;

-- Products with sales above $10,000
SELECT 
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name
HAVING SUM(oi.quantity * oi.unit_price) > 10000;

-- Customers with no orders
SELECT 
    c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


## Hospital Department Metrics


-- Patients per department
SELECT 
    d.department_name,
    COUNT(DISTINCT a.patient_id) AS patient_count
FROM departments d
LEFT JOIN doctors doc ON d.department_id = doc.department_id
LEFT JOIN appointments a ON doc.doctor_id = a.doctor_id
GROUP BY d.department_name;

-- Patients per doctor
SELECT 
    doc.doctor_name,
    COUNT(DISTINCT a.patient_id) AS patient_count
FROM doctors doc
LEFT JOIN appointments a ON doc.doctor_id = a.doctor_id
GROUP BY doc.doctor_name;

-- Doctors with most appointments
SELECT 
    doc.doctor_name,
    COUNT(a.appointment_id) AS appointment_count
FROM doctors doc
JOIN appointments a ON doc.doctor_id = a.doctor_id
GROUP BY doc.doctor_name
ORDER BY appointment_count DESC
LIMIT 5;

-- Departments with patient count > 100
SELECT 
    d.department_name,
    COUNT(DISTINCT a.patient_id) AS patient_count
FROM departments d
JOIN doctors doc ON d.department_id = doc.department_id
JOIN appointments a ON doc.doctor_id = a.doctor_id
GROUP BY d.department_name
HAVING COUNT(DISTINCT a.patient_id) > 100;


## Library Borrowing Trends
 
 -- Total loans per book
SELECT 
    b.book_title,
    COUNT(l.loan_id) AS loan_count
FROM books b
LEFT JOIN loans l ON b.book_id = l.book_id
GROUP BY b.book_title
ORDER BY loan_count DESC;

-- Total loans per member
SELECT 
    m.member_name,
    COUNT(l.loan_id) AS loan_count
FROM members m
LEFT JOIN loans l ON m.member_id = l.member_id
GROUP BY m.member_name
ORDER BY loan_count DESC;

-- Books borrowed more than 10 times
SELECT 
    b.book_title,
    COUNT(l.loan_id) AS loan_count
FROM books b
JOIN loans l ON b.book_id = l.book_id
GROUP BY b.book_title
HAVING COUNT(l.loan_id) > 10;

-- Members who never borrowed a book
SELECT 
    m.member_name
FROM members m
LEFT JOIN loans l ON m.member_id = l.member_id
WHERE l.loan_id IS NULL;
 


#Restaurant Order Analysis

-- Total revenue per menu item
SELECT 
    m.item_name,
    SUM(od.quantity * m.price) AS total_revenue
FROM menu_items m
JOIN order_details od ON m.item_id = od.item_id
GROUP BY m.item_name
ORDER BY total_revenue DESC;

-- Customers with highest order totals
SELECT 
    c.customer_name,
    SUM(od.quantity * m.price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN menu_items m ON od.item_id = m.item_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 5;

-- Menu items never ordered
SELECT 
    m.item_name
FROM menu_items m
LEFT JOIN order_details od ON m.item_id = od.item_id
WHERE od.order_id IS NULL;


##University Course Statistics

-- Number of students per course
SELECT 
    c.course_name,
    COUNT(e.student_id) AS student_count
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY student_count DESC;

-- Courses with no enrollments
SELECT 
    c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;

-- Courses where all students passed (grade >= 60)
SELECT 
    c.course_name
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
HAVING MIN(e.grade) >= 60;



# Retail Inventory & Supplier Summary


-- Total stock purchased per supplier
SELECT 
    s.supplier_name,
    SUM(p.stock_quantity) AS total_stock
FROM suppliers s
JOIN products p ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_name
ORDER BY total_stock DESC;

-- Products never purchased
SELECT 
    p.product_name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;

-- Supplier with largest product portfolio
SELECT 
    s.supplier_name,
    COUNT(p.product_id) AS product_count
FROM suppliers s
JOIN products p ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_name
ORDER BY product_count DESC
LIMIT 1;



##Fitness Club Member Engagement

-- Class attendance per member
SELECT 
    m.member_name,
    COUNT(a.class_id) AS classes_attended
FROM members m
LEFT JOIN attendance a ON m.member_id = a.member_id
GROUP BY m.member_name
ORDER BY classes_attended DESC;

-- Members with no attendance
SELECT 
    m.member_name
FROM members m
LEFT JOIN attendance a ON m.member_id = a.member_id
WHERE a.attendance_id IS NULL;

-- Classes with highest average attendance
SELECT 
    c.class_name,
    AVG(a.attendance_count) AS avg_attendance
FROM classes c
JOIN (
    SELECT class_id, COUNT(member_id) AS attendance_count
    FROM attendance
    GROUP BY class_id, class_date
) a ON c.class_id = a.class_id
GROUP BY c.class_name
ORDER BY avg_attendance DESC
LIMIT 5;


#Event Registration Reporting
-- Registrations per event
SELECT 
    e.event_name,
    COUNT(r.attendee_id) AS registration_count
FROM events e
LEFT JOIN registrations r ON e.event_id = r.event_id
GROUP BY e.event_name
ORDER BY registration_count DESC;

-- Attendees who registered for most events
SELECT 
    a.attendee_name,
    COUNT(r.event_id) AS events_registered
FROM attendees a
JOIN registrations r ON a.attendee_id = r.attendee_id
GROUP BY a.attendee_name
ORDER BY events_registered DESC
LIMIT 5;

-- Events with no registrations
SELECT 
    e.event_name
FROM events e
LEFT JOIN registrations r ON e.event_id = r.event_id
WHERE r.registration_id IS NULL;


#IT Asset Management

-- Assets assigned per department
SELECT 
    d.department_name,
    COUNT(a.asset_id) AS asset_count
FROM departments d
LEFT JOIN assets a ON d.department_id = a.department_id
GROUP BY d.department_name
ORDER BY asset_count DESC;

-- Employees with more than 2 assets
SELECT 
    e.employee_name,
    COUNT(a.asset_id) AS asset_count
FROM employees e
JOIN assets a ON e.employee_id = a.assigned_to
GROUP BY e.employee_name
HAVING COUNT(a.asset_id) > 2;

-- Departments with no assigned assets
SELECT 
    d.department_name
FROM departments d
LEFT JOIN assets a ON d.department_id = a.department_id
WHERE a.asset_id IS NULL;


##Movie Rental Store Insights

-- Most rented movies
SELECT 
    m.title,
    COUNT(r.rental_id) AS rental_count
FROM movies m
JOIN rentals r ON m.movie_id = r.movie_id
GROUP BY m.title
ORDER BY rental_count DESC
LIMIT 5;

-- Least rented movies
SELECT 
    m.title,
    COUNT(r.rental_id) AS rental_count
FROM movies m
LEFT JOIN rentals r ON m.movie_id = r.movie_id
GROUP BY m.title
ORDER BY rental_count ASC
LIMIT 5;

-- Customers with overdue rentals
SELECT 
    c.customer_name,
    m.title,
    r.due_date
FROM customers c
JOIN rentals r ON c.customer_id = r.customer_id
JOIN movies m ON r.movie_id = m.movie_id
WHERE r.return_date IS NULL AND r.due_date < CURRENT_DATE;

-- Movies never rented
SELECT 
    m.title
FROM movies m
LEFT JOIN rentals r ON m.movie_id = r.movie_id
WHERE r.rental_id IS NULL;


#Bank Branch & Customer Statistics

-- Accounts and total balance per branch
SELECT 
    b.branch_name,
    COUNT(a.account_id) AS account_count,
    SUM(a.balance) AS total_balance
FROM branches b
LEFT JOIN accounts a ON b.branch_id = a.branch_id
GROUP BY b.branch_name
ORDER BY total_balance DESC;

-- Customers with no transactions
SELECT 
    c.customer_name
FROM customers c
LEFT JOIN accounts a ON c.customer_id = a.customer_id
LEFT JOIN transactions t ON a.account_id = t.account_id
WHERE t.transaction_id IS NULL;

-- Branches with highest/lowest number of customers
(SELECT 'Highest' AS type, b.branch_name, COUNT(DISTINCT a.customer_id) AS customer_count
 FROM branches b
 JOIN accounts a ON b.branch_id = a.branch_id
 GROUP BY b.branch_name
 ORDER BY customer_count DESC LIMIT 1)
UNION
(SELECT 'Lowest' AS type, b.branch_name, COUNT(DISTINCT a.customer_id) AS customer_count
 FROM branches b
 JOIN accounts a ON b.branch_id = a.branch_id
 GROUP BY b.branch_name
 ORDER BY customer_count ASC LIMIT 1);
 
 
 
 #Clinic Patient Visit Analysis
 
 
 -- Visits per doctor
SELECT 
    d.doctor_name,
    COUNT(v.visit_id) AS visit_count
FROM doctors d
LEFT JOIN visits v ON d.doctor_id = v.doctor_id
GROUP BY d.doctor_name
ORDER BY visit_count DESC;

-- Visits per patient
SELECT 
    p.patient_name,
    COUNT(v.visit_id) AS visit_count
FROM patients p
LEFT JOIN visits v ON p.patient_id = v.patient_id
GROUP BY p.patient_name
ORDER BY visit_count DESC;

-- Patients with only one visit
SELECT 
    p.patient_name
FROM patients p
JOIN visits v ON p.patient_id = v.patient_id
GROUP BY p.patient_name
HAVING COUNT(v.visit_id) = 1;

-- Doctors with no patient visits
SELECT 
    d.doctor_name
FROM doctors d
LEFT JOIN visits v ON d.doctor_id = v.doctor_id
WHERE v.visit_id IS NULL;


# Hotel Booking Dashboard

-- Occupancy rates per room type
SELECT 
    r.room_type,
    COUNT(b.booking_id) AS bookings,
    COUNT(b.booking_id) * 100.0 / (SELECT COUNT(*) FROM bookings) AS occupancy_rate
FROM rooms r
LEFT JOIN bookings b ON r.room_id = b.room_id
GROUP BY r.room_type
ORDER BY occupancy_rate DESC;

-- Guests with multiple bookings
SELECT 
    g.guest_name,
    COUNT(b.booking_id) AS booking_count
FROM guests g
JOIN bookings b ON g.guest_id = b.guest_id
GROUP BY g.guest_name
HAVING COUNT(b.booking_id) > 1
ORDER BY booking_count DESC;

-- Rooms never booked
SELECT 
    r.room_number,
    r.room_type
FROM rooms r
LEFT JOIN bookings b ON r.room_id = b.room_id
WHERE b.booking_id IS NULL;



##Online Learning Platform Statistics
-- Course completions per user
SELECT 
    u.user_name,
    COUNT(c.completion_id) AS completed_courses
FROM users u
LEFT JOIN completions c ON u.user_id = c.user_id
GROUP BY u.user_name
ORDER BY completed_courses DESC;

-- Courses with less than 5 completions
SELECT 
    co.course_name,
    COUNT(c.completion_id) AS completion_count
FROM courses co
LEFT JOIN completions c ON co.course_id = c.course_id
GROUP BY co.course_name
HAVING COUNT(c.completion_id) < 5;

-- Users enrolled but never completed any course
SELECT 
    u.user_name
FROM users u
JOIN enrollments e ON u.user_id = e.user_id
LEFT JOIN completions c ON u.user_id = c.user_id AND e.course_id = c.course_id
WHERE c.completion_id IS NULL
GROUP BY u.user_name;


##Municipal Service Requests
 -- Requests per citizen
SELECT 
    c.citizen_name,
    COUNT(r.request_id) AS request_count
FROM citizens c
LEFT JOIN requests r ON c.citizen_id = r.citizen_id
GROUP BY c.citizen_name
ORDER BY request_count DESC;

-- Requests per department
SELECT 
    d.department_name,
    COUNT(r.request_id) AS request_count
FROM departments d
LEFT JOIN requests r ON d.department_id = r.department_id
GROUP BY d.department_name
ORDER BY request_count DESC;

-- Departments with no requests
SELECT 
    d.department_name
FROM departments d
LEFT JOIN requests r ON d.department_id = r.department_id
WHERE r.request_id IS NULL;

-- Citizens with highest number of requests
SELECT 
    c.citizen_name,
    COUNT(r.request_id) AS request_count
FROM citizens c
JOIN requests r ON c.citizen_id = r.citizen_id
GROUP BY c.citizen_name
ORDER BY request_count DESC
LIMIT 5;


##Warehouse Order Fulfillment

-- Orders handled per employee
SELECT 
    e.employee_name,
    COUNT(o.order_id) AS order_count
FROM employees e
LEFT JOIN orders o ON e.employee_id = o.handled_by
GROUP BY e.employee_name
ORDER BY order_count DESC;

-- Products frequently out of stock
SELECT 
    p.product_name,
    COUNT(s.stock_date) AS out_of_stock_count
FROM products p
JOIN stock_levels s ON p.product_id = s.product_id
WHERE s.quantity = 0
GROUP BY p.product_name
ORDER BY out_of_stock_count DESC
LIMIT 5;

-- Employees with top fulfillment rates
SELECT 
    e.employee_name,
    COUNT(o.order_id) AS total_orders,
    SUM(CASE WHEN o.status = 'Completed' THEN 1 ELSE 0 END) AS completed_orders,
    (SUM(CASE WHEN o.status = 'Completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(o.order_id)) AS fulfillment_rate
FROM employees e
JOIN orders o ON e.employee_id = o.handled_by
GROUP BY e.employee_name
HAVING COUNT(o.order_id) > 0
ORDER BY fulfillment_rate DESC
LIMIT 5;



#Sales Team Performance Tracking

-- Total sales per region
SELECT 
    r.region_name,
    SUM(s.amount) AS total_sales
FROM regions r
LEFT JOIN salespeople sp ON r.region_id = sp.region_id
LEFT JOIN sales s ON sp.salesperson_id = s.salesperson_id
GROUP BY r.region_name
ORDER BY total_sales DESC;

-- Total sales per salesperson
SELECT 
    sp.salesperson_name,
    SUM(s.amount) AS total_sales
FROM salespeople sp
LEFT JOIN sales s ON sp.salesperson_id = s.salesperson_id
GROUP BY sp.salesperson_name
ORDER BY total_sales DESC;

-- Salespeople with no sales in a region
SELECT 
    sp.salesperson_name,
    r.region_name
FROM salespeople sp
JOIN regions r ON sp.region_id = r.region_id
LEFT JOIN sales s ON sp.salesperson_id = s.salesperson_id
WHERE s.sale_id IS NULL;

-- Regions with highest sales growth (current year vs previous year)
WITH current_year AS (
    SELECT 
        r.region_id,
        r.region_name,
        SUM(s.amount) AS current_sales
    FROM regions r
    JOIN salespeople sp ON r.region_id = sp.region_id
    JOIN sales s ON sp.salesperson_id = s.salesperson_id
    WHERE EXTRACT(YEAR FROM s.sale_date) = EXTRACT(YEAR FROM CURRENT_DATE)
    GROUP BY r.region_id, r.region_name
),
previous_year AS (
    SELECT 
        r.region_id,
        SUM(s.amount) AS previous_sales
    FROM regions r
    JOIN salespeople sp ON r.region_id = sp.region_id
    JOIN sales s ON sp.salesperson_id = s.salesperson_id
    WHERE EXTRACT(YEAR FROM s.sale_date) = EXTRACT(YEAR FROM CURRENT_DATE) - 1
    GROUP BY r.region_id
)
SELECT 
    cy.region_name,
    cy.current_sales,
    py.previous_sales,
    ((cy.current_sales - py.previous_sales) * 100.0 / NULLIF(py.previous_sales, 0)) AS growth_percentage
FROM current_year cy
LEFT JOIN previous_year py ON cy.region_id = py.region_id
ORDER BY growth_percentage DESC
LIMIT 3;


##Friend Referral Program


-- Number of referrals per user
SELECT 
    u.user_name,
    COUNT(r.referred_user_id) AS referral_count
FROM users u
LEFT JOIN referrals r ON u.user_id = r.user_id
GROUP BY u.user_name
ORDER BY referral_count DESC;

-- Users who referred others but made no purchases
SELECT 
    u.user_name,
    COUNT(r.referred_user_id) AS referral_count
FROM users u
JOIN referrals r ON u.user_id = r.user_id
LEFT JOIN purchases p ON u.user_id = p.user_id
WHERE p.purchase_id IS NULL
GROUP BY u.user_name
ORDER BY referral_count DESC;

-- Users with most referred purchases
SELECT 
    u.user_name,
    COUNT(DISTINCT r.referred_user_id) AS referred_users,
    COUNT(p.purchase_id) AS referred_purchases,
    SUM(p.amount) AS referred_revenue
FROM users u
JOIN referrals r ON u.user_id = r.user_id
JOIN purchases p ON r.referred_user_id = p.user_id
GROUP BY u.user_name
ORDER BY referred_revenue DESC
LIMIT 5;
 
 
 
 
 

