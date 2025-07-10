/* TASK 1: Create a view ActiveEmployees that shows employees with status = 'Active' */
CREATE VIEW ActiveEmployees AS SELECT * FROM Employees WHERE status = 'Active';

/* TASK 2: Create a view HighSalaryEmployees to display employees earning more than ₹50,000 */
CREATE VIEW HighSalaryEmployees AS SELECT * FROM Employees WHERE salary > 50000;

/* TASK 3: Create a view that joins Employees and Departments showing emp_name, dept_name */
CREATE VIEW EmployeeDepartmentView AS 
SELECT e.emp_name, d.dept_name FROM Employees e JOIN Departments d ON e.dept_id = d.dept_id;

/* TASK 4: Update the HighSalaryEmployees view to also include the department column */
CREATE OR REPLACE VIEW HighSalaryEmployees AS 
SELECT e.*, d.dept_name FROM Employees e JOIN Departments d ON e.dept_id = d.dept_id WHERE e.salary > 50000;

/* TASK 5: Create a view to show only emp_id, emp_name, and hide the salary */
CREATE VIEW PublicEmployeeView AS SELECT emp_id, emp_name FROM Employees;

/* TASK 6: Create a view ITEmployees showing only employees from the 'IT' department */
CREATE VIEW ITEmployees AS 
SELECT e.* FROM Employees e JOIN Departments d ON e.dept_id = d.dept_id WHERE d.dept_name = 'IT';

/* TASK 7: Drop the view ITEmployees */
DROP VIEW ITEmployees;

/* TASK 8: Create a view for customers who joined in the last 6 months */
CREATE VIEW RecentCustomers AS 
SELECT * FROM Customers WHERE join_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH);

/* TASK 9: Create a view with aliases for employee and department names */
CREATE VIEW EmployeeDeptAliasView AS 
SELECT e.emp_name AS EmployeeName, d.dept_name AS Dept 
FROM Employees e JOIN Departments d ON e.dept_id = d.dept_id;

/* TASK 10: Create a view that filters out employees with NULL email addresses */
CREATE VIEW EmployeesWithEmail AS SELECT * FROM Employees WHERE email IS NOT NULL;

/* TASK 11: Create a view showing employees hired in the last year */
CREATE VIEW RecentHires AS 
SELECT * FROM Employees WHERE hire_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR);

/* TASK 12: Create a view with computed bonus column */
CREATE VIEW EmployeeWithBonus AS SELECT *, salary * 0.10 AS bonus FROM Employees;

/* TASK 13: Create a view joining Orders, Customers, and Products */
CREATE VIEW OrderDetails AS
SELECT o.order_id, c.customer_name, p.product_name, o.order_date, o.quantity
FROM Orders o 
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Products p ON o.product_id = p.product_id;

/* TASK 14: Create a view with total salary by department */
CREATE VIEW DepartmentSalarySummary AS
SELECT d.dept_name, SUM(e.salary) AS total_salary, AVG(e.salary) AS avg_salary
FROM Employees e JOIN Departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name;

/* TASK 15: Create a read-only view for junior staff */
CREATE VIEW JuniorStaffView AS
SELECT emp_id, emp_name, dept_id, position, hire_date, work_email 
FROM Employees WHERE position LIKE '%Junior%';

/* TASK 16: Create stored procedure GetAllEmployees */
DELIMITER //
CREATE PROCEDURE GetAllEmployees()
BEGIN
    SELECT * FROM Employees;
END //
DELIMITER ;

/* TASK 17: Call GetAllEmployees() */
CALL GetAllEmployees();

/* TASK 18: Create stored procedure GetEmployeesByDept */
DELIMITER //
CREATE PROCEDURE GetEmployeesByDept(IN dept_name VARCHAR(50))
BEGIN
    SELECT e.* FROM Employees e 
    JOIN Departments d ON e.dept_id = d.dept_id
    WHERE d.dept_name = dept_name;
END //
DELIMITER ;

/* TASK 19: Call GetEmployeesByDept('HR') */
CALL GetEmployeesByDept('HR');

/* TASK 20: Create procedure to insert new employee */
DELIMITER //
CREATE PROCEDURE AddEmployee(
    IN p_emp_name VARCHAR(100),
    IN p_dept_id INT,
    IN p_salary DECIMAL(10,2),
    IN p_email VARCHAR(100)
)
BEGIN
    INSERT INTO Employees (emp_name, dept_id, salary, email, hire_date, status)
    VALUES (p_emp_name, p_dept_id, p_salary, p_email, CURDATE(), 'Active');
END //
DELIMITER ;

/* TASK 21: Create procedure to delete employee by ID */
DELIMITER //
CREATE PROCEDURE DeleteEmployee(IN p_emp_id INT)
BEGIN
    DELETE FROM Employees WHERE emp_id = p_emp_id;
END //
DELIMITER ;

/* TASK 22: Create procedure to update salary */
DELIMITER //
CREATE PROCEDURE UpdateEmployeeSalary(
    IN p_emp_id INT,
    IN p_new_salary DECIMAL(10,2)
)
BEGIN
    UPDATE Employees SET salary = p_new_salary WHERE emp_id = p_emp_id;
END //
DELIMITER ;

/* TASK 23: Create procedure with OUT parameter for employee count */
DELIMITER //
CREATE PROCEDURE GetTotalEmployees(OUT total INT)
BEGIN
    SELECT COUNT(*) INTO total FROM Employees;
END //
DELIMITER ;

/* TASK 24: Modify procedure with DROP and recreate */
DROP PROCEDURE IF EXISTS GetTotalEmployees;

DELIMITER //
CREATE PROCEDURE GetTotalEmployees(OUT total INT, OUT active INT)
BEGIN
    SELECT COUNT(*) INTO total FROM Employees;
    SELECT COUNT(*) INTO active FROM Employees WHERE status = 'Active';
END //
DELIMITER ;

/* TASK 25: Procedure for employees by name starting letter */
DELIMITER //
CREATE PROCEDURE GetEmployeesByNameLetter(IN letter CHAR(1))
BEGIN
    SELECT * FROM Employees WHERE emp_name LIKE CONCAT(letter, '%');
END //
DELIMITER ;

