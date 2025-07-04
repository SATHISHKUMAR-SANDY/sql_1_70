

-- Task 1
SELECT employee_name, salary, (SELECT MAX(salary) FROM employees) AS highest_salary FROM employees;

-- Task 2
SELECT employee_name, salary, (SELECT COUNT(*) FROM employees) AS total_employees FROM employees;

-- Task 3
SELECT e.employee_name, e.salary, (SELECT MIN(salary) FROM employees WHERE department_id = e.department_id) AS min_dept_salary FROM employees e;

-- Task 4
SELECT product_name, price, (SELECT MAX(price) FROM products) AS highest_price FROM products;

-- Task 5
SELECT employee_name, salary, (SELECT MAX(salary) FROM employees) * 0.1 AS bonus FROM employees;

-- Task 6
SELECT d.department_name FROM departments d JOIN (SELECT department_id FROM employees GROUP BY department_id HAVING AVG(salary) > 10000) dept_avg ON d.department_id = dept_avg.department_id;

-- Task 7
SELECT department_id, avg_salary FROM (SELECT department_id, AVG(salary) AS avg_salary FROM employees GROUP BY department_id) dept_avg WHERE avg_salary > (SELECT AVG(salary) FROM employees);

-- Task 8
SELECT e.employee_name, d.department_name FROM (SELECT employee_id, employee_name, department_id FROM employees ORDER BY salary DESC LIMIT 3) e JOIN departments d ON e.department_id = d.department_id;

-- Task 9
SELECT d.department_name, dept_stats.total_salary FROM departments d JOIN (SELECT department_id, SUM(salary) AS total_salary FROM employees GROUP BY department_id HAVING COUNT(*) > 5) dept_stats ON d.department_id = dept_stats.department_id;

-- Task 10
SELECT d.department_name, s.min_salary, s.max_salary, s.avg_salary FROM departments d JOIN (SELECT department_id, MIN(salary) AS min_salary, MAX(salary) AS max_salary, AVG(salary) AS avg_salary FROM employees GROUP BY department_id) s ON d.department_id = s.department_id;


-- Task 11
SELECT employee_name, salary FROM employees WHERE salary > (SELECT AVG(salary) FROM employees);

-- Task 12
SELECT product_name, price FROM products WHERE price > (SELECT AVG(price) FROM products);

-- Task 13
SELECT employee_name, department_id FROM employees e WHERE (SELECT COUNT(*) FROM employees WHERE department_id = e.department_id) > 3;

-- Task 14
SELECT customer_name FROM customers c WHERE (SELECT COUNT(*) FROM orders WHERE customer_id = c.customer_id) > (SELECT AVG(order_count) FROM (SELECT COUNT(*) AS order_count FROM orders GROUP BY customer_id) avg_orders);

-- Task 15
SELECT product_name, quantity FROM products WHERE quantity < (SELECT MIN(quantity) FROM products);


-- Task 16
SELECT e.employee_name, e.salary, e.department_id FROM employees e WHERE salary > (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id);

-- Task 17
SELECT e.employee_name, e.salary, e.department_id FROM employees e WHERE salary = (SELECT MAX(salary) FROM employees WHERE department_id = e.department_id);

-- Task 18
SELECT DISTINCT d.department_name FROM departments d WHERE EXISTS (SELECT 1 FROM employees e WHERE e.department_id = d.department_id AND e.salary > 50000);

-- Task 19
SELECT e1.employee_name, e1.salary, e1.department_id FROM employees e1 WHERE e1.salary > ALL (SELECT e2.salary FROM employees e2 WHERE e2.department_id = e1.department_id AND e2.employee_id <> e1.employee_id);

-- Task 20
SELECT employee_name, salary FROM employees WHERE salary < ANY (SELECT MAX(salary) FROM employees GROUP BY department_id);




-- Task 21
SELECT customer_name FROM online_orders UNION SELECT customer_name FROM store_orders;

-- Task 22
SELECT customer_name FROM online_orders UNION ALL SELECT customer_name FROM store_orders;

