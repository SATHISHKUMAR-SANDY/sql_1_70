-- 1. Create Employees table
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    manager_id INT,
    position VARCHAR(100),
    department VARCHAR(100),
    FOREIGN KEY (manager_id) REFERENCES Employees(emp_id)
);

-- 2. Insert sample data
INSERT INTO Employees VALUES
(1, 'John CEO', NULL, 'CEO', 'Executive'),
(2, 'Alice HR Manager', 1, 'HR Manager', 'HR'),
(3, 'Bob IT Manager', 1, 'IT Manager', 'IT'),
(4, 'Carol HR Staff', 2, 'HR Associate', 'HR'),
(5, 'Dave IT Staff', 3, 'IT Developer', 'IT'),
(6, 'Eve IT Staff', 3, 'IT Developer', 'IT'),
(7, 'Frank HR Intern', 4, 'HR Intern', 'HR');

-- 3. Recursive query for full hierarchy
WITH RECURSIVE EmployeeHierarchy AS (
    -- Base case: start with top-level employees (those with no manager)
    SELECT emp_id, emp_name, manager_id, 1 AS level
    FROM Employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive case: join employees with their managers
    SELECT e.emp_id, e.emp_name, e.manager_id, eh.level + 1
    FROM Employees e
    JOIN EmployeeHierarchy eh ON e.manager_id = eh.emp_id
)
SELECT * FROM EmployeeHierarchy;

-- 4. Hierarchy sorted by level
WITH RECURSIVE EmployeeHierarchy AS (
    SELECT emp_id, emp_name, manager_id, 1 AS level
    FROM Employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    SELECT e.emp_id, e.emp_name, e.manager_id, eh.level + 1
    FROM Employees e
    JOIN EmployeeHierarchy eh ON e.manager_id = eh.emp_id
)
SELECT * FROM EmployeeHierarchy ORDER BY level, emp_id;

-- 5. Include position column
WITH RECURSIVE EmployeeHierarchy AS (
    SELECT emp_id, emp_name, manager_id, position, 1 AS level
    FROM Employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    SELECT e.emp_id, e.emp_name, e.manager_id, e.position, eh.level + 1
    FROM Employees e
    JOIN EmployeeHierarchy eh ON e.manager_id = eh.emp_id
)
SELECT * FROM EmployeeHierarchy ORDER BY level, emp_id;

-- 6. Subordinates of manager_id = 2
WITH RECURSIVE Subordinates AS (
    SELECT emp_id, emp_name, manager_id
    FROM Employees
    WHERE manager_id = 2
    
    UNION ALL
    
    SELECT e.emp_id, e.emp_name, e.manager_id
    FROM Employees e
    JOIN Subordinates s ON e.manager_id = s.emp_id
)
SELECT * FROM Subordinates;

-- 7. Prevent cyclic relationships
ALTER TABLE Employees ADD CONSTRAINT no_self_reference CHECK (emp_id != manager_id);

-- 8. Create EmployeeHierarchyView
CREATE VIEW EmployeeHierarchyView AS
WITH RECURSIVE EmployeeHierarchy AS (
    SELECT emp_id, emp_name, manager_id, position, department, 1 AS level
    FROM Employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    SELECT e.emp_id, e.emp_name, e.manager_id, e.position, e.department, eh.level + 1
    FROM Employees e
    JOIN EmployeeHierarchy eh ON e.manager_id = eh.emp_id
)
SELECT * FROM EmployeeHierarchy ORDER BY level, emp_id;

-- 9. Filter level 3 employees
WITH RECURSIVE EmployeeHierarchy AS (
    SELECT emp_id, emp_name, manager_id, 1 AS level
    FROM Employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    SELECT e.emp_id, e.emp_name, e.manager_id, eh.level + 1
    FROM Employees e
    JOIN EmployeeHierarchy eh ON e.manager_id = eh.emp_id
)
SELECT * FROM EmployeeHierarchy WHERE level = 3;

-- 10. Find maximum hierarchy level
WITH RECURSIVE EmployeeHierarchy AS (
    SELECT emp_id, emp_name, manager_id, 1 AS level
    FROM Employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    SELECT e.emp_id, e.emp_name, e.manager_id, eh.level + 1
    FROM Employees e
    JOIN EmployeeHierarchy eh ON e.manager_id = eh.emp_id
)
SELECT MAX(level) AS max_level FROM EmployeeHierarchy;

-- 11. Show managers and team counts
SELECT 
    m.emp_id AS manager_id,
    m.emp_name AS manager_name,
    COUNT(e.emp_id) AS team_count
FROM Employees e
JOIN Employees m ON e.manager_id = m.emp_id
GROUP BY m.emp_id, m.emp_name
ORDER BY team_count DESC;

-- 12. Count direct and indirect reports
WITH RECURSIVE ReportsCount AS (
    -- Base case: all employees
    SELECT emp_id, emp_name, manager_id, 0 AS is_manager
    FROM Employees
    
    UNION ALL
    
    -- Recursive case: count reports
    SELECT r.emp_id, r.emp_name, r.manager_id, 1 AS is_manager
    FROM ReportsCount rc
    JOIN Employees r ON rc.manager_id = r.emp_id
)
SELECT 
    e.emp_id,
    e.emp_name,
    COUNT(DISTINCT rc.emp_id) - 1 AS total_reports  -- subtract self
FROM Employees e
LEFT JOIN ReportsCount rc ON e.emp_id = rc.manager_id
GROUP BY e.emp_id, e.emp_name
HAVING COUNT(DISTINCT rc.emp_id) > 1
ORDER BY total_reports DESC;

-- 13. Path from CEO to each employee
WITH RECURSIVE EmployeePath AS (
    SELECT 
        emp_id, 
        emp_name, 
        manager_id, 
        emp_name AS path,
        1 AS level
    FROM Employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    SELECT 
        e.emp_id, 
        e.emp_name, 
        e.manager_id, 
        ep.path || ' -> ' || e.emp_name AS path,
        ep.level + 1
    FROM Employees e
    JOIN EmployeePath ep ON e.manager_id = ep.emp_id
)
SELECT emp_id, emp_name, path, level FROM EmployeePath ORDER BY level, emp_id;

-- 14. Department hierarchy
WITH RECURSIVE DeptHierarchy AS (
    SELECT 
        emp_id, emp_name, manager_id, department, 
        emp_name AS path,
        1 AS level
    FROM Employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    SELECT 
        e.emp_id, e.emp_name, e.manager_id, e.department,
        dh.path || ' -> ' || e.emp_name AS path,
        dh.level + 1
    FROM Employees e
    JOIN DeptHierarchy dh ON e.manager_id = dh.emp_id
)
SELECT * FROM DeptHierarchy ORDER BY department, level, emp_id;

-- 15. Depth of a given employee (e.g., emp_id = 7)
WITH RECURSIVE EmployeeDepth AS (
    SELECT emp_id, emp_name, manager_id, 1 AS depth
    FROM Employees
    WHERE emp_id = 7
    
    UNION ALL
    
    SELECT e.emp_id, e.emp_name, e.manager_id, ed.depth + 1
    FROM Employees e
    JOIN EmployeeDepth ed ON e.emp_id = ed.manager_id
)
SELECT MAX(depth) AS employee_depth FROM EmployeeDepth;


-- 16. Create Salaries table
CREATE TABLE Salaries (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL
);

-- 17. Insert sample data
INSERT INTO Salaries VALUES
(1, 'John', 'IT', 85000),
(2, 'Alice', 'HR', 75000),
(3, 'Bob', 'IT', 95000),
(4, 'Carol', 'HR', 65000),
(5, 'Dave', 'Finance', 110000),
(6, 'Eve', 'Finance', 105000),
(7, 'Frank', 'IT', 80000),
(8, 'Grace', 'HR', 72000),
(9, 'Henry', 'Finance', 115000),
(10, 'Ivy', 'IT', 90000);

-- 18. ROW_NUMBER() salary ranking
SELECT 
    emp_id, 
    emp_name, 
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS salary_rank
FROM Salaries;

-- 19. RANK() with ties
SELECT 
    emp_id, 
    emp_name, 
    salary,
    RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM Salaries;

-- 20. DENSE_RANK() compared to RANK()
SELECT 
    emp_id, 
    emp_name, 
    salary,
    RANK() OVER (ORDER BY salary DESC) AS rank,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank
FROM Salaries;

-- 21. Partition ranking by department
SELECT 
    emp_id, 
    emp_name, 
    department,
    salary,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_rank
FROM Salaries;

-- 22. LAG() for previous salary
SELECT 
    emp_id, 
    emp_name, 
    salary,
    LAG(salary) OVER (ORDER BY salary) AS previous_salary
FROM Salaries;

-- 23. LEAD() for next salary
SELECT 
    emp_id, 
    emp_name, 
    salary,
    LEAD(salary) OVER (ORDER BY salary) AS next_salary
FROM Salaries;

-- 24. ROW_NUMBER() and LAG() for progression
WITH RankedSalaries AS (
    SELECT 
        emp_id, 
        emp_name, 
        salary,
        ROW_NUMBER() OVER (ORDER BY salary) AS rank,
        LAG(salary) OVER (ORDER BY salary) AS previous_salary
    FROM Salaries
)
SELECT 
    emp_id, 
    emp_name, 
    salary,
    previous_salary,
    salary - previous_salary AS salary_increase
FROM RankedSalaries;

-- 25. Employees with salary increases
WITH SalaryChanges AS (
    SELECT 
        emp_id, 
        emp_name, 
        salary,
        LAG(salary) OVER (ORDER BY salary) AS previous_salary
    FROM Salaries
)
SELECT 
    emp_id, 
    emp_name, 
    salary,
    previous_salary,
    salary - previous_salary AS salary_increase