/* TASK 26: Procedure for average salary by department */
DELIMITER //
CREATE PROCEDURE GetAvgSalaryByDept()
BEGIN
    SELECT d.dept_name, AVG(e.salary) AS avg_salary
    FROM Employees e JOIN Departments d ON e.dept_id = d.dept_id
    GROUP BY d.dept_name;
END //
DELIMITER ;

/* TASK 27: Procedure for employee count by department */
DELIMITER //
CREATE PROCEDURE GetEmployeeCountByDept()
BEGIN
    SELECT d.dept_name, COUNT(e.emp_id) AS employee_count
    FROM Departments d LEFT JOIN Employees e ON d.dept_id = e.dept_id
    GROUP BY d.dept_name;
END //
DELIMITER ;

/* TASK 28: Procedure for employees hired this month */
DELIMITER //
CREATE PROCEDURE GetEmployeesJoinedThisMonth()
BEGIN
    SELECT * FROM Employees 
    WHERE MONTH(hire_date) = MONTH(CURRENT_DATE()) 
    AND YEAR(hire_date) = YEAR(CURRENT_DATE());
END //
DELIMITER ;

/* TASK 29: Procedure with multiple queries */
DELIMITER //
CREATE PROCEDURE ProcessEmployeeReport()
BEGIN
    SELECT COUNT(*) AS total_employees FROM Employees;
    INSERT INTO ActivityLog (action, action_time, details)
    VALUES ('Employee Report Generated', NOW(), 'Report showing employee count');
END //
DELIMITER ;

/* TASK 30: Procedure with transaction handling */
DELIMITER //
CREATE PROCEDURE SafeEmployeeUpdate(
    IN p_emp_id INT,
    IN p_new_salary DECIMAL(10,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error occurred - transaction rolled back' AS message;
    END;
    
    START TRANSACTION;
    UPDATE Employees SET salary = p_new_salary WHERE emp_id = p_emp_id;
    INSERT INTO SalaryAudit (emp_id, old_salary, new_salary, change_date)
    VALUES (p_emp_id, (SELECT salary FROM Employees WHERE emp_id = p_emp_id), p_new_salary, NOW());
    COMMIT;
    
    SELECT 'Salary updated successfully' AS message;
END //
DELIMITER ;

/* TASK 31: Function to count employees by department */
DELIMITER //
CREATE FUNCTION EmployeeCount(dept_name VARCHAR(50)) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE count INT;
    SELECT COUNT(*) INTO count 
    FROM Employees e JOIN Departments d ON e.dept_id = d.dept_id
    WHERE d.dept_name = dept_name;
    RETURN count;
END //
DELIMITER ;

/* TASK 32: Call EmployeeCount function */
SELECT EmployeeCount('Finance');

/* TASK 33: Function for average department salary */
DELIMITER //
CREATE FUNCTION AvgSalaryByDept(dept_name VARCHAR(50)) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE avg_salary DECIMAL(10,2);
    SELECT AVG(salary) INTO avg_salary
    FROM Employees e JOIN Departments d ON e.dept_id = d.dept_id
    WHERE d.dept_name = dept_name;
    RETURN avg_salary;
END //
DELIMITER ;

/* TASK 34: Function to calculate age from DOB */
DELIMITER //
CREATE FUNCTION CalculateAge(dob DATE) RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, dob, CURDATE());
END //
DELIMITER ;

/* TASK 35: Function for highest salary */
DELIMITER //
CREATE FUNCTION GetMaxSalary() RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE max_salary DECIMAL(10,2);
    SELECT MAX(salary) INTO max_salary FROM Employees;
    RETURN max_salary;
END //
DELIMITER ;

/* TASK 36: Function for formatted full name */
DELIMITER //
CREATE FUNCTION FullName(first_name VARCHAR(50), last_name VARCHAR(50)) RETURNS VARCHAR(101)
DETERMINISTIC
BEGIN
    RETURN CONCAT(first_name, ' ', last_name);
END //
DELIMITER ;

/* TASK 37: Function to check department exists */
DELIMITER //
CREATE FUNCTION DepartmentExists(dept_name VARCHAR(50)) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE exists_flag BOOLEAN;
    SELECT COUNT(*) > 0 INTO exists_flag FROM Departments WHERE dept_name = dept_name;
    RETURN exists_flag;
END //
DELIMITER ;

/* TASK 38: Function for working days since joining */
DELIMITER //
CREATE FUNCTION WorkingDaysSinceJoining(join_date DATE) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE days INT;
    SELECT COUNT(*) INTO days
    FROM (
        SELECT join_date + INTERVAL n DAY AS date
        FROM (
            SELECT a.N + b.N * 10 + c.N * 100 AS n
            FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a
            CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
            CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) c
        ) numbers
        WHERE join_date + INTERVAL n DAY <= CURDATE()
        AND DAYOFWEEK(join_date + INTERVAL n DAY) NOT IN (1,7)
    ) working_dates;
    RETURN days;
END //
DELIMITER ;

/* TASK 39: Function for customer order count */
DELIMITER //
CREATE FUNCTION TotalCustomerOrders(customer_id INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE order_count INT;
    SELECT COUNT(*) INTO order_count FROM Orders WHERE customer_id = customer_id;
    RETURN order_count;
END //
DELIMITER ;

/* TASK 40: Function to check bonus eligibility */
DELIMITER //
CREATE FUNCTION IsEligibleForBonus(salary DECIMAL(10,2)) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    RETURN salary > 60000;
END //
DELIMITER ;

/* TASK 41: Create Employee_Audit table */
CREATE TABLE Employee_Audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    action VARCHAR(20),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details TEXT
);

/* TASK 42: AFTER INSERT trigger for employee logging */
DELIMITER //
CREATE TRIGGER after_employee_insert
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
    INSERT INTO Employee_Audit (emp_id, action, details)
    VALUES (NEW.emp_id, 'INSERT', CONCAT('New employee: ', NEW.emp_name));
END //
DELIMITER ;

/* TASK 43: Insert employee and verify audit */
INSERT INTO Employees (emp_name, dept_id, salary, email, hire_date, status)
VALUES ('John Doe', 1, 50000, 'john.doe@example.com', CURDATE(), 'Active');

SELECT * FROM Employee_Audit;