-- Task 23
SELECT employee_name FROM full_time_employees UNION ALL SELECT employee_name FROM contract_employees;

-- Task 24
SELECT product_name FROM electronics UNION SELECT product_name FROM furniture;

-- Task 25
SELECT city FROM customers UNION ALL SELECT city FROM suppliers;

-- Task 26
SELECT employee_id FROM employees WHERE department_id = 101 INTERSECT SELECT employee_id FROM employees WHERE department_id = 102;

-- Task 27
SELECT employee_id FROM employees WHERE department_id = 101 EXCEPT SELECT employee_id FROM employees WHERE department_id = 103;

-- Task 28
SELECT product_id FROM wholesale_products INTERSECT SELECT product_id FROM retail_products;

-- Task 29
SELECT customer_id FROM online_orders EXCEPT SELECT customer_id FROM store_orders;

-- Task 30
SELECT employee_id FROM current_employees EXCEPT SELECT employee_id FROM resigned_employees;




-- Task 31
SELECT d.department_name, SUM(e.salary) AS total_salary FROM employees e JOIN departments d ON e.department_id = d.department_id GROUP BY d.department_name;

-- Task 32
SELECT d.department_name, COUNT(e.employee_id) AS employee_count FROM departments d LEFT JOIN employees e ON d.department_id = e.department_id GROUP BY d.department_name;

-- Task 33
SELECT d.department_name, AVG(e.salary) AS avg_salary FROM departments d JOIN employees e ON d.department_id = e.department_id GROUP BY d.department_name;

-- Task 34
SELECT d.department_name, SUM(e.salary) AS total_salary FROM departments d JOIN employees e ON d.department_id = e.department_id GROUP BY d.department_name HAVING SUM(e.salary) > 100000;

-- Task 35
SELECT YEAR(hire_date) AS hire_year, COUNT(*) AS employees_hired FROM employees GROUP BY YEAR(hire_date) ORDER BY hire_year;


-- Task 36
SELECT d.department_name, AVG(e.salary) AS dept_avg_salary FROM departments d JOIN employees e ON d.department_id = e.department_id GROUP BY d.department_name HAVING AVG(e.salary) > (SELECT AVG(salary) FROM employees);

-- Task 37
SELECT d.department_name, e.employee_name, e.salary FROM departments d JOIN employees e ON d.department_id = e.department_id WHERE e.salary = (SELECT MAX(salary) FROM employees WHERE department_id = d.department_id);

-- Task 38
SELECT d.department_name, COUNT(e.employee_id) AS employee_count FROM departments d JOIN employees e ON d.department_id = e.department_id GROUP BY d.department_name HAVING COUNT(e.employee_id) < (SELECT AVG(dept_count) FROM (SELECT COUNT(*) AS dept_count FROM employees GROUP BY department_id) dept_counts);

-- Task 39
SELECT d.department_name, SUM(CASE WHEN e.salary > 50000 THEN 1 ELSE 0 END) AS high_earners_count FROM departments d LEFT JOIN employees e ON d.department_id = e.department_id GROUP BY d.department_name;

-- Task 40
SELECT e.employee_name, e.salary, d.department_name FROM employees e JOIN departments d ON e.department_id = d.department_id WHERE e.salary > (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id);




-- Task 41
SELECT employee_name, salary, CASE WHEN salary > 100000 THEN 'High' WHEN salary BETWEEN 50000 AND 100000 THEN 'Medium' ELSE 'Low' END AS salary_class FROM employees;

-- Task 42
SELECT product_name, quantity, CASE WHEN quantity < 10 THEN 'Low' WHEN quantity BETWEEN 10 AND 50 THEN 'Moderate' ELSE 'High' END AS stock_status FROM products;

-- Task 43
SELECT d.department_name, SUM(CASE WHEN e.salary < 50000 THEN 1 ELSE 0 END) AS low_salary, SUM(CASE WHEN e.salary BETWEEN 50000 AND 100000 THEN 1 ELSE 0 END) AS medium_salary, SUM(CASE WHEN e.salary > 100000 THEN 1 ELSE 0 END) AS high_salary FROM departments d LEFT JOIN employees e ON d.department_id = e.department_id GROUP BY d.department_name;