FROM SalaryChanges
WHERE salary > previous_salary OR previous_salary IS NULL;

-- 26. NTILE(3) for salary tiers
SELECT 
    emp_id, 
    emp_name, 
    salary,
    NTILE(3) OVER (ORDER BY salary) AS salary_tier
FROM Salaries;

-- 27. FIRST_VALUE() and LAST_VALUE() for extremes
SELECT 
    emp_id, 
    emp_name, 
    department,
    salary,
    FIRST_VALUE(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS dept_highest,
    LAST_VALUE(salary) OVER (PARTITION BY department ORDER BY salary DESC
        RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS dept_lowest
FROM Salaries;

-- 28. CUME_DIST() and PERCENT_RANK()
SELECT 
    emp_id, 
    emp_name, 
    salary,
    CUME_DIST() OVER (ORDER BY salary) AS cume_dist,
    PERCENT_RANK() OVER (ORDER BY salary) AS percent_rank
FROM Salaries;

-- 29. Moving average salary
SELECT 
    emp_id, 
    emp_name, 
    salary,
    AVG(salary) OVER (ORDER BY salary
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS moving_avg
FROM Salaries;

-- 30. Create real-time ranking view
CREATE VIEW EmployeeSalaryRanking AS
SELECT 
    emp_id, 
    emp_name, 
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_rank,
    RANK() OVER (ORDER BY salary DESC) AS company_rank
FROM Salaries;

-- 31. Salary as percentage of department total
SELECT 
    emp_id, 
    emp_name, 
    department,
    salary,
    salary * 100.0 / SUM(salary) OVER (PARTITION BY department) AS dept_salary_percentage
FROM Salaries;

-- 32. Difference from highest salary in department
SELECT 
    emp_id, 
    emp_name, 
    department,
    salary,
    FIRST_VALUE(salary) OVER (PARTITION BY department ORDER BY salary DESC) - salary AS diff_from_top
FROM Salaries;

-- 33. Peer comparison report
SELECT 
    emp_id, 
    emp_name, 
    department,
    salary,
    AVG(salary) OVER (PARTITION BY department) AS dept_avg,
    salary - AVG(salary) OVER (PARTITION BY department) AS diff_from_avg,
    PERCENT_RANK() OVER (PARTITION BY department ORDER BY salary) AS dept_percentile
FROM Salaries;

-- 34. Employees below department average
WITH DeptAverages AS (
    SELECT 
        emp_id, 
        emp_name, 
        department,
        salary,
        AVG(salary) OVER (PARTITION BY department) AS dept_avg
    FROM Salaries
)
SELECT 
    emp_id, 
    emp_name, 
    department,
    salary,
    dept_avg
FROM DeptAverages
WHERE salary < dept_avg;

-- 35. Department groups with salary ranking
SELECT 
    department,
    emp_name,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_rank,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS company_rank
FROM Salaries
ORDER BY department, dept_rank;

-- 36. Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    order_date DATE NOT NULL
);

-- 37. Insert sample data
INSERT INTO Orders VALUES
(1, 1, 5000, '2023-01-15'),
(2, 2, 12000, '2023-01-16'),
(3, 3, 8000, '2023-01-17'),
(4, 1, 15000, '2023-02-01'),
(5, 4, 9000, '2023-02-05'),
(6, 2, 11000, '2023-02-10'),
(7, 5, 13000, '2023-02-15'),
(8, 3, 7000, '2023-02-20'),
(9, 1, 25000, '2023-03-01'),
(10, 2, 18000, '2023-03-05'),
(11, 4, 6000, '2023-03-10'),
(12, 5, 14000, '2023-03-15'),
(13, 1, 9000, '2023-03-20'),
(14, 3, 12000, '2023-04-01'),
(15, 2, 16000, '2023-04-05'),
(16, 4, 11000, '2023-04-10'),
(17, 5, 8000, '2023-04-15'),
(18, 1, 17000, '2023-05-01'),
(19, 2, 14000, '2023-05-05'),
(20, 3, 19000, '2023-05-10');

-- 38. CTE for high-value orders
WITH HighValueOrders AS (
    SELECT * FROM Orders WHERE amount > 10000
)
SELECT * FROM HighValueOrders ORDER BY amount DESC;

-- 39. CTE for total order amount per customer
WITH CustomerTotals AS (
    SELECT 
        customer_id,
        SUM(amount) AS total_amount,
        COUNT(*) AS order_count
    FROM Orders
    GROUP BY customer_id
)
SELECT * FROM CustomerTotals ORDER BY total_amount DESC;

-- 40. CTE for frequent customers (>3 orders)
WITH FrequentCustomers AS (
    SELECT 
        customer_id,
        COUNT(*) AS order_count
    FROM Orders
    GROUP BY customer_id
    HAVING COUNT(*) > 3
)
SELECT * FROM FrequentCustomers ORDER BY order_count DESC;

-- 41. Two CTEs for different customer segments
WITH TopSpenders AS (
    SELECT 
        customer_id,
        SUM(amount) AS total_spent
    FROM Orders
    GROUP BY customer_id
    ORDER BY total_spent DESC
    LIMIT 3
),
FrequentBuyers AS (
    SELECT 
        customer_id,
        COUNT(*) AS order_count
    FROM Orders
    GROUP BY customer_id
    ORDER BY order_count DESC
    LIMIT 3
)
SELECT 'Top Spender' AS segment, customer_id, total_spent AS value FROM TopSpenders
UNION ALL
SELECT 'Frequent Buyer' AS segment, customer_id, order_count AS value FROM FrequentBuyers;

-- 42. Recursive CTE for product categories
WITH RECURSIVE CategoryTree AS (
    -- Base case: top-level categories
    SELECT 
        category_id,
        category_name,
        parent_category_id,
        1 AS level,
        category_name AS path
    FROM Categories
    WHERE parent_category_id IS NULL
    
    UNION ALL
    
    -- Recursive case: child categories
    SELECT 
        c.category_id,
        c.category_name,
        c.parent_category_id,
        ct.level + 1,
        ct.path || ' > ' || c.category_name AS path
    FROM Categories c
    JOIN CategoryTree ct ON c.parent_category_id = ct.category_id
)
SELECT * FROM CategoryTree ORDER BY path;

-- 43. Recursive CTE for factorial calculation
WITH RECURSIVE Factorial AS (
    -- Base case: 0! = 1
    SELECT 0 AS n, 1 AS factorial
    
    UNION ALL
    
    -- Recursive case: n! = n * (n-1)!
    SELECT 
        n + 1,
        (n + 1) * factorial
    FROM Factorial
    WHERE n < 10  -- Calculate up to 10!
)
SELECT * FROM Factorial;

-- 44. CTE for running totals with date filter
WITH DailySales AS (
    SELECT 
        order_date,
        SUM(amount) AS daily_total
    FROM Orders
    WHERE order_date BETWEEN '2023-03-01' AND '2023-03-31'
    GROUP BY order_date
)
SELECT 
    order_date,
    daily_total,
    SUM(daily_total) OVER (ORDER BY order_date) AS running_total
FROM DailySales
ORDER BY order_date;

-- 45. CTE inside a view for reporting
CREATE VIEW CustomerOrderSummary AS
WITH CustomerStats AS (
    SELECT 
        customer_id,
        COUNT(*) AS order_count,
        SUM(amount) AS total_spent,
        AVG(amount) AS avg_order_value,
        MIN(order_date) AS first_order_date,
        MAX(order_date) AS last_order_date
    FROM Orders
    GROUP BY customer_id
)
SELECT 
    customer_id,
    order_count,
    total_spent,
    avg_order_value,
    first_order_date,
    last_order_date,
    DATEDIFF(day, first_order_date, last_order_date) AS customer_lifetime_days
FROM CustomerStats;

-- 46. Chained CTEs for complex analysis
WITH 
OrderCounts AS (
    SELECT customer_id, COUNT(*) AS order_count FROM Orders GROUP BY customer_id
),
OrderTotals AS (
    SELECT customer_id, SUM(amount) AS total_amount FROM Orders GROUP BY customer_id
),
CustomerSegments AS (
    SELECT 
        o.customer_id,
        oc.order_count,
        ot.total_amount,
        CASE 
            WHEN ot.total_amount > 50000 THEN 'Platinum'
            WHEN ot.total_amount > 25000 THEN 'Gold'
            WHEN ot.total_amount > 10000 THEN 'Silver'
            ELSE 'Bronze'
        END AS customer_segment
    FROM Orders o
    JOIN OrderCounts oc ON o.customer_id = oc.customer_id
    JOIN OrderTotals ot ON o.customer_id = ot.customer_id
    GROUP BY o.customer_id, oc.order_count, ot.total_amount
)
SELECT * FROM CustomerSegments ORDER BY total_amount DESC;

-- 47. Performance comparison (conceptual - actual implementation varies by DBMS)
-- Long nested query example (harder to read)
SELECT * FROM (
    SELECT customer_id, SUM(amount) AS total FROM Orders GROUP BY customer_id
) t WHERE total > 10000;

-- Equivalent CTE (easier to read)
WITH CustomerTotals AS (
    SELECT customer_id, SUM(amount) AS total FROM Orders GROUP BY customer_id
)
SELECT * FROM CustomerTotals WHERE total > 10000;

-- 48. Recursive CTE for reporting chain
WITH RECURSIVE ReportingChain AS (
    -- Base case: start with the employee
    SELECT emp_id, emp_name, manager_id, 1 AS level
    FROM Employees
    WHERE emp_id = 7  -- Starting with Frank (HR Intern)
    
    UNION ALL
    
    -- Recursive case: go up the chain
    SELECT e.emp_id, e.emp_name, e.manager_id, rc.level + 1
    FROM Employees e
    JOIN ReportingChain rc ON e.emp_id = rc.manager_id
)
SELECT * FROM ReportingChain ORDER BY level DESC;

-- 49. Temporary table using CTE (syntax varies by DBMS)
-- PostgreSQL example:
CREATE TEMP TABLE TopCustomers AS
WITH RegionalTotals AS (
    SELECT 
        c.customer_id,
        c.region,
        SUM(o.amount) AS total_spent
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.region
),
RankedCustomers AS (
    SELECT 
        customer_id,
        region,
        total_spent,
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY total_spent DESC) AS region_rank
    FROM RegionalTotals
)
SELECT * FROM RankedCustomers WHERE region_rank <= 5;

-- 50. Combined CTE + window function for customer ranking
WITH CustomerTotals AS (
    SELECT 
        customer_id,
        SUM(amount) AS total_orders,
        COUNT(*) AS order_count
    FROM Orders
    GROUP BY customer_id
)
SELECT 
    customer_id,
    total_orders,
    order_count,
    RANK() OVER (ORDER BY total_orders DESC) AS spending_rank,
    DENSE_RANK() OVER (ORDER BY order_count DESC) AS frequency_rank
FROM CustomerTotals
ORDER BY spending_rank;-- 36. Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    order_date DATE NOT NULL
);