/* TASK 44: BEFORE UPDATE trigger to prevent salary decrease */
DELIMITER //
CREATE TRIGGER before_employee_salary_update
BEFORE UPDATE ON Employees
FOR EACH ROW
BEGIN
    IF NEW.salary < OLD.salary THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Salary cannot be decreased';
    END IF;
END //
DELIMITER ;

/* TASK 45: Test salary update trigger */
UPDATE Employees SET salary = 45000 WHERE emp_id = 1;

/* TASK 46: AFTER DELETE trigger for employee backup */
CREATE TABLE Deleted_Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    dept_id INT,
    salary DECIMAL(10,2),
    deletion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER after_employee_delete
AFTER DELETE ON Employees
FOR EACH ROW
BEGIN
    INSERT INTO Deleted_Employees (emp_id, emp_name, dept_id, salary)
    VALUES (OLD.emp_id, OLD.emp_name, OLD.dept_id, OLD.salary);
END //
DELIMITER ;

/* TASK 47: Trigger to update LastModified timestamp */
ALTER TABLE Employees ADD COLUMN last_modified TIMESTAMP;

DELIMITER //
CREATE TRIGGER update_last_modified
BEFORE UPDATE ON Employees
FOR EACH ROW
BEGIN
    SET NEW.last_modified = CURRENT_TIMESTAMP;
END //
DELIMITER ;

/* TASK 48: Trigger for default user roles */
DELIMITER //
CREATE TRIGGER after_user_insert
AFTER INSERT ON Users
FOR EACH ROW
BEGIN
    INSERT INTO UserRoles (user_id, role_id)
    VALUES (NEW.user_id, 3);
END //
DELIMITER ;

/* TASK 49: Drop trigger logNewEmployee */
DROP TRIGGER IF EXISTS logNewEmployee;

/* TASK 50: Complex trigger to prevent deletion with active projects */
DELIMITER //
CREATE TRIGGER before_employee_delete_project_check
BEFORE DELETE ON Employees
FOR EACH ROW
BEGIN
    DECLARE project_count INT;
    
    SELECT COUNT(*) INTO project_count 
    FROM EmployeeProjects 
    WHERE emp_id = OLD.emp_id AND status = 'Active';
    
    IF project_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete employee assigned to active projects';
    END IF;
END //
DELIMITER ;

/* PROJECT 1: Employee Access Control System */
CREATE OR REPLACE VIEW PublicEmployeeView AS SELECT emp_id, emp_name, department FROM Employees;
DELIMITER //
CREATE PROCEDURE GetEmployeesByDepartment(IN dept_name VARCHAR(50))
BEGIN
    SELECT e.emp_id, e.emp_name, e.department 
    FROM Employees e JOIN Departments d ON e.dept_id = d.dept_id
    WHERE d.dept_name = dept_name;
END //
DELIMITER ;
DELIMITER //
CREATE TRIGGER log_employee_insertion
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
    INSERT INTO EmployeeAudit (emp_id, action, action_time)
    VALUES (NEW.emp_id, 'INSERT', NOW());