-- Task 44
SELECT employee_name, hire_date, CASE WHEN DATEDIFF(CURRENT_DATE, hire_date) < 365 THEN 'New Joiner' WHEN DATEDIFF(CURRENT_DATE, hire_date) BETWEEN 365 AND 1825 THEN 'Mid-Level' ELSE 'Senior' END AS employee_remark FROM employees;

-- Task 45
SELECT employee_name, salary, CASE WHEN salary > (SELECT AVG(salary) * 1.5 FROM employees) THEN 'Grade A' WHEN salary > (SELECT AVG(salary) FROM employees) THEN 'Grade B' ELSE 'Grade C' END AS salary_grade FROM employees;


-- Task 46
SELECT employee_name, hire_date FROM employees WHERE hire_date >= DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH);

-- Task 47
SELECT employee_name, hire_date FROM employees WHERE DATEDIFF(CURRENT_DATE, hire_date) > 730;

-- Task 48
SELECT employee_name, TIMESTAMPDIFF(MONTH, hire_date, CURRENT_DATE) AS months_since_joining FROM employees;

-- Task 49
SELECT YEAR(hire_date) AS join_year, COUNT(*) AS employee_count FROM employees GROUP BY YEAR(hire_date) ORDER BY join_year;

-- Task 50
SELECT employee_name, birth_date FROM employees WHERE MONTH(birth_date) = MONTH(CURRENT_DATE);




-- 20 MINI PROJECTS

-- ✅ 1. Employee Salary Insight Dashboard
SELECT 
    e.employee_name,
    e.salary,
    (SELECT MAX(salary) FROM employees) AS company_max_salary,
    (SELECT AVG(salary) FROM employees) AS company_avg_salary,
    (SELECT MIN(salary) FROM employees) AS company_min_salary,
    CASE 
        WHEN e.salary > (SELECT AVG(salary) * 1.5 FROM employees) THEN 'High'
        WHEN e.salary > (SELECT AVG(salary) FROM employees) THEN 'Medium'
        ELSE 'Low'
    END AS salary_class,
    e.salary - (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id) AS diff_from_dept_avg
FROM employees e;

-- ✅ 2. Department Budget Analyzer
SELECT 
    d.department_name,
    dept_stats.avg_salary,
    dept_stats.total_salary,
    CASE 
        WHEN dept_stats.total_salary = (SELECT MAX(total_salary) FROM 
            (SELECT SUM(salary) AS total_salary FROM employees GROUP BY department_id) dept_totals)
        THEN 'Highest Budget'
        ELSE 'Normal Budget'
    END AS budget_status
FROM departments d
JOIN (
    SELECT 
        department_id, 
        AVG(salary) AS avg_salary,
        SUM(salary) AS total_salary
    FROM employees
    GROUP BY department_id
    HAVING AVG(salary) > 50000
) dept_stats ON d.department_id = dept_stats.department_id;

-- ✅ 3. Employee Transfer Tracker
-- Employees in both IT and Finance
SELECT e.employee_name
FROM employees e
WHERE e.employee_id IN (
    SELECT employee_id FROM employees WHERE department_id = 101
    INTERSECT
    SELECT employee_id FROM employees WHERE department_id = 102
);

-- Employees in IT but not HR
SELECT e.employee_name
FROM employees e
WHERE e.employee_id IN (
    SELECT employee_id FROM employees WHERE department_id = 101
    EXCEPT
    SELECT employee_id FROM employees WHERE department_id = 103
);

-- ✅ 4. Product Category Merger Report
-- Combined products
SELECT product_id, product_name, price, 'Electronics' AS category FROM electronics
UNION
SELECT product_id, product_name, price, 'Furniture' AS category FROM furniture;