-- 37. Insert sample data
INSERT INTO Orders VALUES
(1, 1, 5000, '2023-01-15'),
(2, 2, 12000, '2023-01-16'),
(3, 3, 8000, '2023-01-17'),
(4, 1, 15000, '2023-02-01'),
(5, 4, 9000, '2023-02-05'),
(6, 2, 11000, '2023-02-10'),
(7, 5, 13000, '2023-02-15'),
(8, 3, 7000, '2023-02-20'),
(9, 1, 25000, '2023-03-01'),
(10, 2, 18000, '2023-03-05'),
(11, 4, 6000, '2023-03-10'),
(12, 5, 14000, '2023-03-15'),
(13, 1, 9000, '2023-03-20'),
(14, 3, 12000, '2023-04-01'),
(15, 2, 16000, '2023-04-05'),
(16, 4, 11000, '2023-04-10'),
(17, 5, 8000, '2023-04-15'),
(18, 1, 17000, '2023-05-01'),
(19, 2, 14000, '2023-05-05'),
(20, 3, 19000, '2023-05-10');

-- 38. CTE for high-value orders
WITH HighValueOrders AS (
    SELECT * FROM Orders WHERE amount > 10000
)
SELECT * FROM HighValueOrders ORDER BY amount DESC;

-- 39. CTE for total order amount per customer
WITH CustomerTotals AS (
    SELECT 
        customer_id,
        SUM(amount) AS total_amount,
        COUNT(*) AS order_count
    FROM Orders
    GROUP BY customer_id
)
SELECT * FROM CustomerTotals ORDER BY total_amount DESC;

-- 40. CTE for frequent customers (>3 orders)
WITH FrequentCustomers AS (
    SELECT 
        customer_id,
        COUNT(*) AS order_count
    FROM Orders
    GROUP BY customer_id
    HAVING COUNT(*) > 3
)
SELECT * FROM FrequentCustomers ORDER BY order_count DESC;

-- 41. Two CTEs for different customer segments
WITH TopSpenders AS (
    SELECT 
        customer_id,
        SUM(amount) AS total_spent
    FROM Orders
    GROUP BY customer_id
    ORDER BY total_spent DESC
    LIMIT 3
),
FrequentBuyers AS (
    SELECT 
        customer_id,
        COUNT(*) AS order_count
    FROM Orders
    GROUP BY customer_id
    ORDER BY order_count DESC
    LIMIT 3
)
SELECT 'Top Spender' AS segment, customer_id, total_spent AS value FROM TopSpenders
UNION ALL
SELECT 'Frequent Buyer' AS segment, customer_id, order_count AS value FROM FrequentBuyers;

-- 42. Recursive CTE for product categories
WITH RECURSIVE CategoryTree AS (
    -- Base case: top-level categories
    SELECT 
        category_id,
        category_name,
        parent_category_id,
        1 AS level,
        category_name AS path
    FROM Categories
    WHERE parent_category_id IS NULL
    
    UNION ALL
    
    -- Recursive case: child categories
    SELECT 
        c.category_id,
        c.category_name,
        c.parent_category_id,
        ct.level + 1,
        ct.path || ' > ' || c.category_name AS path
    FROM Categories c
    JOIN CategoryTree ct ON c.parent_category_id = ct.category_id
)
SELECT * FROM CategoryTree ORDER BY path;

-- 43. Recursive CTE for factorial calculation
WITH RECURSIVE Factorial AS (
    -- Base case: 0! = 1
    SELECT 0 AS n, 1 AS factorial
    
    UNION ALL
    
    -- Recursive case: n! = n * (n-1)!
    SELECT 
        n + 1,
        (n + 1) * factorial
    FROM Factorial
    WHERE n < 10  -- Calculate up to 10!
)
SELECT * FROM Factorial;

-- 44. CTE for running totals with date filter
WITH DailySales AS (
    SELECT 
        order_date,
        SUM(amount) AS daily_total
    FROM Orders
    WHERE order_date BETWEEN '2023-03-01' AND '2023-03-31'
    GROUP BY order_date
)
SELECT 
    order_date,
    daily_total,
    SUM(daily_total) OVER (ORDER BY order_date) AS running_total
FROM DailySales
ORDER BY order_date;

-- 45. CTE inside a view for reporting
CREATE VIEW CustomerOrderSummary AS
WITH CustomerStats AS (
    SELECT 
        customer_id,
        COUNT(*) AS order_count,
        SUM(amount) AS total_spent,
        AVG(amount) AS avg_order_value,
        MIN(order_date) AS first_order_date,
        MAX(order_date) AS last_order_date
    FROM Orders
    GROUP BY customer_id
)
SELECT 
    customer_id,
    order_count,
    total_spent,
    avg_order_value,
    first_order_date,
    last_order_date,
    DATEDIFF(day, first_order_date, last_order_date) AS customer_lifetime_days
FROM CustomerStats;

-- 46. Chained CTEs for complex analysis
WITH 
OrderCounts AS (
    SELECT customer_id, COUNT(*) AS order_count FROM Orders GROUP BY customer_id
),
OrderTotals AS (
    SELECT customer_id, SUM(amount) AS total_amount FROM Orders GROUP BY customer_id
),
CustomerSegments AS (
    SELECT 
        o.customer_id,
        oc.order_count,
        ot.total_amount,
        CASE 
            WHEN ot.total_amount > 50000 THEN 'Platinum'
            WHEN ot.total_amount > 25000 THEN 'Gold'
            WHEN ot.total_amount > 10000 THEN 'Silver'
            ELSE 'Bronze'
        END AS customer_segment
    FROM Orders o
    JOIN OrderCounts oc ON o.customer_id = oc.customer_id
    JOIN OrderTotals ot ON o.customer_id = ot.customer_id
    GROUP BY o.customer_id, oc.order_count, ot.total_amount
)
SELECT * FROM CustomerSegments ORDER BY total_amount DESC;

-- 47. Performance comparison (conceptual - actual implementation varies by DBMS)
-- Long nested query example (harder to read)
SELECT * FROM (
    SELECT customer_id, SUM(amount) AS total FROM Orders GROUP BY customer_id
) t WHERE total > 10000;

-- Equivalent CTE (easier to read)
WITH CustomerTotals AS (
    SELECT customer_id, SUM(amount) AS total FROM Orders GROUP BY customer_id
)
SELECT * FROM CustomerTotals WHERE total > 10000;

-- 48. Recursive CTE for reporting chain
WITH RECURSIVE ReportingChain AS (
    -- Base case: start with the employee
    SELECT emp_id, emp_name, manager_id, 1 AS level
    FROM Employees
    WHERE emp_id = 7  -- Starting with Frank (HR Intern)
    
    UNION ALL
    
    -- Recursive case: go up the chain
    SELECT e.emp_id, e.emp_name, e.manager_id, rc.level + 1
    FROM Employees e
    JOIN ReportingChain rc ON e.emp_id = rc.manager_id
)
SELECT * FROM ReportingChain ORDER BY level DESC;

-- 49. Temporary table using CTE (syntax varies by DBMS)
-- PostgreSQL example:
CREATE TEMP TABLE TopCustomers AS
WITH RegionalTotals AS (
    SELECT 
        c.customer_id,
        c.region,
        SUM(o.amount) AS total_spent
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.region
),
RankedCustomers AS (
    SELECT 
        customer_id,
        region,
        total_spent,
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY total_spent DESC) AS region_rank
    FROM RegionalTotals
)
SELECT * FROM RankedCustomers WHERE region_rank <= 5;

-- 50. Combined CTE + window function for customer ranking
WITH CustomerTotals AS (
    SELECT 
        customer_id,
        SUM(amount) AS total_orders,
        COUNT(*) AS order_count
    FROM Orders
    GROUP BY customer_id
)
SELECT 
    customer_id,
    total_orders,
    order_count,
    RANK() OVER (ORDER BY total_orders DESC) AS spending_rank,
    DENSE_RANK() OVER (ORDER BY order_count DESC) AS frequency_rank
FROM CustomerTotals
ORDER BY spending_rank;