END //
DELIMITER ;
DELIMITER //
CREATE FUNCTION CountEmployeesInDept(dept_id INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE emp_count INT;
    SELECT COUNT(*) INTO emp_count FROM Employees WHERE dept_id = dept_id;
    RETURN emp_count;
END //
DELIMITER ;

/* PROJECT 2: Sales Reporting & Summary System */
CREATE VIEW MonthlySalesSummary AS
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(order_id) AS total_orders,
    SUM(quantity * unit_price) AS total_sales
FROM Orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m');
DELIMITER //
CREATE FUNCTION GetProductSales(product_id INT) RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(12,2);
    SELECT SUM(quantity * unit_price) INTO total FROM Orders WHERE product_id = product_id;
    RETURN IFNULL(total, 0);
END //
DELIMITER ;
DELIMITER //
CREATE PROCEDURE GetTopCustomers(IN limit_count INT)
BEGIN
    SELECT c.customer_id, c.customer_name, SUM(o.quantity * o.unit_price) AS total_spent
    FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
    ORDER BY total_spent DESC
    LIMIT limit_count;
END //
DELIMITER ;
DELIMITER //
CREATE TRIGGER after_sale_insert
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    INSERT INTO SalesLog (order_id, log_time, action)
    VALUES (NEW.order_id, NOW(), 'New sale recorded');
END //
DELIMITER ;
CREATE VIEW ManagerSalesView AS SELECT * FROM Orders;
CREATE VIEW ClerkSalesView AS SELECT order_id, customer_id, order_date, status FROM Orders;

/* PROJECT 3: Student Information Portal */
CREATE VIEW StudentGradeView AS
SELECT s.student_id, s.student_name, c.course_name, g.grade
FROM Students s JOIN Grades g ON s.student_id = g.student_id
JOIN Courses c ON g.course_id = c.course_id;
CREATE VIEW AdminStudentView AS
SELECT s.*, f.fee_amount, f.paid_status
FROM Students s LEFT JOIN Fees f ON s.student_id = f.student_id;
DELIMITER //
CREATE PROCEDURE GetStudentsByBatchYear(IN batch_year INT)
BEGIN
    SELECT * FROM Students WHERE YEAR(enrollment_date) = batch_year;
END //
DELIMITER ;
DELIMITER //
CREATE FUNCTION CalculateCGPA(student_id INT) RETURNS DECIMAL(3,2)
DETERMINISTIC
BEGIN
    DECLARE cgpa DECIMAL(3,2);
    SELECT AVG(CASE grade 
                  WHEN 'A' THEN 4.0
                  WHEN 'B' THEN 3.0
                  WHEN 'C' THEN 2.0
                  WHEN 'D' THEN 1.0
                  ELSE 0.0
               END) INTO cgpa
    FROM Grades WHERE student_id = student_id;
    RETURN cgpa;
END //
DELIMITER ;
DELIMITER //
CREATE TRIGGER after_student_insert
AFTER INSERT ON Students
FOR EACH ROW
BEGIN
    INSERT INTO StudentLog (student_id, action, action_time)
    VALUES (NEW.student_id, 'New enrollment', NOW());
END //
DELIMITER ;

/* PROJECT 4: Product Stock and Audit Logger */
CREATE VIEW LowStockItems AS
SELECT product_id, product_name, stock_quantity FROM Products WHERE stock_quantity < 50;
DELIMITER //
CREATE PROCEDURE AddProduct(
    IN p_name VARCHAR(100),
    IN p_category VARCHAR(50),
    IN p_price DECIMAL(10,2),
    IN p_quantity INT,
    IN p_supplier_id INT
)
BEGIN
    INSERT INTO Products (product_name, category, price, stock_quantity, supplier_id)
    VALUES (p_name, p_category, p_price, p_quantity, p_supplier_id);
END //
DELIMITER ;
DELIMITER //
CREATE TRIGGER after_product_change
AFTER INSERT OR UPDATE ON Products
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO StockAudit (product_id, action, old_value, new_value, change_time)
        VALUES (NEW.product_id, 'INSERT', NULL, NEW.stock_quantity, NOW());
    ELSE
        IF OLD.stock_quantity != NEW.stock_quantity THEN
            INSERT INTO StockAudit (product_id, action, old_value, new_value, change_time)
            VALUES (NEW.product_id, 'UPDATE', OLD.stock_quantity, NEW.stock_quantity, NOW());
        END IF;
    END IF;
END //
DELIMITER ;
DELIMITER //
CREATE FUNCTION GetStockByCategory(category_name VARCHAR(50)) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT SUM(stock_quantity) INTO total FROM Products WHERE category = category_name;
    RETURN IFNULL(total, 0);
END //
DELIMITER ;
CREATE VIEW SupplierPricingView AS SELECT product_id, product_name, category FROM Products;

/* PROJECT 5: Leave Management System */
DELIMITER //
CREATE TRIGGER update_leave_balance
AFTER INSERT ON LeaveRequests
FOR EACH ROW
BEGIN
    IF NEW.status = 'Approved' THEN
        UPDATE Employees 
        SET leave_balance = leave_balance - NEW.days_requested
        WHERE emp_id = NEW.emp_id;
    END IF;
END //
DELIMITER ;
CREATE VIEW TeamLeaveView AS
SELECT l.*, e.emp_name, e.department
FROM LeaveRequests l JOIN Employees e ON l.emp_id = e.emp_id
WHERE e.manager_id = CURRENT_USER_ID();
DELIMITER //
CREATE PROCEDURE ProcessLeaveRequest(
    IN p_request_id INT,
    IN p_action VARCHAR(20),
    IN p_comment TEXT
)
BEGIN
    UPDATE LeaveRequests 
    SET status = p_action, 
        processed_by = CURRENT_USER(),
        process_date = NOW(),
        comments = p_comment
    WHERE request_id = p_request_id;
END //
DELIMITER ;
DELIMITER //
CREATE FUNCTION GetRemainingLeave(emp_id INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE remaining INT;
    SELECT leave_balance INTO remaining FROM Employees WHERE emp_id = emp_id;
    RETURN remaining;
END //
DELIMITER ;

/* PROJECT 6: Payroll Processing and Monitoring */
CREATE VIEW HRPayrollView AS
SELECT e.emp_id, e.emp_name, e.salary, p.* FROM Employees e JOIN Payroll p ON e.emp_id = p.emp_id;
CREATE VIEW EmployeePayrollView AS
SELECT e.emp_id, e.emp_name, p.pay_date, p.net_pay FROM Employees e JOIN Payroll p ON e.emp_id = p.emp_id;
DELIMITER //
CREATE PROCEDURE GenerateMonthlyPayroll(IN month_year VARCHAR(7))
BEGIN
    INSERT INTO Payroll (emp_id, pay_date, basic_pay, deductions, tax, net_pay)
    SELECT 
        e.emp_id,
        LAST_DAY(STR_TO_DATE(CONCAT(month_year, '-01'), '%Y-%m-%d')) AS pay_date,
        e.salary AS basic_pay,
        e.salary * 0.2 AS deductions,
        CalculateTax(e.salary) AS tax,
        e.salary - (e.salary * 0.2) - CalculateTax(e.salary) AS net_pay
    FROM Employees e
    WHERE e.status = 'Active';
END //
DELIMITER ;
DELIMITER //
CREATE FUNCTION CalculateTax(salary DECIMAL(10,2)) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    IF salary <= 50000 THEN RETURN 0;
    ELSEIF salary <= 100000 THEN RETURN (salary - 50000) * 0.1;
    ELSE RETURN 5000 + (salary - 100000) * 0.2;
    END IF;
END //
DELIMITER ;
DELIMITER //
CREATE TRIGGER log_salary_change
AFTER UPDATE ON Employees
FOR EACH ROW
BEGIN
    IF OLD.salary != NEW.salary THEN
        INSERT INTO SalaryAudit (emp_id, old_salary, new_salary, change_date, changed_by)
        VALUES (NEW.emp_id, OLD.salary, NEW.salary, NOW(), CURRENT_USER());
    END IF;
END //
DELIMITER ;

/* PROJECT 7: Online Exam Result Generator */
CREATE VIEW ExamResultSummary AS
SELECT s.student_id, s.student_name, e.exam_name, r.score, r.grade
FROM Students s JOIN Results r ON s.student_id = r.student_id
JOIN Exams e ON r.exam_id = e.exam_id;
DELIMITER //
CREATE PROCEDURE AssignGrades(IN exam_id INT)
BEGIN
    UPDATE Results r
    SET grade = CASE 
                  WHEN score >= 90 THEN 'A'
                  WHEN score >= 80 THEN 'B'
                  WHEN score >= 70 THEN 'C'
                  WHEN score >= 60 THEN 'D'
                  ELSE 'F'
                END
    WHERE r.exam_id = exam_id;
END //
DELIMITER ;
DELIMITER //
CREATE FUNCTION GetGradeForScore(score INT) RETURNS CHAR(1)
DETERMINISTIC
BEGIN
    RETURN CASE 
             WHEN score >= 90 THEN 'A'
             WHEN score >= 80 THEN 'B'
             WHEN score >= 70 THEN 'C'
             WHEN score >= 60 THEN 'D'
             ELSE 'F'
           END;
END //
DELIMITER ;
DELIMITER //
CREATE TRIGGER prevent_score_update
BEFORE UPDATE ON Results
FOR EACH ROW
BEGIN
    DECLARE is_published BOOLEAN;
    SELECT published INTO is_published FROM Exams WHERE exam_id = NEW.exam_id;
    
    IF is_published AND OLD.score != NEW.score THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot update scores after publishing';
    END IF;
END //
DELIMITER ;
DELIMITER //
CREATE TRIGGER log_score_change
AFTER UPDATE ON Results
FOR EACH ROW
BEGIN
    IF OLD.score != NEW.score THEN
        INSERT INTO ScoreAudit (result_id, old_score, new_score, change_time, changed_by)
        VALUES (NEW.result_id, OLD.score, NEW.score, NOW(), CURRENT_USER());
    END IF;
END //
DELIMITER ;

/* PROJECT 8: Customer Loyalty Program */
CREATE VIEW CustomerLoyaltyView AS
SELECT c.customer_id, c.customer_name, 
       l.points, 
       CASE 
         WHEN l.points >= 1000 THEN 'Gold'
         WHEN l.points >= 500 THEN 'Silver'
         ELSE 'Bronze'
       END AS loyalty_level
FROM Customers c JOIN LoyaltyPoints l ON c.customer_id = l.customer_id;
DELIMITER //
CREATE FUNCTION GetLoyaltyLevel(points INT) RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    RETURN CASE 
             WHEN points >= 1000 THEN 'Gold'
             WHEN points >= 500 THEN 'Silver'
             ELSE 'Bronze'
           END;
END //
DELIMITER ;
DELIMITER //
CREATE PROCEDURE UpdateLoyaltyPoints(
    IN p_customer_id INT,
    IN p_points_to_add INT
)
BEGIN
    INSERT INTO LoyaltyPoints (customer_id, points)
    VALUES (p_customer_id, p_points_to_add)
    ON DUPLICATE KEY UPDATE points = points + p_points_to_add;
END //
DELIMITER ;
DELIMITER //
CREATE TRIGGER after_loyalty_update
AFTER UPDATE ON LoyaltyPoints
FOR EACH ROW
BEGIN
    INSERT INTO LoyaltyAudit (customer_id, old_points, new_points, change_time)
    VALUES (NEW.customer_id, OLD.points, NEW.points, NOW());
END //
DELIMITER ;

/* PROJECT 9: User Registration and Role Manager */
CREATE VIEW AdminUserView AS
SELECT u.user_id, u.username, u.email, u.created_at, r.role_name
FROM Users u JOIN UserRoles ur ON u.user_id = ur.user_id
JOIN Roles r ON ur.role_id = r.role_id;
CREATE VIEW ManagerUserView AS
SELECT u.user_id, u.username, u.created_at, r.role_name
FROM Users u JOIN UserRoles ur ON u.user_id = ur.user_id
JOIN Roles r ON ur.role_id = r.role_id
WHERE r.role_name != 'Admin';
CREATE VIEW EmployeeUserView AS SELECT user_id, username FROM Users;
DELIMITER //
CREATE PROCEDURE AssignUserRole(
    IN p_user_id INT,
    IN p_role_id INT
)
BEGIN
    INSERT INTO UserRoles (user_id, role_id)
    VALUES (p_user_id, p_role_id)
    ON DUPLICATE KEY UPDATE role_id = p_role_id;
END //
DELIMITER ;
DELIMITER //
CREATE FUNCTION IsAdmin(user_id INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE is_admin BOOLEAN;
    SELECT COUNT(*) > 0 INTO is_admin
    FROM UserRoles ur JOIN Roles r ON ur.role_id = r.role_id
    WHERE ur.user_id = user_id AND r.role_name = 'Admin';
    RETURN is_admin;
END //
DELIMITER ;
DELIMITER //
CREATE TRIGGER after_user_create
AFTER INSERT ON Users
FOR EACH ROW
BEGIN
    INSERT INTO UserRoles (user_id, role_id) VALUES (NEW.user_id, 2);
    INSERT INTO UserSettings (user_id) VALUES (NEW.user_id);
END //
DELIMITER ;
DELIMITER //
CREATE TRIGGER after_role_change
AFTER UPDATE ON UserRoles
FOR EACH ROW
BEGIN
    INSERT INTO RoleAudit (user_id, old_role_id, new_role_id, change_time, changed_by)
    VALUES (NEW.user_id, OLD.role_id, NEW.role_id, NOW(), CURRENT_USER());
END //
DELIMITER ;

/* PROJECT 10: E-Commerce Product Search & Filter Engine */
CREATE VIEW AvailableProductsView AS
SELECT p.product_id, p.product_name, p.category, p.price, 
       CASE 
         WHEN p.discount_percent > 0 THEN p.price * (1 - p.discount_percent/100)
         ELSE p.price
       END AS discounted_price,
       p.stock_quantity
FROM Products p
WHERE p.stock_quantity > 0 AND p.status = 'Active';
DELIMITER //
CREATE FUNCTION GetDiscountedPrice(price DECIMAL(10,2), discount_percent DECIMAL(5,2)) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN price * (1 - discount_percent/100);
END //
DELIMITER ;
DELIMITER //
CREATE PROCEDURE SearchProducts(
    IN p_category VARCHAR(50),
    IN p_min_price DECIMAL(10,2),
    IN p_max_price DECIMAL(10,2),
    IN p_search_term VARCHAR(100)
)
BEGIN
    SELECT p.*, 
           CASE 
             WHEN p.discount_percent > 0 THEN p.price * (1 - p.discount_percent/100)
             ELSE p.price
           END AS discounted_price
    FROM Products p
    WHERE (p_category IS NULL OR p.category = p_category)
      AND (p_min_price IS NULL OR p.price >= p_min_price)
      AND (p_max_price IS NULL OR p.price <= p_max_price)
      AND (p_search_term IS NULL OR p.product_name LIKE CONCAT('%', p_search_term, '%'))
      AND p.stock_quantity > 0
      AND p.status = 'Active';
END //
DELIMITER ;
DELIMITER //
CREATE TRIGGER after_product_update
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
    IF OLD.price != NEW.price OR OLD.discount_percent != NEW.discount_percent THEN
        INSERT INTO PriceChangeAudit (product_id, old_price, new_price, old_discount, new_discount, change_time)
        VALUES (NEW.product_id, OLD.price, NEW.price, OLD.discount_percent, NEW.discount_percent, NOW());
    END IF;
END //
DELIMITER ;

/* PROJECT 11: Doctor Appointment and Notification Tracker */
CREATE VIEW DoctorScheduleView AS
SELECT d.doctor_id, d.doctor_name, s.schedule_date, s.start_time, s.end_time, 
       s.status, s.available_slots
FROM Doctors d JOIN DoctorSchedules s ON d.doctor_id = s.doctor_id
WHERE s.schedule_date >= CURDATE() AND s.status = 'Available';
DELIMITER //
CREATE PROCEDURE BookAppointment(
    IN p_patient_id INT,
    IN p_doctor_id INT,
    IN p_schedule_id INT,
    IN p_appointment_time DATETIME
)
BEGIN
    DECLARE slot_count INT;
    SELECT available_slots INTO slot_count FROM DoctorSchedules WHERE schedule_id = p_schedule_id;
    
    IF slot_count > 0 THEN
        INSERT INTO Appointments (patient_id, doctor_id, schedule_id, appointment_time, status)
        VALUES (p_patient_id, p_doctor_id, p_schedule_id, p_appointment_time, 'Scheduled');
        UPDATE DoctorSchedules SET available_slots = available_slots - 1 WHERE schedule_id = p_schedule_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No available slots for this schedule';
    END IF;
END //
DELIMITER ;
DELIMITER //
CREATE FUNCTION GetNextAvailableSlot(doctor_id INT) RETURNS DATETIME
DETERMINISTIC
BEGIN
    DECLARE next_slot DATETIME;
    SELECT MIN(start_time) INTO next_slot
    FROM DoctorSchedules
    WHERE doctor_id = doctor_id AND status = 'Available' AND schedule_date >= CURDATE();
    RETURN next_slot;
END //
DELIMITER ;
DELIMITER //
CREATE TRIGGER notify_doctor_on_booking
AFTER INSERT ON Appointments
FOR EACH ROW
BEGIN
    INSERT INTO NotificationLog (doctor_id, message, notification_time)
    VALUES (NEW.doctor_id, CONCAT('New appointment booked for ', NEW.appointment_time), NOW());
END //
DELIMITER ;
CREATE VIEW PatientMedicalHistoryView AS
SELECT patient_id, visit_date, diagnosis, treatment FROM MedicalRecords;

/* PROJECT 12: NGO Donation and Campaign Summary */
CREATE VIEW PublicDonationSummary AS
SELECT c.campaign_name, SUM(d.amount) AS total_donations
FROM Campaigns c LEFT JOIN Donations d ON c.campaign_id = d.campaign_id
GROUP BY c.campaign_name;
DELIMITER //
CREATE PROCEDURE RegisterDonation(
    IN p_donor_id INT,
    IN p_campaign_id INT,
    IN p_amount DECIMAL(10,2),
    IN p_payment_method VARCHAR(50)
)
BEGIN
    INSERT INTO Donations (donor_id, campaign_id, amount, donation_date, payment_method)
    VALUES (p_donor_id, p_campaign_id, p_amount, CURDATE(), p_payment_method);
END //
DELIMITER ;
DELIMITER //
CREATE FUNCTION TotalDonationByDonor(donor_id INT) RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(12,2);
    SELECT SUM(amount) INTO total FROM Donations WHERE donor_id = donor_id;
    RETURN IFNULL(total, 0);
END //
DELIMITER ;
DELIMITER //
CREATE TRIGGER log_donation
AFTER INSERT ON Donations
FOR EACH ROW
BEGIN
    INSERT INTO DonationAudit (donation_id, audit_time, action)
    VALUES (NEW.donation_id, NOW(), 'New donation recorded');
END //
DELIMITER ;
CREATE VIEW DonorPublicView AS SELECT donor_id, first_name, last_name, donation_tier FROM Donors;

/* PROJECT 13: Restaurant Table Reservation System */
CREATE VIEW AvailableTables AS
SELECT t.table_id, t.capacity, s.slot_time
FROM Tables t JOIN TimeSlots s
WHERE t.table_id NOT IN (
    SELECT table_id FROM Reservations 
    WHERE reservation_date = CURDATE() AND slot_id = s.slot_id
);
DELIMITER //
CREATE PROCEDURE ReserveTable(
    IN p_customer_id INT,
    IN p_table_id INT,
    IN p_slot_id INT,
    IN p_reservation_date DATE
)
BEGIN
    INSERT INTO Reservations (customer_id, table_id, slot_id, reservation_date, status)
    VALUES (p_customer_id, p_table_id, p_slot_id, p_reservation_date, 'Confirmed');
END //
DELIMITER ;
DELIMITER //
CREATE FUNCTION CheckReservationAvailability(
    p_table_id INT,
    p_slot_id INT,
    p_date DATE
) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE is_available BOOLEAN;
    SELECT COUNT(*) = 0 INTO is_available
    FROM Reservations
    WHERE table_id = p_table_id AND slot_id = p_slot_id AND reservation_date = p_date;
    RETURN is_available;
END //
DELIMITER ;
DELIMITER //
CREATE TRIGGER update_table_status
AFTER INSERT ON Reservations
FOR EACH ROW
BEGIN
    UPDATE Tables SET status = 'Reserved' WHERE table_id = NEW.table_id;
END //
DELIMITER ;
DELIMITER //
CREATE TRIGGER log_reservation_cancelation
AFTER UPDATE ON Reservations
FOR EACH ROW
BEGIN
    IF NEW.status = 'Cancelled' AND OLD.status != 'Cancelled' THEN
        INSERT INTO Reservation_Audit (reservation_id, action, action_time)
        VALUES (NEW.reservation_id, 'Cancelled', NOW());
    END IF;
END //
DELIMITER ;

/* PROJECT 14: Service Center Workflow Automation */
CREATE VIEW ServiceRequestStatus AS
SELECT request_id, customer_id, request_date, status 
FROM ServiceRequests WHERE status IN ('Open', 'In Progress');
DELIMITER //
CREATE PROCEDURE AssignTechnician(
    IN p_request_id INT,
    IN p_tech_id INT
)
BEGIN
    UPDATE ServiceRequests 
    SET tech_id = p_tech_id, status = 'In Progress', assigned_date = NOW()
    WHERE request_id = p_request_id;
END //
DELIMITER ;
DELIMITER //
CREATE FUNCTION TimeSinceRequestLogged(request_id INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE hours_passed INT;
    SELECT TIMESTAMPDIFF(HOUR, request_date, NOW()) INTO hours_passed
    FROM ServiceRequests WHERE request_id = request_id;
    RETURN hours_passed;
END //
DELIMITER ;
DELIMITER //
CREATE TRIGGER log_service_completion
AFTER UPDATE ON ServiceRequests
FOR EACH ROW
BEGIN
    IF NEW.status = 'Completed' AND OLD.status != 'Completed' THEN
        INSERT INTO Service_Audit (request_id, completion_time, tech_id)
        VALUES (NEW.request_id, NOW(), NEW.tech_id);
    END IF;
END //
DELIMITER ;
CREATE VIEW CustomerServiceView AS
SELECT request_id, request_date, status FROM ServiceRequests WHERE customer_id = CURRENT_CUSTOMER_ID();

/* PROJECT 15: Event Management System */
CREATE VIEW PublicEventSchedule AS
SELECT event_id, event_name, event_date, location, description
FROM Events WHERE event_date >= CURDATE();
DELIMITER //
CREATE PROCEDURE RegisterParticipant(
    IN p_event_id INT,
    IN p_user_id INT,
    IN p_ticket_type VARCHAR(50)
)
BEGIN
    INSERT INTO EventParticipants (event_id, user_id, registration_date, ticket_type)
    VALUES (p_event_id, p_user_id, NOW(), p_ticket_type);
END //
DELIMITER ;
DELIMITER //
CREATE FUNCTION GetTotalAttendees(event_id INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE attendee_count INT;
    SELECT COUNT(*) INTO attendee_count 
    FROM EventParticipants WHERE event_id = event_id;
    RETURN attendee_count;
END //
DELIMITER ;
DELIMITER //
CREATE TRIGGER log_participant_registration
AFTER INSERT ON EventParticipants
FOR EACH ROW
BEGIN
    INSERT INTO RegistrationAudit (event_id, user_id, registration_time)
    VALUES (NEW.event_id, NEW.user_id, NOW());
END //
DELIMITER ;
CREATE VIEW InternalEventView AS
SELECT e.*, COUNT(p.user_id) AS registered_participants
FROM Events e LEFT JOIN EventParticipants p ON e.event_id = p.event_id
GROUP BY e.event_id;




/* PROJECT 16: HELP DESK AND TICKET LOGGER */

-- View to show open tickets per agent
CREATE VIEW AgentOpenTickets AS
SELECT t.ticket_id, t.customer_id, t.subject, t.created_date, a.agent_name
FROM Tickets t JOIN Agents a ON t.assigned_agent = a.agent_id
WHERE t.status = 'Open';

-- Stored procedure to assign tickets
DELIMITER //
CREATE PROCEDURE AssignTicket(
    IN p_ticket_id INT,
    IN p_agent_id INT
)
BEGIN
    UPDATE Tickets 
    SET assigned_agent = p_agent_id, status = 'Assigned', assigned_date = NOW()
    WHERE ticket_id = p_ticket_id;
END //
DELIMITER ;

-- Function to return average resolution time
DELIMITER //
CREATE FUNCTION GetAverageResolutionTime() RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE avg_hours DECIMAL(10,2);
    SELECT AVG(TIMESTAMPDIFF(HOUR, created_date, resolved_date)) INTO avg_hours
    FROM Tickets WHERE status = 'Closed';
    RETURN avg_hours;
END //
DELIMITER ;

-- Trigger to log ticket status changes
DELIMITER //
CREATE TRIGGER log_ticket_status_change
AFTER UPDATE ON Tickets
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO TicketStatusLog (ticket_id, old_status, new_status, change_time)
        VALUES (NEW.ticket_id, OLD.status, NEW.status, NOW());
    END IF;
END //
DELIMITER ;

-- Filtered view for agents
CREATE VIEW AgentTicketView AS
SELECT ticket_id, customer_id, subject, priority, status, created_date 
FROM Tickets WHERE assigned_agent = CURRENT_AGENT_ID();


/* PROJECT 17: TRANSPORT BOOKING AND ROUTE MANAGER */

-- View for available routes
CREATE VIEW AvailableRoutes AS
SELECT r.route_id, r.departure_city, r.arrival_city, r.departure_time, 
       r.arrival_time, r.price, (r.capacity - COUNT(b.booking_id)) AS available_seats
FROM Routes r LEFT JOIN Bookings b ON r.route_id = b.route_id AND b.travel_date = CURDATE()
GROUP BY r.route_id;

-- Stored procedure to book seats
DELIMITER //
CREATE PROCEDURE BookSeat(
    IN p_route_id INT,
    IN p_passenger_id INT,
    IN p_travel_date DATE
)
BEGIN
    INSERT INTO Bookings (route_id, passenger_id, booking_date, travel_date, status)
    VALUES (p_route_id, p_passenger_id, NOW(), p_travel_date, 'Confirmed');
END //
DELIMITER ;

-- Function to check seat availability
DELIMITER //
CREATE FUNCTION CheckSeatAvailability(
    p_route_id INT,
    p_travel_date DATE
) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE available_seats INT;
    SELECT (r.capacity - COUNT(b.booking_id)) INTO available_seats
    FROM Routes r LEFT JOIN Bookings b ON r.route_id = b.route_id AND b.travel_date = p_travel_date
    WHERE r.route_id = p_route_id;
    RETURN available_seats;
END //
DELIMITER ;

-- Trigger to update seat status
DELIMITER //
CREATE TRIGGER update_seat_status
AFTER INSERT ON Bookings
FOR EACH ROW
BEGIN
    UPDATE Routes SET available_seats = available_seats - 1 WHERE route_id = NEW.route_id;
END //
DELIMITER ;

-- Public route view (hides internal details)
CREATE VIEW PublicRouteView AS
SELECT route_id, departure_city, arrival_city, departure_time, arrival_time, price 
FROM Routes;


/* PROJECT 18: ONLINE ASSESSMENT TRACKER */

-- Student view (scores only)
CREATE VIEW StudentScores AS
SELECT s.student_id, s.student_name, a.assessment_name, sa.score, sa.grade
FROM Students s JOIN StudentAssessments sa ON s.student_id = sa.student_id
JOIN Assessments a ON sa.assessment_id = a.assessment_id;

-- Grade calculation function
DELIMITER //
CREATE FUNCTION CalculateGrade(score INT) RETURNS CHAR(1)
DETERMINISTIC
BEGIN
    RETURN CASE 
             WHEN score >= 90 THEN 'A'
             WHEN score >= 80 THEN 'B'
             WHEN score >= 70 THEN 'C'
             WHEN score >= 60 THEN 'D'
             ELSE 'F'
           END;
END //
DELIMITER ;

-- Procedure to insert assessment records
DELIMITER //
CREATE PROCEDURE InsertAssessmentResult(
    IN p_student_id INT,
    IN p_assessment_id INT,
    IN p_score INT
)
BEGIN
    INSERT INTO StudentAssessments (student_id, assessment_id, score, grade)
    VALUES (p_student_id, p_assessment_id, p_score, CalculateGrade(p_score));
END //
DELIMITER ;

-- Trigger to prevent late changes
DELIMITER //
CREATE TRIGGER prevent_late_grade_changes
BEFORE UPDATE ON StudentAssessments
FOR EACH ROW
BEGIN
    DECLARE deadline_passed BOOLEAN;
    SELECT NOW() > grading_deadline INTO deadline_passed
    FROM Assessments WHERE assessment_id = NEW.assessment_id;
    
    IF deadline_passed THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot update grades after the deadline';
    END IF;
END //
DELIMITER ;

-- Instructor view (with answers)
CREATE VIEW InstructorAssessmentView AS
SELECT sa.*, a.assessment_name, s.student_name, a.correct_answers
FROM StudentAssessments sa
JOIN Assessments a ON sa.assessment_id = a.assessment_id
JOIN Students s ON sa.student_id = s.student_id;


/* PROJECT 19: INSURANCE POLICY ISSUANCE SYSTEM */

-- Customer policy status view
CREATE VIEW CustomerPolicyStatus AS
SELECT c.customer_id, c.customer_name, p.policy_number, p.policy_type, p.status, p.expiry_date
FROM Customers c JOIN Policies p ON c.customer_id = p.customer_id;

-- Procedure to issue new policy
DELIMITER //
CREATE PROCEDURE IssueNewPolicy(
    IN p_customer_id INT,
    IN p_policy_type VARCHAR(50),
    IN p_premium DECIMAL(10,2),
    IN p_coverage_amount DECIMAL(12,2),
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    INSERT INTO Policies (customer_id, policy_number, policy_type, premium, 
                         coverage_amount, start_date, expiry_date, status)
    VALUES (p_customer_id, 
            CONCAT('POL', LPAD(FLOOR(RAND() * 1000000), 6, '0')),
            p_policy_type, p_premium, p_coverage_amount, p_start_date, p_end_date, 'Active');
END //
DELIMITER ;

-- Function to check active policies
DELIMITER //
CREATE FUNCTION CountActivePolicies(customer_id INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE policy_count INT;
    SELECT COUNT(*) INTO policy_count 
    FROM Policies 
    WHERE customer_id = customer_id AND status = 'Active' AND expiry_date >= CURDATE();
    RETURN policy_count;
END //
DELIMITER ;

-- Trigger to log policy changes
DELIMITER //
CREATE TRIGGER log_policy_changes
AFTER UPDATE ON Policies
FOR EACH ROW
BEGIN
    IF OLD.premium != NEW.premium OR OLD.coverage_amount != NEW.coverage_amount OR 
       OLD.expiry_date != NEW.expiry_date THEN
        INSERT INTO PolicyChangeLog (policy_id, change_time, changed_by, change_details)
        VALUES (NEW.policy_id, NOW(), CURRENT_USER(), 
                CONCAT('Premium: ', OLD.premium, '->', NEW.premium, 
                       ', Coverage: ', OLD.coverage_amount, '->', NEW.coverage_amount,
                       ', Expiry: ', OLD.expiry_date, '->', NEW.expiry_date));
    END IF;
END //
DELIMITER ;

-- Agent view (with contact details)
CREATE VIEW AgentPolicyView AS
SELECT p.*, c.customer_name, c.contact_number FROM Policies p JOIN Customers c ON p.customer_id = c.customer_id;


/* PROJECT 20: REAL ESTATE PROPERTY LISTING PORTAL */

-- Available properties view
CREATE VIEW AvailableProperties AS
SELECT p.property_id, p.address, p.city, p.property_type, p.price, p.bedrooms, p.bathrooms
FROM Properties p WHERE p.status = 'Available';

-- Procedure to schedule visits
DELIMITER //
CREATE PROCEDURE SchedulePropertyVisit(
    IN p_property_id INT,
    IN p_client_id INT,
    IN p_visit_date DATETIME,
    IN p_agent_id INT
)
BEGIN
    INSERT INTO PropertyVisits (property_id, client_id, visit_date, agent_id, status)
    VALUES (p_property_id, p_client_id, p_visit_date, p_agent_id, 'Scheduled');
END //
DELIMITER ;

-- Function to count listings by location
DELIMITER //
CREATE FUNCTION CountListingsByLocation(location VARCHAR(50)) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE listing_count INT;
    SELECT COUNT(*) INTO listing_count 
    FROM Properties 
    WHERE (city = location OR address LIKE CONCAT('%', location, '%')) AND status = 'Available';
    RETURN listing_count;
END //
DELIMITER ;

-- Trigger to log property changes
DELIMITER //
CREATE TRIGGER log_property_changes
AFTER UPDATE ON Properties
FOR EACH ROW
BEGIN
    IF OLD.price != NEW.price OR OLD.status != NEW.status THEN
        INSERT INTO PropertyChangeLog (property_id, change_time, changed_by, old_price, new_price, old_status, new_status)
        VALUES (NEW.property_id, NOW(), CURRENT_USER(), OLD.price, NEW.price, OLD.status, NEW.status);
    END IF;
END //
DELIMITER ;

-- Public property view (hides owner info)
CREATE VIEW PublicPropertyView AS
SELECT property_id, address, city, property_type, price, bedrooms, bathrooms, square_footage 
FROM Properties WHERE status = 'Available';