-- Price classification
SELECT 
    product_name,
    price,
    CASE
        WHEN price > (SELECT AVG(price) * 1.5 FROM (
            SELECT price FROM electronics UNION SELECT price FROM furniture
        ) all_products) THEN 'Premium'
        WHEN price > (SELECT AVG(price) FROM (
            SELECT price FROM electronics UNION SELECT price FROM furniture
        ) all_products) THEN 'Standard'
        ELSE 'Budget'
    END AS price_class
FROM (
    SELECT product_name, price FROM electronics
    UNION
    SELECT product_name, price FROM furniture
) combined_products;

-- ✅ 5. Customer Purchase Comparison Tool
-- Combined customer data
SELECT customer_id, customer_name, 'Online' AS channel FROM online_customers
UNION
SELECT customer_id, customer_name, 'Store' AS channel FROM store_customers;

-- Customers active on both platforms
SELECT customer_name FROM online_customers
INTERSECT
SELECT customer_name FROM store_customers;

-- High-value customers
SELECT c.customer_name, COUNT(o.order_id) AS order_count
FROM (
    SELECT customer_id, customer_name FROM online_customers
    UNION
    SELECT customer_id, customer_name FROM store_customers
) c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id) > (
    SELECT AVG(order_count) FROM (
        SELECT COUNT(*) AS order_count FROM orders GROUP BY customer_id
    ) customer_orders
);

-- ✅ 6. High Performer Identification System
-- Top performers (salary > dept avg)
SELECT e.employee_name, e.salary, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.salary > (
    SELECT AVG(salary) 
    FROM employees 
    WHERE department_id = e.department_id
)
ORDER BY e.salary DESC
LIMIT 5;

-- Department performance summary
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS employee_count,
    AVG(e.salary) AS avg_salary,
    SUM(e.salary) AS total_salary,
    CASE
        WHEN AVG(e.salary) > (SELECT AVG(salary) FROM employees) THEN 'Above Average'
        ELSE 'Below Average'
    END AS performance
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;

-- ✅ 7. Inventory Stock Checker
-- Combined inventory
SELECT product_id, product_name, quantity, 'Warehouse A' AS location FROM warehouse_a
UNION
SELECT product_id, product_name, quantity, 'Warehouse B' AS location FROM warehouse_b;

-- Low stock items
SELECT product_name, quantity,
    CASE
        WHEN quantity < 10 THEN 'Critical'
        WHEN quantity < 25 THEN 'Low'
        ELSE 'Adequate'
    END AS stock_status
FROM (
    SELECT product_name, SUM(quantity) AS quantity
    FROM (
        SELECT product_name, quantity FROM warehouse_a
        UNION ALL
        SELECT product_name, quantity FROM warehouse_b
    ) combined_inventory
    GROUP BY product_name
) inventory_summary
WHERE quantity < (
    SELECT AVG(quantity) FROM (
        SELECT quantity FROM warehouse_a UNION ALL SELECT quantity FROM warehouse_b
    ) all_items
);

-- ✅ 8. Employee Joiner Trend Report
-- Recent joiners
SELECT employee_name, hire_date
FROM employees
WHERE hire_date >= DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH);

-- Hiring trends by year
SELECT 
    YEAR(hire_date) AS join_year,
    COUNT(*) AS new_hires,
    CASE
        WHEN COUNT(*) > (SELECT AVG(hire_count) FROM (
            SELECT YEAR(hire_date), COUNT(*) AS hire_count FROM employees GROUP BY YEAR(hire_date)
        ) yearly_avg) THEN 'Above Average'
        ELSE 'Below Average'
    END AS trend
FROM employees
GROUP BY YEAR(hire_date)
ORDER BY join_year;

-- ✅ 9. Department Performance Ranker
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS employee_count,
    AVG(e.salary) AS avg_salary,
    SUM(e.salary) AS total_salary,
    RANK() OVER (ORDER BY AVG(e.salary) DESC) AS salary_rank,
    CASE
        WHEN AVG(e.salary) > (SELECT AVG(salary) FROM employees) THEN 'High Performing'
        ELSE 'Needs Review'
    END AS performance_tag
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING SUM(e.salary) > (
    SELECT AVG(total_salary) FROM (
        SELECT SUM(salary) AS total_salary FROM employees GROUP BY department_id
    ) dept_salaries
);