/* SQL Mini Projects - Complete Collection */

--------------------------------------------------
-- 1. Organizational Chart Reporting System
--------------------------------------------------
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    manager_id INT,
    department VARCHAR(50),
    position VARCHAR(50),
    FOREIGN KEY (manager_id) REFERENCES Employees(emp_id)
);

INSERT INTO Employees VALUES
(1, 'John CEO', NULL, 'Executive', 'CEO'),
(2, 'Alice HR', 1, 'HR', 'Manager'),
(3, 'Bob IT', 1, 'IT', 'Manager'),
(4, 'Carol HR', 2, 'HR', 'Specialist'),
(5, 'Dave IT', 3, 'IT', 'Developer'),
(6, 'Eve IT', 3, 'IT', 'Developer'),
(7, 'Frank HR', 2, 'HR', 'Assistant');

CREATE VIEW OrgHierarchyView AS
WITH RECURSIVE OrgChart AS (
    SELECT emp_id, emp_name, manager_id, department, position, 1 AS level
    FROM Employees WHERE manager_id IS NULL
    UNION ALL
    SELECT e.emp_id, e.emp_name, e.manager_id, e.department, e.position, o.level + 1
    FROM Employees e JOIN OrgChart o ON e.manager_id = o.emp_id
)
SELECT 
    e.emp_id, e.emp_name, e.position, e.department,
    m.emp_name AS manager_name,
    o.level AS hierarchy_level
FROM Employees e
LEFT JOIN Employees m ON e.manager_id = m.emp_id
JOIN OrgChart o ON e.emp_id = o.emp_id;

--------------------------------------------------
-- 2. Salary Ranking Dashboard
--------------------------------------------------
CREATE TABLE EmployeeSalaries (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

INSERT INTO EmployeeSalaries VALUES
(1, 'John CEO', 'Executive', 150000),
(2, 'Alice HR', 'HR', 90000),
(3, 'Bob IT', 'IT', 110000),
(4, 'Carol HR', 'HR', 75000),
(5, 'Dave IT', 'IT', 95000),
(6, 'Eve IT', 'IT', 95000),
(7, 'Frank HR', 'HR', 60000);

SELECT 
    emp_id, emp_name, department, salary,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_row_rank,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_rank,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_dense_rank,
    LAG(salary, 1) OVER (PARTITION BY department ORDER BY salary DESC) AS prev_salary,
    LEAD(salary, 1) OVER (PARTITION BY department ORDER BY salary DESC) AS next_salary,
    salary - LAG(salary, 1) OVER (PARTITION BY department ORDER BY salary DESC) AS diff_from_prev
FROM EmployeeSalaries;

--------------------------------------------------
-- 3. Customer Order Recency Report
--------------------------------------------------
CREATE TABLE CustomerOrders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2)
);

INSERT INTO CustomerOrders VALUES
(1, 101, '2023-01-10', 150.00),
(2, 101, '2023-02-15', 200.00),
(3, 102, '2023-01-05', 75.50),
(4, 103, '2023-03-20', 300.00),
(5, 101, '2023-04-01', 180.00),
(6, 102, '2023-05-12', 95.00),
(7, 103, '2023-04-15', 250.00);

WITH OrderSequence AS (
    SELECT 
        customer_id, order_date, amount,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_date,
        LEAD(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS next_order_date
    FROM CustomerOrders
)
SELECT 
    customer_id, order_date, amount,
    prev_order_date,
    DATEDIFF(day, prev_order_date, order_date) AS days_since_last_order,
    next_order_date,
    DATEDIFF(day, order_date, next_order_date) AS days_until_next_order
FROM OrderSequence
WHERE DATEDIFF(day, prev_order_date, order_date) > 30 OR prev_order_date IS NULL;

--------------------------------------------------
-- 4. Product Category Tree Visualizer
--------------------------------------------------
CREATE TABLE ProductCategories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100),
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES ProductCategories(category_id)
);

INSERT INTO ProductCategories VALUES
(1, 'Electronics', NULL),
(2, 'Computers', 1),
(3, 'Laptops', 2),
(4, 'Tablets', 2),
(5, 'Clothing', NULL),
(6, 'Men', 5),
(7, 'Women', 5),
(8, 'Gaming Laptops', 3);

WITH RECURSIVE CategoryTree AS (
    SELECT category_id, category_name, parent_id, 1 AS level, CAST(category_name AS VARCHAR(500)) AS path
    FROM ProductCategories WHERE parent_id IS NULL
    UNION ALL
    SELECT c.category_id, c.category_name, c.parent_id, ct.level + 1, 
           CONCAT(ct.path, ' > ', c.category_name) AS path
    FROM ProductCategories c
    JOIN CategoryTree ct ON c.parent_id = ct.category_id
)
SELECT category_id, category_name, parent_id, level, path
FROM CategoryTree
ORDER BY path;

--------------------------------------------------
-- 5. Employee Promotion Tracker
--------------------------------------------------
CREATE TABLE EmployeeHistory (
    record_id INT PRIMARY KEY,
    emp_id INT,
    position VARCHAR(50),
    salary DECIMAL(10,2),
    effective_date DATE,
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

INSERT INTO EmployeeHistory VALUES
(1, 5, 'Junior Developer', 60000, '2021-01-15'),
(2, 5, 'Developer', 75000, '2021-07-15'),
(3, 5, 'Developer', 80000, '2022-01-15'),
(4, 5, 'Senior Developer', 95000, '2022-09-15'),
(5, 4, 'HR Assistant', 50000, '2021-03-10'),
(6, 4, 'HR Specialist', 65000, '2022-03-10'),
(7, 4, 'HR Specialist', 75000, '2023-01-10');

WITH CurrentYearPromotions AS (
    SELECT 
        emp_id, position, salary, effective_date,
        LAG(position) OVER (PARTITION BY emp_id ORDER BY effective_date) AS prev_position,
        LAG(salary) OVER (PARTITION BY emp_id ORDER BY effective_date) AS prev_salary
    FROM EmployeeHistory
    WHERE effective_date >= DATEADD(year, -1, GETDATE())
)
SELECT 
    e.emp_name, e.department,
    c.position, c.salary, c.effective_date,
    c.prev_position, c.prev_salary,
    CASE WHEN c.position <> c.prev_position THEN 'PROMOTION'
         WHEN c.salary > c.prev_salary THEN 'RAISE'
         ELSE 'NO CHANGE' END AS change_type
FROM CurrentYearPromotions c
JOIN Employees e ON c.emp_id = e.emp_id
WHERE c.position <> c.prev_position OR c.salary > c.prev_salary;

--------------------------------------------------
-- 6. Customer Segmentation System
--------------------------------------------------
WITH CustomerSpend AS (
    SELECT 
        customer_id,
        SUM(amount) AS total_spend,
        COUNT(*) AS order_count
    FROM CustomerOrders
    GROUP BY customer_id
),
CustomerQuartiles AS (
    SELECT 
        customer_id, total_spend, order_count,
        NTILE(4) OVER (ORDER BY total_spend DESC) AS spend_quartile
    FROM CustomerSpend
)
SELECT 
    customer_id, total_spend, order_count,
    CASE spend_quartile
        WHEN 1 THEN 'Platinum'
        WHEN 2 THEN 'Gold'
        WHEN 3 THEN 'Silver'
        WHEN 4 THEN 'Bronze'
    END AS customer_segment
FROM CustomerQuartiles
ORDER BY total_spend DESC;

CREATE VIEW CustomerSegments AS
WITH CustomerSpend AS (
    SELECT customer_id, SUM(amount) AS total_spend
    FROM CustomerOrders
    GROUP BY customer_id
)
SELECT 
    customer_id, total_spend,
    CASE 
        WHEN total_spend >= (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_spend) FROM CustomerSpend) THEN 'Platinum'
        WHEN total_spend >= (SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_spend) FROM CustomerSpend) THEN 'Gold'
        WHEN total_spend >= (SELECT PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_spend) FROM CustomerSpend) THEN 'Silver'
        ELSE 'Bronze'
    END AS segment
FROM CustomerSpend;

--------------------------------------------------
-- 7. Salesperson Hierarchy and Performance Tracker
--------------------------------------------------
CREATE TABLE SalesTeam (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    manager_id INT,
    region VARCHAR(50),
    FOREIGN KEY (manager_id) REFERENCES SalesTeam(emp_id)
);

CREATE TABLE SalesRecords (
    sale_id INT PRIMARY KEY,
    emp_id INT,
    sale_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (emp_id) REFERENCES SalesTeam(emp_id)
);

INSERT INTO SalesTeam VALUES
(101, 'Sarah VP', NULL, 'National'),
(102, 'Mike Director', 101, 'West'),
(103, 'Lisa Director', 101, 'East'),
(104, 'John Manager', 102, 'West'),
(105, 'Emily Manager', 103, 'East'),
(106, 'David Rep', 104, 'West'),
(107, 'Jessica Rep', 105, 'East');

INSERT INTO SalesRecords VALUES
(1, 106, '2023-01-15', 5000),
(2, 107, '2023-01-20', 4500),
(3, 106, '2023-02-10', 7500),
(4, 107, '2023-02-15', 6000),
(5, 104, '2023-03-05', 12000),
(6, 105, '2023-03-10', 15000),
(7, 101, '2023-04-01', 30000);

