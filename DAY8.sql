-- Section 6: Bonus Tasks to Complete 50 Total

-- Task 40: Identify Repeat Customers
SELECT customer_id
FROM fact_sales
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Task 41: Sales per Region per Quarter
SELECT l.region, CEIL(MONTH(t.order_date)/3) AS quarter, SUM(f.total_amount) AS revenue
FROM fact_sales f
JOIN dim_location l ON f.location_id = l.location_id
JOIN dim_time t ON f.time_id = t.time_id
GROUP BY l.region, quarter;

-- Task 42: Product Performance Over Time
SELECT p.product_name, t.month, SUM(f.quantity) AS total_quantity
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
JOIN dim_time t ON f.time_id = t.time_id
GROUP BY p.product_name, t.month;

-- Task 43: Most Popular Product Each Month
SELECT month, product_name FROM (
  SELECT t.month, p.product_name, 
         RANK() OVER (PARTITION BY t.month ORDER BY SUM(f.quantity) DESC) AS rnk
  FROM fact_sales f
  JOIN dim_product p ON f.product_id = p.product_id
  JOIN dim_time t ON f.time_id = t.time_id
  GROUP BY t.month, p.product_name
) ranked
WHERE rnk = 1;

-- Task 44: Monthly Average Revenue Per Customer
SELECT t.month, AVG(customer_total) AS avg_revenue_per_customer FROM (
  SELECT t.month, f.customer_id, SUM(f.total_amount) AS customer_total
  FROM fact_sales f
  JOIN dim_time t ON f.time_id = t.time_id
  GROUP BY t.month, f.customer_id
) monthly_customer
GROUP BY t.month;

-- Task 45: Show Orders with Tax Above 5000
SELECT *, total_amount * 0.18 AS tax
FROM fact_sales
WHERE total_amount * 0.18 > 5000;

-- Task 46: High Revenue Products (Above Average)
SELECT product_id, SUM(total_amount) AS product_total
FROM fact_sales
GROUP BY product_id
HAVING product_total > (
  SELECT AVG(total_amount) FROM fact_sales
);

-- Task 47: Yearly Sales Summary by Region
SELECT l.region, t.year, SUM(f.total_amount) AS total_revenue
FROM fact_sales f
JOIN dim_location l ON f.location_id = l.location_id
JOIN dim_time t ON f.time_id = t.time_id
GROUP BY l.region, t.year;

-- Task 48: Day of Week Sales Trend
SELECT DAYNAME(t.order_date) AS weekday, SUM(f.total_amount) AS revenue
FROM fact_sales f
JOIN dim_time t ON f.time_id = t.time_id
GROUP BY weekday;

-- Task 49: Top Customers Per Year
SELECT * FROM (
  SELECT t.year, f.customer_id, SUM(f.total_amount) AS total_spent,
         RANK() OVER (PARTITION BY t.year ORDER BY SUM(f.total_amount) DESC) AS rnk
  FROM fact_sales f
  JOIN dim_time t ON f.time_id = t.time_id
  GROUP BY t.year, f.customer_id
) ranked
WHERE rnk <= 3;

-- Task 50: Create Monthly Snapshot Table
CREATE TABLE monthly_snapshot AS
SELECT t.year, t.month, p.category, SUM(f.total_amount) AS revenue
FROM fact_sales f
JOIN dim_time t ON f.time_id = t.time_id
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY t.year, t.month, p.category;

-- PROJECT 1: Customers Without Transactions
SELECT V.customer_id, COUNT(*) AS count_no_trans
FROM Visits V
LEFT JOIN Transactions T
  ON V.visit_id = T.visit_id
WHERE T.transaction_id IS NULL
GROUP BY V.customer_id;

-- PROJECT 2: Top Selling Products
SELECT product_id, SUM(quantity) AS total_sold
FROM Orders
GROUP BY product_id
ORDER BY total_sold DESC
LIMIT 5;

-- PROJECT 3: Active Customers
SELECT customer_id, COUNT(*) AS total_orders
FROM Orders
GROUP BY customer_id
HAVING COUNT(*) > 5;

-- PROJECT 4: Average Order Value
SELECT customer_id, AVG(amount) AS avg_order_value
FROM Orders
GROUP BY customer_id;

-- PROJECT 5: Daily Revenue
SELECT DATE(order_date) AS order_day, SUM(amount) AS daily_revenue
FROM Orders
GROUP BY order_day;

-- PROJECT 6: Products Never Ordered
SELECT P.product_id, P.product_name
FROM Products P
LEFT JOIN Orders O
  ON P.product_id = O.product_id
WHERE O.product_id IS NULL;

-- PROJECT 7: Highest Paying Customer
SELECT customer_id, SUM(amount) AS total_spent
FROM Orders
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 1;

-- PROJECT 8: Monthly Revenue
SELECT MONTH(order_date) AS month, YEAR(order_date) AS year, SUM(amount) AS revenue
FROM Orders
GROUP BY YEAR(order_date), MONTH(order_date);

-- PROJECT 9: Products with Low Stock
SELECT product_id, product_name, quantity
FROM Products
WHERE quantity < 10;

-- PROJECT 10: Most Ordered Product per Month
SELECT MONTH(order_date) AS month, product_id, COUNT(*) AS total_orders
FROM Orders
GROUP BY month, product_id
ORDER BY month, total_orders DESC;

-- PROJECT 11: Average Quantity per Order
SELECT order_id, AVG(quantity) AS avg_quantity
FROM Order_Details
GROUP BY order_id;

-- PROJECT 12: Customers by Total Quantity Purchased
SELECT customer_id, SUM(quantity) AS total_quantity
FROM Orders
GROUP BY customer_id
ORDER BY total_quantity DESC;

-- PROJECT 13: Orders Without Delivery
SELECT O.order_id
FROM Orders O
LEFT JOIN Deliveries D
  ON O.order_id = D.order_id
WHERE D.delivery_id IS NULL;

-- PROJECT 14: First Order of Each Customer
SELECT customer_id, MIN(order_date) AS first_order_date
FROM Orders
GROUP BY customer_id;

-- PROJECT 15: Revenue by Category
SELECT P.category, SUM(O.amount) AS total_revenue
FROM Orders O
JOIN Products P
  ON O.product_id = P.product_id
GROUP BY P.category;

-- PROJECT 16: Returning Customers
SELECT customer_id
FROM Orders
GROUP BY customer_id
HAVING COUNT(DISTINCT order_date) > 1;

-- PROJECT 17: Product Popularity Over Time
SELECT DATE(order_date) AS date, product_id, COUNT(*) AS order_count
FROM Orders
GROUP BY date, product_id;

-- PROJECT 18: Cancelled Orders Report
SELECT customer_id, COUNT(*) AS cancelled_count
FROM Orders
WHERE status = 'Cancelled'
GROUP BY customer_id;

-- PROJECT 19: Monthly Average Order Value
SELECT MONTH(order_date) AS month, YEAR(order_date) AS year, AVG(amount) AS avg_order
FROM Orders
GROUP BY YEAR(order_date), MONTH(order_date);

-- PROJECT 20: Product Inventory Value
SELECT product_id, product_name, quantity * price AS inventory_value
FROM Products;