-- ✅ 10. Cross-Sell Opportunity Finder
-- Customers who bought multiple categories
SELECT c.customer_name
FROM customers c
WHERE c.customer_id IN (
    SELECT customer_id FROM electronics_orders
    INTERSECT
    SELECT customer_id FROM furniture_orders
);

-- Category-specific loyal customers
SELECT c.customer_name, 'Electronics Only' AS loyalty
FROM customers c
WHERE c.customer_id IN (
    SELECT customer_id FROM electronics_orders
    EXCEPT
    SELECT customer_id FROM furniture_orders
);

-- ✅ 11. Salary Band Distribution Analyzer
SELECT 
    d.department_name,
    SUM(CASE WHEN e.salary > 100000 THEN 1 ELSE 0 END) AS band_a,
    SUM(CASE WHEN e.salary BETWEEN 50000 AND 100000 THEN 1 ELSE 0 END) AS band_b,
    SUM(CASE WHEN e.salary < 50000 THEN 1 ELSE 0 END) AS band_c
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING SUM(CASE WHEN e.salary > 100000 THEN 1 ELSE 0 END) > 3;

-- ✅ 12. Product Launch Impact Report
-- New products (last 3 months)
SELECT product_name, launch_date, sales
FROM products
WHERE launch_date >= DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH);

-- Launch success classification
SELECT 
    product_name,
    sales,
    CASE
        WHEN sales > (SELECT AVG(sales) * 1.5 FROM products) THEN 'Successful'
        WHEN sales > (SELECT AVG(sales) FROM products) THEN 'Neutral'
        ELSE 'Fail'
    END AS launch_status
FROM products
WHERE launch_date >= DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH);

-- ✅ 13. Supplier Consistency Checker
-- Suppliers in both quarters
SELECT supplier_name FROM q1_suppliers
INTERSECT
SELECT supplier_name FROM q2_suppliers;

-- Suppliers missing in Q2
SELECT supplier_name FROM q1_suppliers
EXCEPT
SELECT supplier_name FROM q2_suppliers;

-- Supplier performance
SELECT 
    s.supplier_name,
    AVG(d.delivery_time) AS avg_delivery_time,
    CASE
        WHEN AVG(d.delivery_time) < (SELECT AVG(delivery_time) FROM deliveries) THEN 'Reliable'
        ELSE 'Needs Improvement'
    END AS status
FROM suppliers s
JOIN deliveries d ON s.supplier_id = d.supplier_id
GROUP BY s.supplier_name;

-- ✅ 14. Student Performance Dashboard
SELECT 
    s.student_name,
    c.course_name,
    AVG(sc.score) AS avg_score,
    CASE
        WHEN AVG(sc.score) >= 90 THEN 'Distinction'
        WHEN AVG(sc.score) >= 75 THEN 'Merit'
        WHEN AVG(sc.score) >= 50 THEN 'Pass'
        ELSE 'Fail'
    END AS grade
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
GROUP BY s.student_name, c.course_name
HAVING AVG(sc.score) > (
    SELECT AVG(score) FROM student_courses
);

-- ✅ 15. Revenue Comparison Engine
SELECT 
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    SUM(amount) AS revenue,
    CASE
        WHEN SUM(amount) > (SELECT AVG(monthly_revenue) FROM (
            SELECT YEAR(order_date), MONTH(order_date), SUM(amount) AS monthly_revenue
            FROM orders
            GROUP BY YEAR(order_date), MONTH(order_date)
        ) monthly_avg) THEN 'High'
        ELSE 'Low'
    END AS revenue_status
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year, month;

-- ✅ 16. Resignation & Replacement Audit
-- Resigned employees not replaced
SELECT e.employee_name, e.department_id
FROM resigned_employees e
WHERE NOT EXISTS (
    SELECT 1 FROM current_employees c 
    WHERE c.department_id = e.department_id AND c.position = e.position
);