WITH RECURSIVE SalesHierarchy AS (
    SELECT emp_id, emp_name, manager_id, region, 1 AS level
    FROM SalesTeam WHERE manager_id IS NULL
    UNION ALL
    SELECT s.emp_id, s.emp_name, s.manager_id, s.region, h.level + 1
    FROM SalesTeam s JOIN SalesHierarchy h ON s.manager_id = h.emp_id
),
SalesPerformance AS (
    SELECT 
        st.emp_id, st.emp_name, st.region, sh.level,
        SUM(sr.amount) AS total_sales,
        COUNT(sr.sale_id) AS sale_count
    FROM SalesTeam st
    LEFT JOIN SalesRecords sr ON st.emp_id = sr.emp_id
    JOIN SalesHierarchy sh ON st.emp_id = sh.emp_id
    GROUP BY st.emp_id, st.emp_name, st.region, sh.level
)
SELECT 
    emp_id, emp_name, region, level, total_sales, sale_count,
    SUM(total_sales) OVER (PARTITION BY region) AS region_total,
    RANK() OVER (PARTITION BY region ORDER BY total_sales DESC) AS region_rank,
    total_sales / SUM(total_sales) OVER (PARTITION BY region) * 100 AS region_percentage
FROM SalesPerformance
ORDER BY region, level, total_sales DESC;

--------------------------------------------------
-- 8. Finance Department Budget Tracker
--------------------------------------------------
CREATE TABLE DepartmentBudgets (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100),
    budget_2023 DECIMAL(12,2),
    budget_2024 DECIMAL(12,2)
);

INSERT INTO DepartmentBudgets VALUES
(1, 'Marketing', 500000, 550000),
(2, 'R&D', 1200000, 1300000),
(3, 'IT', 800000, 900000),
(4, 'HR', 300000, 320000),
(5, 'Operations', 1500000, 1600000);

WITH BudgetAnalysis AS (
    SELECT 
        dept_id, dept_name, budget_2024,
        RANK() OVER (ORDER BY budget_2024 DESC) AS budget_rank,
        FIRST_VALUE(budget_2024) OVER (ORDER BY budget_2024 DESC) AS top_budget,
        budget_2024 - FIRST_VALUE(budget_2024) OVER (ORDER BY budget_2024 DESC) AS diff_from_top,
        (budget_2024 - budget_2023) / budget_2023 * 100 AS pct_change
    FROM DepartmentBudgets
)
SELECT 
    dept_id, dept_name, budget_2024, budget_rank,
    top_budget, diff_from_top,
    CONCAT(ROUND(pct_change, 2), '%') AS budget_change
FROM BudgetAnalysis
WHERE budget_2024 > 400000
ORDER BY budget_rank;

--------------------------------------------------
-- 9. Daily Transaction Trend Analyzer
--------------------------------------------------
CREATE TABLE DailyTransactions (
    transaction_date DATE PRIMARY KEY,
    transaction_count INT,
    total_amount DECIMAL(12,2)
);

-- Insert sample data for 60 days
INSERT INTO DailyTransactions
SELECT 
    DATEADD(day, number, '2023-01-01') AS transaction_date,
    ABS(CHECKSUM(NEWID())) % 100 + 50 AS transaction_count,
    ABS(CHECKSUM(NEWID())) % 50000 + 100000 AS total_amount
FROM master.dbo.spt_values
WHERE type = 'P' AND number < 60;