-- Department attrition analysis
SELECT 
    d.department_name,
    COUNT(r.employee_id) AS resignations,
    COUNT(c.employee_id) AS current_employees,
    COUNT(r.employee_id) * 100.0 / (COUNT(r.employee_id) + COUNT(c.employee_id)) AS attrition_rate
FROM departments d
LEFT JOIN resigned_employees r ON d.department_id = r.department_id
LEFT JOIN current_employees c ON d.department_id = c.department_id
GROUP BY d.department_name
ORDER BY attrition_rate DESC;

-- ✅ 17. Product Return & Complaint Analyzer
SELECT 
    p.product_name,
    COUNT(r.return_id) AS return_count,
    CASE
        WHEN COUNT(r.return_id) > (SELECT AVG(return_count) FROM (
            SELECT COUNT(*) AS return_count FROM returns GROUP BY product_id
        ) product_returns) THEN 'High Return'
        ELSE 'Normal'
    END AS return_status,
    r.reason,
    CASE r.reason
        WHEN 'Damaged' THEN 'Quality Issue'
        WHEN 'Late' THEN 'Logistics Issue'
        WHEN 'Not as Described' THEN 'Description Issue'
        ELSE 'Other'
    END AS issue_category
FROM products p
JOIN returns r ON p.product_id = r.product_id
GROUP BY p.product_name, r.reason;

-- ✅ 18. Freelancer Project Tracker
SELECT 
    f.freelancer_name,
    COUNT(p.project_id) AS projects_completed,
    SUM(p.earnings) AS total_earnings,
    CASE
        WHEN SUM(p.earnings) > (SELECT AVG(total_earnings) FROM (
            SELECT freelancer_id, SUM(earnings) AS total_earnings
            FROM projects
            GROUP BY freelancer_id
        ) freelancer_earnings) THEN 'High Earner'
        ELSE 'Standard'
    END AS earning_status
FROM freelancers f
JOIN projects p ON f.freelancer_id = p.freelancer_id
GROUP BY f.freelancer_name;

-- ✅ 19. Course Enrollment Optimizer
SELECT 
    c.course_name,
    cat.category_name,
    COUNT(e.student_id) AS enrollments,
    CASE
        WHEN COUNT(e.student_id) > (SELECT AVG(enrollment_count) FROM (
            SELECT COUNT(*) AS enrollment_count FROM enrollments GROUP BY course_id
        ) course_enrollments) THEN 'Popular'
        ELSE 'Regular'
    END AS popularity
FROM courses c
JOIN categories cat ON c.category_id = cat.category_id
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name, cat.category_name;

-- ✅ 20. Vehicle Maintenance Tracker
-- Vehicles due for service
SELECT 
    v.vehicle_id,
    v.vehicle_type,
    m.last_service_date,
    DATE_ADD(m.last_service_date, INTERVAL 6 MONTH) AS next_service_due,
    CASE
        WHEN DATE_ADD(m.last_service_date, INTERVAL 6 MONTH) <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN 'High'
        WHEN DATE_ADD(m.last_service_date, INTERVAL 6 MONTH) <= DATE_ADD(CURRENT_DATE, INTERVAL 60 DAY) THEN 'Medium'
        ELSE 'Low'
    END AS urgency
FROM vehicles v
JOIN maintenance m ON v.vehicle_id = m.vehicle_id
WHERE DATE_ADD(m.last_service_date, INTERVAL 6 MONTH) <= DATE_ADD(CURRENT_DATE, INTERVAL 90 DAY);

-- High service cost vehicles
SELECT 
    v.vehicle_type,
    AVG(m.cost) AS avg_service_cost,
    SUM(m.cost) AS total_service_cost
FROM vehicles v
JOIN maintenance m ON v.vehicle_id = m.vehicle_id
GROUP BY v.vehicle_type
HAVING AVG(m.cost) > (
    SELECT AVG(cost) FROM maintenance
);