WITH MovingAverages AS (
    SELECT 
        transaction_date,
        transaction_count,
        total_amount,
        AVG(total_amount) OVER (ORDER BY transaction_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS weekly_avg,
        AVG(total_amount) OVER (ORDER BY transaction_date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS monthly_avg
    FROM DailyTransactions
)
SELECT 
    transaction_date,
    transaction_count,
    total_amount,
    weekly_avg,
    monthly_avg,
    CASE WHEN total_amount > weekly_avg THEN 'Above Weekly Avg'
         ELSE 'Below Weekly Avg' END AS weekly_comparison,
    CASE WHEN total_amount > monthly_avg THEN 'Above Monthly Avg'
         ELSE 'Below Monthly Avg' END AS monthly_comparison
FROM MovingAverages
WHERE transaction_date >= DATEADD(day, -30, GETDATE())
ORDER BY transaction_date;

--------------------------------------------------
-- 10. Online Learning Progress Report
--------------------------------------------------
CREATE TABLE StudentScores (
    student_id INT,
    quiz_date DATE,
    quiz_name VARCHAR(100),
    score INT,
    PRIMARY KEY (student_id, quiz_date, quiz_name)
);

INSERT INTO StudentScores VALUES
(1, '2023-01-10', 'Math Basics', 75),
(1, '2023-01-24', 'Math Intermediate', 82),
(1, '2023-02-07', 'Math Advanced', 78),
(2, '2023-01-12', 'Math Basics', 88),
(2, '2023-01-26', 'Math Intermediate', 85),
(2, '2023-02-09', 'Math Advanced', 92),
(3, '2023-01-15', 'Math Basics', 65),
(3, '2023-01-29', 'Math Intermediate', 70),
(3, '2023-02-12', 'Math Advanced', 68);

WITH ScoreChanges AS (
    SELECT 
        student_id, quiz_date, quiz_name, score,
        LAG(score) OVER (PARTITION BY student_id ORDER BY quiz_date) AS prev_score,
        LAG(quiz_date) OVER (PARTITION BY student_id ORDER BY quiz_date) AS prev_date
    FROM StudentScores
),
StudentProgress AS (
    SELECT 
        student_id,
        quiz_name,
        quiz_date,
        score,
        prev_score,
        score - prev_score AS score_change,
        DATEDIFF(day, prev_date, quiz_date) AS days_between_quizzes,
        CASE 
            WHEN score > prev_score THEN 'Improving'
            WHEN score = prev_score THEN 'Stable'
            WHEN score < prev_score THEN 'Declining'
            ELSE 'First Attempt' 
        END AS progress_status
    FROM ScoreChanges
)
SELECT 
    student_id,
    quiz_name,
    quiz_date,
    score,
    prev_score,
    score_change,
    days_between_quizzes,
    progress_status,
    AVG(score_change) OVER (PARTITION BY student_id) AS avg_score_change
FROM StudentProgress
ORDER BY student_id, quiz_date;

--------------------------------------------------
-- 11. E-commerce Purchase Funnel Report
--------------------------------------------------
CREATE TABLE UserActivity (
    user_id INT,
    session_id INT,
    activity_date DATETIME,
    activity_type VARCHAR(50), -- view, cart, checkout, payment
    product_id INT,
    PRIMARY KEY (user_id, session_id, activity_date)
);

INSERT INTO UserActivity VALUES
(1001, 1, '2023-01-10 10:15:00', 'view', 501),
(1001, 1, '2023-01-10 10:18:00', 'cart', 501),
(1001, 1, '2023-01-10 10:22:00', 'checkout', 501),
(1002, 2, '2023-01-11 11:30:00', 'view', 502),
(1002, 2, '2023-01-11 11:35:00', 'cart', 502),
(1003, 3, '2023-01-12 09:45:00', 'view', 503),
(1003, 3, '2023-01-12 09:50:00', 'cart', 503),
(1003, 3, '2023-01-12 09:55:00', 'checkout', 503),
(1003, 3, '2023-01-12 10:00:00', 'payment', 503),
(1004, 4, '2023-01-13 14:20:00', 'view', 504);

WITH FunnelStages AS (
    SELECT 
        user_id,
        MAX(CASE WHEN activity_type = 'view' THEN 1 ELSE 0 END) AS viewed,
        MAX(CASE WHEN activity_type = 'cart' THEN 1 ELSE 0 END) AS carted,
        MAX(CASE WHEN activity_type = 'checkout' THEN 1 ELSE 0 END) AS checkout,
        MAX(CASE WHEN activity_type = 'payment' THEN 1 ELSE 0 END) AS paid
    FROM UserActivity
    GROUP BY user_id
),
FunnelSummary AS (
    SELECT 
        'Viewed' AS stage,
        COUNT(*) AS users,
        100.0 * COUNT(*) / COUNT(*) AS percentage
    FROM FunnelStages
    UNION ALL
    SELECT 
        'Added to Cart',
        SUM(carted),
        100.0 * SUM(carted) / COUNT(*)
    FROM FunnelStages
    UNION ALL
    SELECT 
        'Checkout Started',
        SUM(checkout),
        100.0 * SUM(checkout) / COUNT(*)
    FROM FunnelStages
    UNION ALL
    SELECT 
        'Payment Completed',
        SUM(paid),
        100.0 * SUM(paid) / COUNT(*)
    FROM FunnelStages
)
SELECT 
    stage,
    users,
    ROUND(percentage, 1) AS percentage,
    ROUND(100.0 * users / FIRST_VALUE(users) OVER (ORDER BY CASE stage 
        WHEN 'Viewed' THEN 1
        WHEN 'Added to Cart' THEN 2
        WHEN 'Checkout Started' THEN 3
        WHEN 'Payment Completed' THEN 4
    END), 1) AS conversion_rate
FROM FunnelSummary
ORDER BY CASE stage 
    WHEN 'Viewed' THEN 1
    WHEN 'Added to Cart' THEN 2
    WHEN 'Checkout Started' THEN 3
    WHEN 'Payment Completed' THEN 4
END;

CREATE VIEW MarketingFunnel AS
SELECT * FROM FunnelSummary;

--------------------------------------------------
-- 12. Warehouse Inventory Snapshot System
--------------------------------------------------
CREATE TABLE Inventory (
    product_id INT,
    snapshot_date DATE,
    quantity INT,
    PRIMARY KEY (product_id, snapshot_date)
);

-- Insert sample data for 30 days
INSERT INTO Inventory
SELECT 
    p.product_id,
    DATEADD(day, n.number, '2023-01-01') AS snapshot_date,
    ABS(CHECKSUM(NEWID())) % 100 + 50 AS quantity
FROM (VALUES (501), (502), (503), (504), (505)) AS p(product_id)
CROSS JOIN master.dbo.spt_values n
WHERE n.type = 'P' AND n.number < 30;

WITH InventoryChanges AS (
    SELECT 
        product_id,
        snapshot_date,
        quantity,
        LAG(quantity) OVER (PARTITION BY product_id ORDER BY snapshot_date) AS prev_quantity,
        LAG(snapshot_date) OVER (PARTITION BY product_id ORDER BY snapshot_date) AS prev_date
    FROM Inventory
),
DailyMovement AS (
    SELECT 
        product_id,
        snapshot_date,
        quantity,
        prev_quantity,
        quantity - prev_quantity AS daily_change,
        DATEDIFF(day, prev_date, snapshot_date) AS days_since_last
    FROM InventoryChanges
    WHERE prev_quantity IS NOT NULL
),
HighMovement AS (
    SELECT 
        product_id,
        AVG(ABS(daily_change)) AS avg_daily_change,
        SUM(CASE WHEN ABS(daily_change) > 20 THEN 1 ELSE 0 END) AS high_change_days
    FROM DailyMovement
    GROUP BY product_id
)
SELECT 
    d.product_id,
    d.snapshot_date,
    d.quantity,
    d.daily_change,
    h.avg_daily_change,
    h.high_change_days,
    CASE WHEN ABS(d.daily_change) > 20 THEN 'High Movement' ELSE 'Normal' END AS movement_flag,
    AVG(d.quantity) OVER (PARTITION BY d.product_id ORDER BY d.snapshot_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS weekly_avg
FROM DailyMovement d
JOIN HighMovement h ON d.product_id = h.product_id
ORDER BY d.product_id, d.snapshot_date;

--------------------------------------------------
-- 13. Student Class Hierarchy Tracker
--------------------------------------------------
CREATE TABLE StudentMentors (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    mentor_id INT,
    class_level VARCHAR(50),
    FOREIGN KEY (mentor_id) REFERENCES StudentMentors(student_id)
);

INSERT INTO StudentMentors VALUES
(1, 'Dr. Smith', NULL, 'Professor'),
(2, 'Jane Doe', 1, 'PhD'),
(3, 'John Lee', 1, 'PhD'),
(4, 'Alice Chen', 2, 'Masters'),
(5, 'Bob Wilson', 2, 'Masters'),
(6, 'Carol Davis', 3, 'Masters'),
(7, 'Eve Johnson', 3, 'Masters');

WITH RECURSIVE MentorHierarchy AS (
    SELECT 
        student_id, student_name, mentor_id, class_level, 
        1 AS level, 
        CAST(student_name AS VARCHAR(500)) AS path
    FROM StudentMentors
    WHERE mentor_id IS NULL
    
    UNION ALL
    
    SELECT 
        s.student_id, s.student_name, s.mentor_id, s.class_level,
        m.level + 1,
        CAST(m.path + ' > ' + s.student_name AS VARCHAR(500))
    FROM StudentMentors s
    JOIN MentorHierarchy m ON s.mentor_id = m.student_id
)
SELECT 
    student_id, student_name, class_level, level, path,
    CASE 
        WHEN level = 1 THEN 'Lead Mentor'
        WHEN level = 2 THEN 'Senior Mentor'
        WHEN level = 3 THEN 'Mentor'
        ELSE 'Student'
    END AS role
FROM MentorHierarchy
ORDER BY path;

CREATE VIEW MentorTeams AS
SELECT 
    m.student_name AS mentor_name,
    COUNT(s.student_id) AS team_size,
    STRING_AGG(s.student_name, ', ') AS team_members
FROM StudentMentors m
LEFT JOIN StudentMentors s ON m.student_id = s.mentor_id
GROUP BY m.student_id, m.student_name
HAVING COUNT(s.student_id) > 0;

--------------------------------------------------
-- 14. Job Application Status Pipeline
--------------------------------------------------
CREATE TABLE JobApplications (
    application_id INT PRIMARY KEY,
    candidate_id INT,
    status VARCHAR(50),
    status_date DATETIME,
    position_id INT
);

INSERT INTO JobApplications VALUES
(1, 1001, 'Applied', '2023-01-10 10:00:00', 501),
(1, 1001, 'HR Screen', '2023-01-12 14:30:00', 501),
(1, 1001, 'Tech Interview', '2023-01-18 09:00:00', 501),
(1, 1001, 'Offer', '2023-01-25 16:45:00', 501),
(2, 1002, 'Applied', '2023-01-11 11:30:00', 502),
(2, 1002, 'HR Screen', '2023-01-13 15:00:00', 502),
(3, 1003, 'Applied', '2023-01-12 09:45:00', 503),
(3, 1003, 'HR Screen', '2023-01-14 10:30:00', 503),
(3, 1003, 'Tech Interview', '2023-01-20 10:00:00', 503),
(4, 1004, 'Applied', '2023-01-15 14:20:00', 501);

WITH ApplicationTimeline AS (
    SELECT 
        candidate_id, position_id, status, status_date,
        LAG(status) OVER (PARTITION BY candidate_id, position_id ORDER BY status_date) AS prev_status,
        LAG(status_date) OVER (PARTITION BY candidate_id, position_id ORDER BY status_date) AS prev_status_date,
        LEAD(status) OVER (PARTITION BY candidate_id, position_id ORDER BY status_date) AS next_status,
        LEAD(status_date) OVER (PARTITION BY candidate_id, position_id ORDER BY status_date) AS next_status_date
    FROM JobApplications
),
StalledApplications AS (
    SELECT 
        candidate_id, position_id, status, status_date,
        DATEDIFF(day, status_date, GETDATE()) AS days_in_current_status,
        next_status,
        DATEDIFF(day, status_date, next_status_date) AS days_to_next_status,
        CASE 
            WHEN next_status IS NULL AND status NOT IN ('Rejected', 'Offer Accepted') THEN 'Final Stage'
            WHEN DATEDIFF(day, status_date, GETDATE()) > 7 AND next_status IS NULL THEN 'Stalled'
            WHEN DATEDIFF(day, status_date, GETDATE()) > 14 THEN 'Stalled'
            ELSE 'Active'
        END AS pipeline_status
    FROM ApplicationTimeline
    WHERE status NOT IN ('Rejected', 'Offer Accepted')
)
SELECT 
    candidate_id, position_id, status, status_date,
    days_in_current_status,
    next_status,
    pipeline_status
FROM StalledApplications
WHERE pipeline_status = 'Stalled'
ORDER BY days_in_current_status DESC;

--------------------------------------------------
-- 15. IT Support Ticket Resolution Report
--------------------------------------------------
CREATE TABLE SupportTickets (
    ticket_id INT PRIMARY KEY,
    user_id INT,
    staff_id INT,
    opened_date DATETIME,
    resolved_date DATETIME,
    status VARCHAR(50),
    priority VARCHAR(20)
);

INSERT INTO SupportTickets VALUES
(1, 101, 201, '2023-01-10 10:00:00', '2023-01-10 11:30:00', 'Resolved', 'High'),
(2, 102, 202, '2023-01-11 09:30:00', '2023-01-11 10:45:00', 'Resolved', 'Medium'),
(3, 103, 201, '2023-01-12 14:15:00', '2023-01-13 10:00:00', 'Resolved', 'High'),
(4, 101, 203, '2023-01-15 11:00:00', NULL, 'Open', 'Low'),
(5, 104, 202, '2023-01-16 13:45:00', '2023-01-16 15:30:00', 'Resolved', 'Medium'),
(6, 105, 203, '2023-01-17 16:20:00', NULL, 'Open', 'High'),
(7, 102, 201, '2023-01-18 10:30:00', '2023-01-18 11:15:00', 'Resolved', 'Low');

WITH TicketMetrics AS (
    SELECT 
        ticket_id, user_id, staff_id, priority, status,
        opened_date, resolved_date,
        DATEDIFF(hour, opened_date, resolved_date) AS resolution_hours,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY opened_date) AS user_ticket_seq
    FROM SupportTickets
),
StaffPerformance AS (
    SELECT 
        staff_id,
        COUNT(*) AS total_tickets,
        SUM(CASE WHEN status = 'Resolved' THEN 1 ELSE 0 END) AS resolved_tickets,
        AVG(CASE WHEN status = 'Resolved' THEN DATEDIFF(hour, opened_date, resolved_date) ELSE NULL END) AS avg_resolution_hours,
        SUM(CASE WHEN priority = 'High' THEN 1 ELSE 0 END) AS high_priority_tickets
    FROM SupportTickets
    GROUP BY staff_id
),
OverdueTickets AS (
    SELECT *
    FROM SupportTickets
    WHERE status = 'Open' 
    AND DATEDIFF(hour, opened_date, GETDATE()) > 
        CASE priority
            WHEN 'High' THEN 24
            WHEN 'Medium' THEN 48
            WHEN 'Low' THEN 72
        END
)
SELECT 
    t.ticket_id, t.user_id, t.staff_id, t.priority, t.status,
    t.opened_date, t.resolved_date,
    t.resolution_hours,
    s.total_tickets, s.resolved_tickets, s.avg_resolution_hours,
    CASE 
        WHEN t.status = 'Open' AND o.ticket_id IS NOT NULL THEN 'Overdue'
        WHEN t.status = 'Resolved' AND t.resolution_hours <= 
            CASE t.priority
                WHEN 'High' THEN 4
                WHEN 'Medium' THEN 8
                WHEN 'Low' THEN 24
            END THEN 'Within SLA'
        WHEN t.status = 'Resolved' THEN 'Breached SLA'
        ELSE 'Pending'
    END AS sla_status
FROM TicketMetrics t
JOIN StaffPerformance s ON t.staff_id = s.staff_id
LEFT JOIN OverdueTickets o ON t.ticket_id = o.ticket_id
ORDER BY 
    CASE WHEN t.status = 'Open' THEN 0 ELSE 1 END,
    CASE t.priority
        WHEN 'High' THEN 0
        WHEN 'Medium' THEN 1
        WHEN 'Low' THEN 2
    END,
    t.opened_date;

--------------------------------------------------
-- 16. Banking Transaction Audit
--------------------------------------------------
CREATE TABLE AccountBalances (
    account_id INT,
    transaction_date DATE,
    transaction_id INT,
    amount DECIMAL(12,2),
    balance DECIMAL(12,2),
    PRIMARY KEY (account_id, transaction_date, transaction_id)
);

INSERT INTO AccountBalances VALUES
(1001, '2023-01-01', 1, 0.00, 5000.00),
(1001, '2023-01-05', 2, -500.00, 4500.00),
(1001, '2023-01-10', 3, 2000.00, 6500.00),
(1001, '2023-01-15', 4, -3000.00, 3500.00),
(1001, '2023-01-20', 5, -4000.00, -500.00),
(1002, '2023-01-01', 1, 0.00, 10000.00),
(1002, '2023-01-08', 2, -2000.00, 8000.00),
(1002, '2023-01-12', 3, 5000.00, 13000.00),
(1003, '2023-01-01', 1, 0.00, 7500.00),
(1003, '2023-01-07', 2, -10000.00, -2500.00),
(1003, '2023-01-14', 3, 3000.00, 500.00);

WITH BalanceChanges AS (
    SELECT 
        account_id, transaction_date, transaction_id, amount, balance,
        LAG(balance) OVER (PARTITION BY account_id ORDER BY transaction_date) AS prev_balance,
        FIRST_VALUE(balance) OVER (PARTITION BY account_id ORDER BY transaction_date) AS opening_balance,
        (balance - LAG(balance) OVER (PARTITION BY account_id ORDER BY transaction_date)) / 
        NULLIF(LAG(balance) OVER (PARTITION BY account_id ORDER BY transaction_date), 0) * 100 AS pct_change
    FROM AccountBalances
),
AbnormalActivity AS (
    SELECT 
        account_id, transaction_date, transaction_id, amount, balance,
        prev_balance,
        ROUND(pct_change, 2) AS pct_change,
        CASE 
            WHEN ABS(pct_change) > 50 THEN 'Large Change'
            WHEN balance < 0 THEN 'Overdraft'
            WHEN pct_change IS NULL THEN 'Opening Balance'
            ELSE 'Normal'
        END AS activity_flag
    FROM BalanceChanges
)
SELECT 
    account_id, transaction_date, transaction_id, amount, balance,
    prev_balance,
    pct_change,
    activity_flag,
    CASE 
        WHEN activity_flag IN ('Large Change', 'Overdraft') THEN 'Review Required'
        ELSE 'Normal'
    END AS audit_status
FROM AbnormalActivity
WHERE activity_flag IN ('Large Change', 'Overdraft')
ORDER BY account_id, transaction_date;

--------------------------------------------------
-- 17. Call Center Agent Performance Report
--------------------------------------------------
CREATE TABLE CallLogs (
    call_id INT PRIMARY KEY,
    agent_id INT,
    call_start DATETIME,
    call_end DATETIME,
    call_type VARCHAR(50),
    satisfaction_score INT
);

-- Insert sample data for 30 days
INSERT INTO CallLogs
SELECT 
    ROW_NUMBER() OVER (ORDER BY NEWID()) AS call_id,
    agent_id,
    DATEADD(second, ABS(CHECKSUM(NEWID())) % 86400, DATEADD(day, n.number, '2023-01-01')) AS call_start,
    DATEADD(second, ABS(CHECKSUM(NEWID())) % 600 + 120, DATEADD(second, ABS(CHECKSUM(NEWID())) % 86400, DATEADD(day, n.number, '2023-01-01'))) AS call_end,
    CASE ABS(CHECKSUM(NEWID())) % 4
        WHEN 0 THEN 'Sales'
        WHEN 1 THEN 'Support'
        WHEN 2 THEN 'Complaint'
        WHEN 3 THEN 'Inquiry'
    END AS call_type,
    ABS(CHECKSUM(NEWID())) % 5 + 1 AS satisfaction_score
FROM (VALUES (101), (102), (103), (104), (105)) AS a(agent_id)
CROSS JOIN master.dbo.spt_values n
WHERE n.type = 'P' AND n.number < 30;

WITH AgentPerformance AS (
    SELECT 
        agent_id,
        COUNT(*) AS total_calls,
        AVG(DATEDIFF(second, call_start, call_end)) AS avg_call_duration,
        AVG(satisfaction_score) AS avg_satisfaction,
        SUM(CASE WHEN call_type = 'Sales' THEN 1 ELSE 0 END) AS sales_calls,
        SUM(CASE WHEN call_type = 'Complaint' THEN 1 ELSE 0 END) AS complaint_calls
    FROM CallLogs
    GROUP BY agent_id
),
CallGaps AS (
    SELECT 
        agent_id,
        call_start,
        call_end,
        DATEDIFF(minute, 
            LAG(call_end) OVER (PARTITION BY agent_id ORDER BY call_start),
            call_start) AS minutes_since_last_call
    FROM CallLogs
),
ConsistentAgents AS (
    SELECT 
        agent_id,
        AVG(minutes_since_last_call) AS avg_gap,
        COUNT(*) AS call_count
    FROM CallGaps
    WHERE minutes_since_last_call IS NOT NULL
    GROUP BY agent_id
    HAVING COUNT(*) > 20 AND AVG(minutes_since_last_call) < 30
)
SELECT 
    a.agent_id,
    a.total_calls,
    FORMAT(DATEADD(second, a.avg_call_duration, '00:00:00'), 'mm:ss') AS avg_call_time,
    a.avg_satisfaction,
    a.sales_calls,
    a.complaint_calls,
    c.avg_gap,
    RANK() OVER (ORDER BY a.total_calls DESC) AS call_volume_rank,
    RANK() OVER (ORDER BY a.avg_satisfaction DESC) AS satisfaction_rank,
    CASE 
        WHEN c.agent_id IS NOT NULL THEN 'Consistent Performer'
        WHEN a.total_calls > (SELECT AVG(total_calls) FROM AgentPerformance) AND 
             a.avg_satisfaction > (SELECT AVG(avg_satisfaction) FROM AgentPerformance) THEN 'High Performer'
        WHEN a.total_calls < (SELECT AVG(total_calls) FROM AgentPerformance) AND 
             a.avg_satisfaction < (SELECT AVG(avg_satisfaction) FROM AgentPerformance) THEN 'Needs Improvement'
        ELSE 'Average Performer'
    END AS performance_category
FROM AgentPerformance a
LEFT JOIN ConsistentAgents c ON a.agent_id = c.agent_id
ORDER BY a.total_calls DESC;

--------------------------------------------------
-- 18. Hospital Departmental Hierarchy & Load
--------------------------------------------------
CREATE TABLE HospitalStaff (
    staff_id INT PRIMARY KEY,
    staff_name VARCHAR(100),
    role VARCHAR(50),
    department VARCHAR(50),
    unit VARCHAR(50),
    supervisor_id INT,
    FOREIGN KEY (supervisor_id) REFERENCES HospitalStaff(staff_id)
);

CREATE TABLE PatientCases (
    case_id INT PRIMARY KEY,
    patient_id INT,
    attending_staff INT,
    admission_date DATE,
    discharge_date DATE,
    diagnosis VARCHAR(100),
    FOREIGN KEY (attending_staff) REFERENCES HospitalStaff(staff_id)
);

INSERT INTO HospitalStaff VALUES
(1, 'Dr. Adams', 'Chief of Medicine', 'Medicine', NULL, NULL),
(2, 'Dr. Baker', 'Department Head', 'Cardiology', NULL, 1),
(3, 'Dr. Clark', 'Department Head', 'Oncology', NULL, 1),
(4, 'Dr. Davis', 'Unit Chief', 'Cardiology', 'ICU', 2),
(5, 'Dr. Evans', 'Attending Physician', 'Cardiology', 'ICU', 4),
(6, 'Dr. Foster', 'Attending Physician', 'Cardiology', 'General', 2),
(7, 'Dr. Green', 'Unit Chief', 'Oncology', 'Radiation', 3),
(8, 'Dr. Hill', 'Attending Physician', 'Oncology', 'Radiation', 7);

INSERT INTO PatientCases VALUES
(1, 1001, 5, '2023-01-10', '2023-01-15', 'Heart Failure'),
(2, 1002, 5, '2023-01-12', '2023-01-18', 'Arrhythmia'),
(3, 1003, 6, '2023-01-15', '2023-01-20', 'Angina'),
(4, 1004, 6, '2023-01-18', '2023-01-25', 'Hypertension'),
(5, 1005, 8, '2023-01-20', '2023-02-05', 'Lymphoma'),
(6, 1006, 8, '2023-01-22', '2023-02-10', 'Leukemia'),
(7, 1007, 8, '2023-01-25', '2023-02-15', 'Melanoma');

WITH RECURSIVE StaffHierarchy AS (
    SELECT 
        staff_id, staff_name, role, department, unit, supervisor_id, 
        1 AS level,
        CAST(staff_name AS VARCHAR(500)) AS hierarchy_path
    FROM HospitalStaff
    WHERE supervisor_id IS NULL
    
    UNION ALL
    
    SELECT 
        h.staff_id, h.staff_name, h.role, h.department, h.unit, h.supervisor_id,
        s.level + 1,
        CAST(s.hierarchy_path + ' > ' + h.staff_name AS VARCHAR(500))
    FROM HospitalStaff h
    JOIN StaffHierarchy s ON h.supervisor_id = s.staff_id
),
DepartmentWorkload AS (
    SELECT 
        h.department,
        h.unit,
        h.staff_id,
        h.staff_name,
        h.role,
        h.level,
        h.hierarchy_path,
        COUNT(p.case_id) AS case_count,
        SUM(DATEDIFF(day, p.admission_date, p.discharge_date)) AS total_patient_days
    FROM StaffHierarchy h
    LEFT JOIN PatientCases p ON h.staff_id = p.attending_staff
    GROUP BY 
        h.department, h.unit, h.staff_id, h.staff_name, h.role, h.level, h.hierarchy_path
)
SELECT 
    department,
    unit,
    staff_name,
    role,
    level,
    case_count,
    total_patient_days,
    CASE 
        WHEN level = 1 THEN 'Executive'
        WHEN level = 2 THEN 'Department'
        WHEN level = 3 THEN 'Unit'
        ELSE 'Staff'
    END AS staff_level,
    RANK() OVER (PARTITION BY department ORDER BY case_count DESC) AS dept_case_rank,
    RANK() OVER (PARTITION BY department ORDER BY total_patient_days DESC) AS dept_days_rank
FROM DepartmentWorkload
ORDER BY department, level, case_count DESC;

CREATE VIEW DepartmentalWorkloadView AS
WITH StaffHierarchy AS (
    SELECT 
        staff_id, staff_name, role, department, unit, supervisor_id, 
        1 AS level,
        CAST(staff_name AS VARCHAR(500)) AS hierarchy_path
    FROM HospitalStaff
    WHERE supervisor_id IS NULL
    
    UNION ALL
    
    SELECT 
        h.staff_id, h.staff_name, h.role, h.department, h.unit, h.supervisor_id,
        s.level + 1,
        CAST(s.hierarchy_path + ' > ' + h.staff_name AS VARCHAR(500))
    FROM HospitalStaff h
    JOIN StaffHierarchy s ON h.supervisor_id = s.staff_id
)
SELECT 
    h.department,
    h.unit,
    h.staff_name,
    h.role,
    h.level,
    COUNT(p.case_id) AS case_count,
    SUM(DATEDIFF(day, p.admission_date, p.discharge_date)) AS total_patient_days
FROM StaffHierarchy h
LEFT JOIN PatientCases p ON h.staff_id = p.attending_staff
GROUP BY 
    h.department, h.unit, h.staff_id, h.staff_name, h.role, h.level, h.hierarchy_path;

--------------------------------------------------
-- 19. Flight Connection Lookup System
--------------------------------------------------
CREATE TABLE Airports (
    airport_code CHAR(3) PRIMARY KEY,
    airport_name VARCHAR(100),
    city VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE Flights (
    flight_id INT PRIMARY KEY,
    origin_code CHAR(3),
    dest_code CHAR(3),
    airline VARCHAR(50),
    duration_minutes INT,
    FOREIGN KEY (origin_code) REFERENCES Airports(airport_code),
    FOREIGN KEY (dest_code) REFERENCES Airports(airport_code)
);

INSERT INTO Airports VALUES
('JFK', 'John F. Kennedy', 'New York', 'USA'),
('LAX', 'Los Angeles International', 'Los Angeles', 'USA'),
('ORD', 'O''Hare International', 'Chicago', 'USA'),
('DFW', 'Dallas/Fort Worth', 'Dallas', 'USA'),
('ATL', 'Hartsfield-Jackson', 'Atlanta', 'USA'),
('SFO', 'San Francisco International', 'San Francisco', 'USA'),
('DEN', 'Denver International', 'Denver', 'USA');

INSERT INTO Flights VALUES
(1, 'JFK', 'LAX', 'Delta', 360),
(2, 'JFK', 'ORD', 'American', 150),
(3, 'ORD', 'LAX', 'United', 240),
(4, 'JFK', 'ATL', 'Delta', 120),
(5, 'ATL', 'LAX', 'Delta', 270),
(6, 'JFK', 'DFW', 'American', 210),
(7, 'DFW', 'LAX', 'American', 180),
(8, 'JFK', 'DEN', 'United', 240),
(9, 'DEN', 'LAX', 'United', 150),
(10, 'ORD', 'DFW', 'American', 120),
(11, 'DFW', 'SFO', 'American', 210),
(12, 'SFO', 'LAX', 'United', 90);

WITH RECURSIVE FlightPaths AS (
    -- Direct flights
    SELECT 
        origin_code, 
        dest_code, 
        CAST(origin_code + '->' + dest_code AS VARCHAR(200)) AS path,
        1 AS connections,
        duration_minutes AS total_duration,
        airline AS airlines
    FROM Flights
    
    UNION ALL
    
    -- Connecting flights (1 connection)
    SELECT 
        fp.origin_code,
        f.dest_code,
        CAST(fp.path + '->' + f.dest_code AS VARCHAR(200)) AS path,
        2 AS connections,
        fp.total_duration + f.duration_minutes AS total_duration,
        fp.airlines + ',' + f.airline AS airlines
    FROM FlightPaths fp
    JOIN Flights f ON fp.dest_code = f.origin_code
    WHERE fp.connections = 1
    AND fp.origin_code <> f.dest_code  -- Prevent loops
    AND fp.path NOT LIKE '%' + f.dest_code + '%'  -- Prevent circular paths
    
    UNION ALL
    
    -- Connecting flights (2 connections)
    SELECT 
        fp.origin_code,
        f.dest_code,
        CAST(fp.path + '->' + f.dest_code AS VARCHAR(200)) AS path,
        3 AS connections,
        fp.total_duration + f.duration_minutes AS total_duration,
        fp.airlines + ',' + f.airline AS airlines
    FROM FlightPaths fp
    JOIN Flights f ON fp.dest_code = f.origin_code
    WHERE fp.connections = 2
    AND fp.origin_code <> f.dest_code
    AND fp.path NOT LIKE '%' + f.dest_code + '%'
)
SELECT 
    origin_code AS departure,
    dest_code AS arrival,
    path AS flight_path,
    connections,
    total_duration,
    airlines
FROM FlightPaths
WHERE origin_code = 'JFK' AND dest_code = 'LAX'
ORDER BY connections, total_duration;

--------------------------------------------------
-- 20. Project Task Dependency Tracker
--------------------------------------------------
CREATE TABLE ProjectTasks (
    task_id INT PRIMARY KEY,
    task_name VARCHAR(100),
    project_id INT,
    depends_on_task_id INT,
    estimated_hours INT,
    FOREIGN KEY (depends_on_task_id) REFERENCES ProjectTasks(task_id)
);

INSERT INTO ProjectTasks VALUES
(1, 'Requirements Gathering', 101, NULL, 20),
(2, 'System Design', 101, 1, 40),
(3, 'Database Setup', 101, 2, 15),
(4, 'Backend Development', 101, 2, 60),
(5, 'Frontend Development', 101, 2, 50),
(6, 'API Integration', 101, 4, 30),
(7, 'UI Integration', 101, 5, 25),
(8, 'System Testing', 101, 6, 20),
(9, 'System Testing', 101, 7, 20),
(10, 'User Acceptance Testing', 101, 8, 15),
(11, 'User Acceptance Testing', 101, 9, 15),
(12, 'Deployment', 101, 10, 10),
(13, 'Deployment', 101, 11, 10);

WITH RECURSIVE TaskDependencies AS (
    -- Base tasks (no dependencies)
    SELECT 
        task_id, task_name, project_id, depends_on_task_id, estimated_hours,
        1 AS level,
        CAST(task_name AS VARCHAR(1000)) AS task_path,
        CAST(task_id AS VARCHAR(100)) AS id_path
    FROM ProjectTasks
    WHERE depends_on_task_id IS NULL
    
    UNION ALL
    
    -- Dependent tasks
    SELECT 
        t.task_id, t.task_name, t.project_id, t.depends_on_task_id, t.estimated_hours,
        td.level + 1,
        CAST(td.task_path + ' > ' + t.task_name AS VARCHAR(1000)) AS task_path,
        CAST(td.id_path + ',' + CAST(t.task_id AS VARCHAR(10)) AS VARCHAR(100)) AS id_path
    FROM ProjectTasks t
    JOIN TaskDependencies td ON t.depends_on_task_id = td.task_id
),
TaskOrder AS (
    SELECT 
        task_id, task_name, project_id, level, task_path, id_path, estimated_hours,
        ROW_NUMBER() OVER (ORDER BY level, task_id) AS execution_order,
        SUM(estimated_hours) OVER (ORDER BY level, task_id) AS cumulative_hours
    FROM TaskDependencies
)
SELECT 
    task_id, task_name, project_id, level, 
    task_path, execution_order, estimated_hours, cumulative_hours,
    CASE 
        WHEN level = 1 THEN 'Phase 1: Initiation'
        WHEN level = 2 THEN 'Phase 2: Planning'
        WHEN level BETWEEN 3 AND 5 THEN 'Phase 3: Execution'
        WHEN level BETWEEN 6 AND 8 THEN 'Phase 4: Testing'
        ELSE 'Phase 5: Deployment'
    END AS project_phase
FROM TaskOrder
ORDER BY execution_order;