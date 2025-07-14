/*****************************/
/* 1. E-Commerce Product Catalog */
/*****************************/

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE brands (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    image_url VARCHAR(255),
    category_id INT,
    brand_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (brand_id) REFERENCES brands(id),
    INDEX (price),
    INDEX (category_id),
    INDEX (brand_id)
);

-- Get products by category
SELECT p.*, b.name AS brand_name, c.name AS category_name
FROM products p
JOIN brands b ON p.brand_id = b.id
JOIN categories c ON p.category_id = c.id
WHERE c.name = 'Electronics';

/*****************************/
/* 2. Shopping Cart System */
/*****************************/

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE carts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE cart_items (
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    PRIMARY KEY (cart_id, product_id),
    FOREIGN KEY (cart_id) REFERENCES carts(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Calculate cart total
SELECT SUM(ci.quantity * p.price) AS cart_total
FROM cart_items ci
JOIN products p ON ci.product_id = p.id
WHERE ci.cart_id = 1;

/*****************************/
/* 3. Order Management System */
/*****************************/

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Order history for user
SELECT o.id, o.status, o.created_at, o.total_amount, COUNT(oi.id) AS item_count
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
WHERE o.user_id = 1
GROUP BY o.id
ORDER BY o.created_at DESC;

/*****************************/
/* 4. Inventory Tracking System */
/*****************************/

CREATE TABLE suppliers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    contact_info VARCHAR(255)
);

CREATE TABLE inventory_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    supplier_id INT,
    action ENUM('stock_in', 'stock_out', 'adjustment') NOT NULL,
    qty INT NOT NULL,
    notes TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);

-- Stock status with reorder logic
SELECT 
    p.id, p.name, p.stock,
    CASE 
        WHEN p.stock = 0 THEN 'Out of Stock'
        WHEN p.stock < 10 THEN 'Low Stock'
        ELSE 'In Stock'
    END AS stock_status
FROM products p;

/*****************************/
/* 5. Product Review System */
/*****************************/

CREATE TABLE reviews (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    UNIQUE (user_id, product_id)
);

-- Top-rated products
SELECT p.id, p.name, AVG(r.rating) AS avg_rating
FROM products p
JOIN reviews r ON p.id = r.product_id
GROUP BY p.id
HAVING COUNT(r.id) >= 5
ORDER BY avg_rating DESC
LIMIT 10;

/*****************************/
/* 6. Employee Timesheet Tracker */
/*****************************/

CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    dept VARCHAR(50) NOT NULL
);

CREATE TABLE projects (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE
);

CREATE TABLE timesheets (
    id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT NOT NULL,
    project_id INT NOT NULL,
    hours DECIMAL(5,2) NOT NULL,
    date DATE NOT NULL,
    description TEXT,
    FOREIGN KEY (emp_id) REFERENCES employees(id),
    FOREIGN KEY (project_id) REFERENCES projects(id)
);

-- Weekly hours by employee
SELECT e.name, SUM(t.hours) AS total_hours, WEEK(t.date) AS week_number
FROM timesheets t
JOIN employees e ON t.emp_id = e.id
GROUP BY e.id, WEEK(t.date);

/*****************************/
/* 7. Leave Management System */
/*****************************/

CREATE TABLE leave_types (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL,
    max_days INT NOT NULL
);

CREATE TABLE leave_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT NOT NULL,
    leave_type_id INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    reason TEXT,
    FOREIGN KEY (emp_id) REFERENCES employees(id),
    FOREIGN KEY (leave_type_id) REFERENCES leave_types(id)
);

-- Leave balance
SELECT lt.type_name, lt.max_days, 
       SUM(DATEDIFF(lr.to_date, lr.from_date)+1) AS days_used,
       lt.max_days - SUM(DATEDIFF(lr.to_date, lr.from_date)+1) AS days_remaining
FROM leave_types lt
LEFT JOIN leave_requests lr ON lt.id = lr.leave_type_id AND lr.emp_id = 1 AND lr.status = 'approved'
GROUP BY lt.id;

/*****************************/
/* 8. Sales CRM Tracker */
/*****************************/

CREATE TABLE leads (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    source VARCHAR(50),
    status ENUM('new', 'contacted', 'qualified', 'lost') DEFAULT 'new',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE deals (
    id INT PRIMARY KEY AUTO_INCREMENT,
    lead_id INT NOT NULL,
    user_id INT NOT NULL,
    stage ENUM('proposal', 'negotiation', 'closed_won', 'closed_lost') DEFAULT 'proposal',
    amount DECIMAL(10,2),
    probability INT CHECK (probability BETWEEN 0 AND 100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    closed_at DATETIME,
    FOREIGN KEY (lead_id) REFERENCES leads(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Sales pipeline
SELECT stage, COUNT(*) AS deal_count, SUM(amount) AS total_amount
FROM deals
WHERE closed_at IS NULL
GROUP BY stage;

/*****************************/
/* 9. Appointment Scheduler */
/*****************************/

CREATE TABLE services (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    duration INT NOT NULL,
    price DECIMAL(10,2)
);

CREATE TABLE appointments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    service_id INT NOT NULL,
    appointment_time DATETIME NOT NULL,
    status ENUM('scheduled', 'completed', 'cancelled', 'no_show') DEFAULT 'scheduled',
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (service_id) REFERENCES services(id)
);

-- Daily appointments
SELECT a.id, u.name AS client_name, s.name AS service_name, a.appointment_time
FROM appointments a
JOIN users u ON a.user_id = u.id
JOIN services s ON a.service_id = s.id
WHERE DATE(a.appointment_time) = '2023-06-15'
ORDER BY a.appointment_time;

/*****************************/
/* 10. Project Management */
/*****************************/

CREATE TABLE tasks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    status ENUM('not_started', 'in_progress', 'completed', 'blocked') DEFAULT 'not_started',
    priority TINYINT DEFAULT 3,
    due_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(id)
);

CREATE TABLE task_assignments (
    task_id INT NOT NULL,
    user_id INT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (task_id, user_id),
    FOREIGN KEY (task_id) REFERENCES tasks(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Project progress
SELECT p.name, 
       COUNT(t.id) AS total_tasks,
       SUM(CASE WHEN t.status = 'completed' THEN 1 ELSE 0 END) AS completed_tasks,
       ROUND(SUM(CASE WHEN t.status = 'completed' THEN 1 ELSE 0 END)/COUNT(t.id)*100,1) AS completion_pct
FROM projects p
JOIN tasks t ON p.id = t.project_id
GROUP BY p.id;

/*****************************/
/* 11. Course Enrollment */
/*****************************/

CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    instructor VARCHAR(100) NOT NULL,
    start_date DATE,
    end_date DATE,
    max_capacity INT
);

CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    enrollment_date DATE
);

CREATE TABLE enrollments (
    course_id INT NOT NULL,
    student_id INT NOT NULL,
    enroll_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('active', 'completed', 'dropped') DEFAULT 'active',
    PRIMARY KEY (course_id, student_id),
    FOREIGN KEY (course_id) REFERENCES courses(id),
    FOREIGN KEY (student_id) REFERENCES students(id)
);

-- Course capacity
SELECT c.title, COUNT(e.student_id) AS enrolled, c.max_capacity,
       CASE WHEN COUNT(e.student_id) >= c.max_capacity THEN 'FULL' ELSE 'AVAILABLE' END AS status
FROM courses c
LEFT JOIN enrollments e ON c.id = e.course_id AND e.status = 'active'
GROUP BY c.id;

/*****************************/
/* 12. Online Exam System */
/*****************************/

CREATE TABLE exams (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    exam_date DATETIME,
    duration INT,
    total_marks INT,
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

CREATE TABLE questions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    exam_id INT NOT NULL,
    text TEXT NOT NULL,
    option_a VARCHAR(255) NOT NULL,
    option_b VARCHAR(255) NOT NULL,
    option_c VARCHAR(255),
    option_d VARCHAR(255),
    correct_option CHAR(1) NOT NULL,
    marks INT NOT NULL,
    FOREIGN KEY (exam_id) REFERENCES exams(id)
);

CREATE TABLE student_answers (
    student_id INT NOT NULL,
    question_id INT NOT NULL,
    selected_option CHAR(1),
    answered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (student_id, question_id),
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

-- Exam results
SELECT s.name, 
       SUM(CASE WHEN sa.selected_option = q.correct_option THEN q.marks ELSE 0 END) AS score,
       e.total_marks,
       ROUND(SUM(CASE WHEN sa.selected_option = q.correct_option THEN q.marks ELSE 0 END)/e.total_marks*100,1) AS percentage
FROM exams e
JOIN questions q ON e.id = q.exam_id
JOIN student_answers sa ON q.id = sa.question_id
JOIN students s ON sa.student_id = s.id
WHERE e.id = 1
GROUP BY s.id;

/*****************************/
/* 13. Library Management */
/*****************************/

CREATE TABLE books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    publication_year INT,
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1
);

CREATE TABLE members (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    membership_date DATE,
    status ENUM('active', 'inactive') DEFAULT 'active'
);

CREATE TABLE borrows (
    id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT NOT NULL,
    book_id INT NOT NULL,
    borrow_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    fine_amount DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (member_id) REFERENCES members(id),
    FOREIGN KEY (book_id) REFERENCES books(id)
);

-- Overdue books
SELECT b.title, m.name, br.due_date, DATEDIFF(CURDATE(), br.due_date) AS days_overdue
FROM borrows br
JOIN books b ON br.book_id = b.id
JOIN members m ON br.member_id = m.id
WHERE br.return_date IS NULL AND CURDATE() > br.due_date;

/*****************************/
/* 14. Hospital Patient Tracker */
/*****************************/

CREATE TABLE patients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    dob DATE,
    gender ENUM('male', 'female', 'other'),
    blood_type VARCHAR(10),
    contact_number VARCHAR(20)
);

CREATE TABLE doctors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    contact_number VARCHAR(20)
);

CREATE TABLE visits (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    visit_time DATETIME NOT NULL,
    purpose VARCHAR(255),
    diagnosis TEXT,
    prescription TEXT,
    status ENUM('scheduled', 'completed', 'cancelled', 'no_show') DEFAULT 'scheduled',
    FOREIGN KEY (patient_id) REFERENCES patients(id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id)
);

-- Doctor's schedule
SELECT v.visit_time, p.name AS patient_name, v.purpose, v.status
FROM visits v
JOIN patients p ON v.patient_id = p.id
WHERE v.doctor_id = 1 AND DATE(v.visit_time) = CURDATE()
ORDER BY v.visit_time;

/*****************************/
/* 15. Health Records System */
/*****************************/

CREATE TABLE prescriptions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    date DATE NOT NULL,
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id)
);

CREATE TABLE medications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    manufacturer VARCHAR(100)
);

CREATE TABLE prescription_details (
    prescription_id INT NOT NULL,
    medication_id INT NOT NULL,
    dosage VARCHAR(50) NOT NULL,
    frequency VARCHAR(50) NOT NULL,
    duration VARCHAR(50) NOT NULL,
    instructions TEXT,
    PRIMARY KEY (prescription_id, medication_id),
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(id),
    FOREIGN KEY (medication_id) REFERENCES medications(id)
);

-- Patient's current medications
SELECT m.name, pd.dosage, pd.frequency, pd.duration, p.date AS prescribed_on
FROM prescription_details pd
JOIN medications m ON pd.medication_id = m.id
JOIN prescriptions p ON pd.prescription_id = p.id
WHERE p.patient_id = 1 AND p.date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
ORDER BY p.date DESC;

/*****************************/
/* 16. Expense Tracker */
/*****************************/

CREATE TABLE expense_categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    description TEXT
);

CREATE TABLE expenses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    category_id INT,
    amount DECIMAL(10,2) NOT NULL,
    date DATE NOT NULL,
    description VARCHAR(255),
    payment_method ENUM('cash', 'credit_card', 'debit_card', 'bank_transfer', 'other') NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (category_id) REFERENCES expense_categories(id)
);

-- Monthly expenses by category
SELECT c.name AS category, SUM(e.amount) AS total, COUNT(e.id) AS count
FROM expenses e
JOIN expense_categories c ON e.category_id = c.id
WHERE e.user_id = 1 AND YEAR(e.date) = 2023 AND MONTH(e.date) = 6
GROUP BY c.id
ORDER BY total DESC;

/*****************************/
/* 17. Invoice Generator */
/*****************************/

CREATE TABLE clients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    tax_id VARCHAR(50)
);

CREATE TABLE invoices (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT NOT NULL,
    invoice_date DATE NOT NULL,
    due_date DATE NOT NULL,
    status ENUM('draft', 'sent', 'paid', 'overdue', 'cancelled') DEFAULT 'draft',
    tax_rate DECIMAL(5,2) DEFAULT 0,
    notes TEXT,
    FOREIGN KEY (client_id) REFERENCES clients(id)
);

CREATE TABLE invoice_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    invoice_id INT NOT NULL,
    description VARCHAR(255) NOT NULL,
    quantity DECIMAL(10,2) NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    tax_amount DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (invoice_id) REFERENCES invoices(id)
);

-- Invoice totals
SELECT i.id, i.invoice_date, c.name AS client,
       SUM(ii.quantity * ii.unit_price) AS subtotal,
       SUM(ii.quantity * ii.unit_price * i.tax_rate/100) AS tax,
       SUM(ii.quantity * ii.unit_price * (1 + i.tax_rate/100)) AS total
FROM invoices i
JOIN clients c ON i.client_id = c.id
JOIN invoice_items ii ON i.id = ii.invoice_id
GROUP BY i.id;

/*****************************/
/* 18. Bank Transactions */
/*****************************/

CREATE TABLE accounts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    account_type ENUM('checking', 'savings', 'credit', 'loan') NOT NULL,
    balance DECIMAL(15,2) NOT NULL DEFAULT 0,
    opened_date DATE NOT NULL,
    status ENUM('active', 'closed', 'frozen') DEFAULT 'active',
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE transactions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    transaction_type ENUM('deposit', 'withdrawal', 'transfer', 'payment', 'fee') NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description VARCHAR(255),
    related_account_id INT,
    FOREIGN KEY (account_id) REFERENCES accounts(id),
    FOREIGN KEY (related_account_id) REFERENCES accounts(id)
);

-- Account balance history
SELECT t.transaction_date, t.transaction_type, t.amount, t.description,
       SUM(CASE 
           WHEN t.transaction_type = 'deposit' THEN t.amount 
           ELSE -t.amount 
       END) OVER (ORDER BY t.transaction_date) AS running_balance
FROM transactions t
WHERE t.account_id = 1
ORDER BY t.transaction_date;

/*****************************/
/* 19. Loan Repayment Tracker */
/*****************************/

CREATE TABLE loans (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    account_id INT,
    principal DECIMAL(15,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    term_months INT NOT NULL,
    start_date DATE NOT NULL,
    status ENUM('active', 'paid', 'defaulted') DEFAULT 'active',
    payment_due_day TINYINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);

CREATE TABLE payments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    loan_id INT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    paid_on DATE NOT NULL,
    payment_method VARCHAR(50),
    principal_amount DECIMAL(15,2),
    interest_amount DECIMAL(15,2),
    FOREIGN KEY (loan_id) REFERENCES loans(id)
);

-- Loan amortization
WITH RECURSIVE amortization_schedule AS (
    SELECT 1 AS payment_number,
           l.principal AS remaining_balance,
           (l.principal * (l.interest_rate/100/12)) / (1 - POWER(1 + (l.interest_rate/100/12), -l.term_months)) AS payment_amount,
           l.principal * (l.interest_rate/100/12) AS interest,
           ((l.principal * (l.interest_rate/100/12)) / (1 - POWER(1 + (l.interest_rate/100/12), -l.term_months))) - (l.principal * (l.interest_rate/100/12)) AS principal_payment,
           DATE_ADD(l.start_date, INTERVAL 1 MONTH) AS payment_date
    FROM loans l WHERE l.id = 1
    
    UNION ALL
    
    SELECT a.payment_number + 1,
           a.remaining_balance - a.principal_payment,
           a.payment_amount,
           (a.remaining_balance - a.principal_payment) * (SELECT interest_rate/100/12 FROM loans WHERE id = 1),
           a.payment_amount - ((a.remaining_balance - a.principal_payment) * (SELECT interest_rate/100/12 FROM loans WHERE id = 1)),
           DATE_ADD(a.payment_date, INTERVAL 1 MONTH)
    FROM amortization_schedule a
    WHERE a.payment_number < (SELECT term_months FROM loans WHERE id = 1)
)
SELECT * FROM amortization_schedule;

/*****************************/
/* 20. Salary Management */
/*****************************/

CREATE TABLE salaries (
    id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT NOT NULL,
    pay_period DATE NOT NULL,
    base_salary DECIMAL(12,2) NOT NULL,
    bonus DECIMAL(12,2) DEFAULT 0,
    overtime_hours DECIMAL(5,2) DEFAULT 0,
    overtime_rate DECIMAL(10,2) DEFAULT 0,
    gross_pay DECIMAL(12,2) GENERATED ALWAYS AS (base_salary + bonus + (overtime_hours * overtime_rate)) STORED,
    status ENUM('draft', 'processed', 'paid') DEFAULT 'draft',
    payment_date DATE,
    FOREIGN KEY (emp_id) REFERENCES employees(id),
    UNIQUE (emp_id, pay_period)
);

CREATE TABLE deductions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    salary_id INT NOT NULL,
    deduction_type VARCHAR(50) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    description VARCHAR(255),
    FOREIGN KEY (salary_id) REFERENCES salaries(id)
);

-- Payroll summary
SELECT e.department,
       COUNT(s.id) AS employees,
       SUM(s.gross_pay) AS gross_payroll,
       SUM(d.amount) AS total_deductions,
       SUM(s.gross_pay - d.amount) AS net_payroll
FROM salaries s
JOIN employees e ON s.emp_id = e.id
LEFT JOIN (SELECT salary_id, SUM(amount) AS amount FROM deductions GROUP BY salary_id) d ON s.id = d.salary_id
WHERE s.pay_period = '2023-06-01'
GROUP BY e.department;

/*****************************/
/* 21. Blog Management */
/*****************************/

CREATE TABLE posts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    published_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('draft', 'published', 'archived') DEFAULT 'draft',
    slug VARCHAR(255) UNIQUE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE comments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL,
    user_id INT,
    comment_text TEXT NOT NULL,
    commented_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('approved', 'pending', 'spam') DEFAULT 'pending',
    FOREIGN KEY (post_id) REFERENCES posts(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Posts with comment counts
SELECT p.id, p.title, p.published_date, u.name AS author,
       COUNT(c.id) AS comment_count
FROM posts p
JOIN users u ON p.user_id = u.id
LEFT JOIN comments c ON p.id = c.post_id AND c.status = 'approved'
WHERE p.status = 'published'
GROUP BY p.id
ORDER BY p.published_date DESC;

/*****************************/
/* 22. Voting System */
/*****************************/

CREATE TABLE polls (
    id INT PRIMARY KEY AUTO_INCREMENT,
    question VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at DATETIME,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE options (
    id INT PRIMARY KEY AUTO_INCREMENT,
    poll_id INT NOT NULL,
    option_text VARCHAR(255) NOT NULL,
    FOREIGN KEY (poll_id) REFERENCES polls(id)
);

CREATE TABLE votes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    option_id INT NOT NULL,
    voted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (option_id) REFERENCES options(id),
    UNIQUE (user_id, poll_id)
);

-- Poll results
SELECT o.option_text, COUNT(v.id) AS votes,
       ROUND(COUNT(v.id) * 100.0 / (SELECT COUNT(*) FROM votes v2 JOIN options o2 ON v2.option_id = o2.id WHERE o2.poll_id = o.poll_id), 1) AS percentage
FROM options o
LEFT JOIN votes v ON o.id = v.option_id
WHERE o.poll_id = 1
GROUP BY o.id
ORDER BY votes DESC;

/*****************************/
/* 23. Messaging System */
/*****************************/

CREATE TABLE conversations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    subject VARCHAR(255)
);

CREATE TABLE conversation_participants (
    conversation_id INT NOT NULL,
    user_id INT NOT NULL,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_read_at TIMESTAMP NULL,
    PRIMARY KEY (conversation_id, user_id),
    FOREIGN KEY (conversation_id) REFERENCES conversations(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE messages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    conversation_id INT NOT NULL,
    sender_id INT NOT NULL,
    message_text TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conversation_id) REFERENCES conversations(id),
    FOREIGN KEY (sender_id) REFERENCES users(id)
);

-- Conversation list with unread counts
SELECT c.id, c.subject, m.message_text AS last_message, m.sent_at,
       COUNT(DISTINCT cp.user_id) - 1 AS other_participants,
       SUM(CASE WHEN m.sent_at > cp.last_read_at THEN 1 ELSE 0 END) AS unread_count
FROM conversation_participants cp
JOIN conversations c ON cp.conversation_id = c.id
JOIN (SELECT conversation_id, MAX(sent_at) AS max_sent FROM messages GROUP BY conversation_id) lm ON c.id = lm.conversation_id
JOIN messages m ON lm.conversation_id = m.conversation_id AND lm.max_sent = m.sent_at
WHERE cp.user_id = 1
GROUP BY c.id
ORDER BY m.sent_at DESC;

/*****************************/
/* 24. Attendance Tracker */
/*****************************/

CREATE TABLE attendance (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    date DATE NOT NULL,
    status ENUM('present', 'absent', 'late', 'excused') DEFAULT 'present',
    notes TEXT,
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (course_id) REFERENCES courses(id),
    UNIQUE (student_id, course_id, date)
);

-- Attendance summary
SELECT s.name, 
       COUNT(a.id) AS total_classes,
       SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) AS present_count,
       ROUND(SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) * 100.0 / COUNT(a.id), 1) AS attendance_percentage
FROM attendance a
JOIN students s ON a.student_id = s.id
WHERE a.course_id = 1
GROUP BY s.id
ORDER BY attendance_percentage DESC;

/*****************************/
/* 25. Product Wishlist */
/*****************************/

CREATE TABLE wishlists (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    is_public BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE wishlist_items (
    wishlist_id INT NOT NULL,
    product_id INT NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    priority ENUM('low', 'medium', 'high') DEFAULT 'medium',
    PRIMARY KEY (wishlist_id, product_id),
    FOREIGN KEY (wishlist_id) REFERENCES wishlists(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Popular wishlist items
SELECT p.id, p.name, COUNT(wi.product_id) AS wishlist_count
FROM products p
JOIN wishlist_items wi ON p.id = wi.product_id
GROUP BY p.id
ORDER BY wishlist_count DESC
LIMIT 10;

/*****************************/
/* 26. Donation Management */
/*****************************/

CREATE TABLE donors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    donor_type ENUM('individual', 'organization') DEFAULT 'individual'
);

CREATE TABLE causes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    target_amount DECIMAL(15,2),
    start_date DATE,
    end_date DATE,
    status ENUM('active', 'completed', 'cancelled') DEFAULT 'active'
);

CREATE TABLE donations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    donor_id INT NOT NULL,
    cause_id INT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    donated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50) NOT NULL,
    is_recurring BOOLEAN DEFAULT FALSE,
    frequency VARCHAR(20),
    message TEXT,
    FOREIGN KEY (donor_id) REFERENCES donors(id),
    FOREIGN KEY (cause_id) REFERENCES causes(id)
);

-- Cause progress
SELECT c.title, c.target_amount, SUM(d.amount) AS raised,
       ROUND(SUM(d.amount) * 100.0 / c.target_amount, 1) AS percent_complete
FROM causes c
LEFT JOIN donations d ON c.id = d.cause_id
WHERE c.status = 'active'
GROUP BY c.id
ORDER BY percent_complete DESC;

/*****************************/
/* 27. Notification System */
/*****************************/

CREATE TABLE notifications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    status ENUM('unread', 'read', 'dismissed') DEFAULT 'unread',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notification_type VARCHAR(50),
    related_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Unread notifications
SELECT id, title, message, created_at
FROM notifications
WHERE user_id = 1 AND status = 'unread'
ORDER BY created_at DESC;

/*****************************/
/* 28. Course Progress */
/*****************************/

CREATE TABLE lessons (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    duration INT,
    sequence_order INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

CREATE TABLE progress (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    lesson_id INT NOT NULL,
    started_at TIMESTAMP NULL,
    completed_at TIMESTAMP NULL,
    score DECIMAL(5,2),
    status ENUM('not_started', 'in_progress', 'completed') DEFAULT 'not_started',
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (lesson_id) REFERENCES lessons(id),
    UNIQUE (student_id, lesson_id)
);

-- Course completion
SELECT c.title, 
       COUNT(l.id) AS total_lessons,
       SUM(CASE WHEN p.status = 'completed' THEN 1 ELSE 0 END) AS completed_lessons,
       ROUND(SUM(CASE WHEN p.status = 'completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(l.id), 1) AS completion_percentage
FROM courses c
JOIN lessons l ON c.id = l.course_id
LEFT JOIN progress p ON l.id = p.lesson_id AND p.student_id = 1
GROUP BY c.id;

/*****************************/
/* 29. Recruitment Portal */
/*****************************/

CREATE TABLE companies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    industry VARCHAR(50),
    website VARCHAR(100),
    description TEXT
);

CREATE TABLE jobs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(100),
    salary_range VARCHAR(50),
    job_type ENUM('full_time', 'part_time', 'contract', 'internship') NOT NULL,
    posted_date DATE NOT NULL,
    closing_date DATE,
    status ENUM('open', 'closed', 'filled') DEFAULT 'open',
    FOREIGN KEY (company_id) REFERENCES companies(id)
);

CREATE TABLE candidates (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    resume_url VARCHAR(255),
    skills TEXT,
    experience_years INT
);

CREATE TABLE applications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    job_id INT NOT NULL,
    candidate_id INT NOT NULL,
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('submitted', 'reviewed', 'interviewing', 'offered', 'hired', 'rejected') DEFAULT 'submitted',
    notes TEXT,
    FOREIGN KEY (job_id) REFERENCES jobs(id),
    FOREIGN KEY (candidate_id) REFERENCES candidates(id),
    UNIQUE (job_id, candidate_id)
);

-- Job applications summary
SELECT j.title, c.name AS company,
       COUNT(a.id) AS applicants,
       SUM(CASE WHEN a.status = 'hired' THEN 1 ELSE 0 END) AS hires
FROM jobs j
JOIN companies c ON j.company_id = c.id
LEFT JOIN applications a ON j.id = a.job_id
GROUP BY j.id
ORDER BY j.posted_date DESC;

-- 30. HOTEL ROOM BOOKING SYSTEM QUERIES --

-- Find available rooms for a date range
SELECT r.id, r.number, r.type
FROM rooms r
WHERE r.id NOT IN (
    SELECT b.room_id
    FROM bookings b
    WHERE b.from_date <= '2023-12-31' 
    AND b.to_date >= '2023-12-01'
);

-- Find all bookings for a guest
SELECT b.id, r.number, r.type, b.from_date, b.to_date
FROM bookings b
JOIN rooms r ON b.room_id = r.id
WHERE b.guest_id = 123;


-- 31. MOVIE DATABASE QUERIES --

-- Get average rating per movie
SELECT m.id, m.title, AVG(r.score) as avg_rating
FROM movies m
LEFT JOIN ratings r ON m.id = r.movie_id
GROUP BY m.id, m.title
ORDER BY avg_rating DESC;

-- Find movies by genre with ratings
SELECT g.name as genre, m.title, AVG(r.score) as avg_rating
FROM movies m
JOIN genres g ON m.genre_id = g.id
LEFT JOIN ratings r ON m.id = r.movie_id
GROUP BY g.name, m.title;


-- 32. ONLINE FORUM SYSTEM QUERIES --

-- Get thread with all posts (including replies)
SELECT t.title, u.name as author, p.content, p.posted_at
FROM threads t
JOIN posts p ON t.id = p.thread_id
JOIN users u ON p.user_id = u.id
WHERE t.id = 456
ORDER BY p.posted_at;

-- Count posts per thread
SELECT t.id, t.title, COUNT(p.id) as post_count
FROM threads t
LEFT JOIN posts p ON t.id = p.thread_id
GROUP BY t.id, t.title;


-- 33. ASSET MANAGEMENT SYSTEM QUERIES --

-- Find currently assigned assets
SELECT a.name, u.name as assigned_to
FROM assets a
JOIN assignments ass ON a.id = ass.asset_id
JOIN users u ON ass.user_id = u.id
WHERE ass.returned_date IS NULL;

-- Asset assignment history
SELECT a.name, u.name as user, 
       ass.assigned_date, ass.returned_date
FROM assignments ass
JOIN assets a ON ass.asset_id = a.id
JOIN users u ON ass.user_id = u.id
ORDER BY a.name, ass.assigned_date;


-- 34. SPORTS TOURNAMENT TRACKER QUERIES --

-- Calculate team standings
SELECT t.name, 
       COUNT(CASE WHEN s.score > opp.score THEN 1 END) as wins,
       COUNT(CASE WHEN s.score < opp.score THEN 1 END) as losses
FROM teams t
JOIN scores s ON t.id = s.team_id
JOIN matches m ON s.match_id = m.id
JOIN scores opp ON m.id = opp.match_id AND opp.team_id != s.team_id
GROUP BY t.id, t.name
ORDER BY wins DESC;


-- 35. SURVEY COLLECTION SYSTEM QUERIES --

-- Count responses per question
SELECT q.id, q.question_text, COUNT(r.answer_text) as response_count
FROM questions q
LEFT JOIN responses r ON q.id = r.question_id
GROUP BY q.id, q.question_text;

-- Survey response summary
SELECT s.title, q.question_text, r.answer_text, COUNT(*) as count
FROM surveys s
JOIN questions q ON s.id = q.survey_id
JOIN responses r ON q.id = r.question_id
GROUP BY s.title, q.question_text, r.answer_text;


-- 36. IT SUPPORT TICKET SYSTEM QUERIES --

-- Average resolution time
SELECT AVG(resolved_at - created_at) as avg_resolution_time
FROM tickets
WHERE status = 'resolved';

-- Ticket volume by category
SELECT issue, COUNT(*) as ticket_count
FROM tickets
GROUP BY issue
ORDER BY ticket_count DESC;


-- 37. FOOD DELIVERY TRACKER QUERIES --

-- Delivery time analysis
SELECT AVG(delivered_at - placed_at) as avg_delivery_time
FROM orders
WHERE delivered_at IS NOT NULL;

-- Agent workload
SELECT da.name, COUNT(d.order_id) as delivery_count
FROM delivery_agents da
LEFT JOIN deliveries d ON da.id = d.agent_id
GROUP BY da.name
ORDER BY delivery_count DESC;


-- 38. QR CODE ENTRY LOG SYSTEM QUERIES --

-- Count entries per location
SELECT l.name, COUNT(el.id) as entry_count
FROM locations l
LEFT JOIN entry_logs el ON l.id = el.location_id
GROUP BY l.name
ORDER BY entry_count DESC;

-- Filter entries by date/time
SELECT u.name, l.name, el.entry_time
FROM entry_logs el
JOIN users u ON el.user_id = u.id
JOIN locations l ON el.location_id = l.id
WHERE el.entry_time BETWEEN '2023-01-01' AND '2023-01-31';


-- 39. FITNESS TRACKER DATABASE QUERIES --

-- Weekly summary per user
SELECT u.name, w.name as workout, 
       SUM(wl.duration) as total_duration
FROM users u
JOIN workout_logs wl ON u.id = wl.user_id
JOIN workouts w ON wl.workout_id = w.id
WHERE wl.log_date BETWEEN CURRENT_DATE - INTERVAL '7 days' AND CURRENT_DATE
GROUP BY u.name, w.name
ORDER BY u.name, total_duration DESC;


-- 40. FREELANCE PROJECT MANAGEMENT QUERIES --

-- Count projects per freelancer
SELECT f.name, COUNT(p.id) as project_count
FROM freelancers f
LEFT JOIN proposals pr ON f.id = pr.freelancer_id AND pr.status = 'accepted'
LEFT JOIN projects p ON pr.project_id = p.id
GROUP BY f.name
ORDER BY project_count DESC;

-- Average bid amount by skill
SELECT f.skill, AVG(pr.bid_amount) as avg_bid
FROM freelancers f
JOIN proposals pr ON f.id = pr.freelancer_id
GROUP BY f.skill
ORDER BY avg_bid DESC;


-- 41. RESTAURANT RESERVATION SYSTEM QUERIES --

-- Find overlapping reservations
SELECT r1.id, r1.table_id, r1.time_slot
FROM reservations r1
JOIN reservations r2 ON r1.table_id = r2.table_id 
                     AND r1.date = r2.date
                     AND r1.time_slot && r2.time_slot
                     AND r1.id != r2.id;

-- Daily reservation summary
SELECT date, COUNT(*) as reservation_count
FROM reservations
GROUP BY date
ORDER BY date;


-- 42. VEHICLE RENTAL SYSTEM QUERIES --

-- Currently rented vehicles
SELECT v.type, v.plate_number, c.name as customer
FROM rentals r
JOIN vehicles v ON r.vehicle_id = v.id
JOIN customers c ON r.customer_id = c.id
WHERE r.end_date > CURRENT_DATE;

-- Vehicle availability
SELECT v.type, v.plate_number
FROM vehicles v
WHERE v.id NOT IN (
    SELECT r.vehicle_id
    FROM rentals r
    WHERE r.start_date <= CURRENT_DATE 
    AND r.end_date >= CURRENT_DATE
);


-- 43. PRODUCT RETURN MANAGEMENT QUERIES --

-- Return status reporting
SELECT r.status, COUNT(*) as count
FROM returns r
GROUP BY r.status
ORDER BY count DESC;

-- JOIN orders with returns
SELECT o.id as order_id, r.reason, r.status
FROM orders o
LEFT JOIN returns r ON o.id = r.order_id
WHERE o.user_id = 123;


-- 44. COURSE FEEDBACK SYSTEM QUERIES --

-- Average rating per course
SELECT c.title, AVG(f.rating) as avg_rating
FROM courses c
LEFT JOIN feedback f ON c.id = f.course_id
GROUP BY c.title
ORDER BY avg_rating DESC;

-- Sentiment tracking (simple version)
SELECT c.title,
       COUNT(CASE WHEN f.rating >= 4 THEN 1 END) as positive,
       COUNT(CASE WHEN f.rating = 3 THEN 1 END) as neutral,
       COUNT(CASE WHEN f.rating <= 2 THEN 1 END) as negative
FROM courses c
LEFT JOIN feedback f ON c.id = f.course_id
GROUP BY c.title;


-- 45. JOB SCHEDULING SYSTEM QUERIES --

-- Last run status by job
SELECT j.name, jl.run_time, jl.status
FROM jobs j
LEFT JOIN job_logs jl ON j.id = jl.job_id
WHERE jl.run_time = (
    SELECT MAX(run_time)
    FROM job_logs
    WHERE job_id = j.id
);

-- Status count by job
SELECT j.name, jl.status, COUNT(*) as count
FROM jobs j
JOIN job_logs jl ON j.id = jl.job_id
GROUP BY j.name, jl.status
ORDER BY j.name, count DESC;


-- 46. MULTI-TENANT SAAS DATABASE QUERIES --

-- Tenant isolation query
SELECT u.name, d.content
FROM users u
JOIN data d ON u.tenant_id = d.tenant_id
WHERE u.tenant_id = 789;

-- Query partitioning by tenant
SELECT t.name as tenant, COUNT(u.id) as user_count
FROM tenants t
LEFT JOIN users u ON t.id = u.tenant_id
GROUP BY t.name
ORDER BY user_count DESC;


-- 47. COMPLAINT MANAGEMENT SYSTEM QUERIES --

-- Status summary
SELECT status, COUNT(*) as complaint_count
FROM complaints
GROUP BY status
ORDER BY complaint_count DESC;

-- Department workload
SELECT d.name, COUNT(c.id) as complaint_count
FROM departments d
LEFT JOIN complaints c ON d.id = c.department_id
GROUP BY d.name
ORDER BY complaint_count DESC;


-- 48. INVENTORY EXPIRY TRACKER QUERIES --

-- Expired stock alerts
SELECT p.name, b.quantity, b.expiry_date
FROM batches b
JOIN products p ON b.product_id = p.id
WHERE b.expiry_date < CURRENT_DATE;

-- Remaining stock query
SELECT p.name, SUM(b.quantity) as total_quantity
FROM products p
LEFT JOIN batches b ON p.id = b.product_id
WHERE b.expiry_date >= CURRENT_DATE OR b.expiry_date IS NULL
GROUP BY p.name
ORDER BY total_quantity DESC;


-- 49. PAYMENT SUBSCRIPTION TRACKER QUERIES --

-- Expired subscription check
SELECT u.name, s.plan_name, s.start_date,
       s.start_date + (s.renewal_cycle * INTERVAL '1 month') as renewal_date
FROM subscriptions s
JOIN users u ON s.user_id = u.id
WHERE s.start_date + (s.renewal_cycle * INTERVAL '1 month') < CURRENT_DATE;

-- Auto-renewal date logic
SELECT u.name, s.plan_name,
       s.start_date + (s.renewal_cycle * INTERVAL '1 month') as next_renewal
FROM subscriptions s
JOIN users u ON s.user_id = u.id
WHERE s.start_date + (s.renewal_cycle * INTERVAL '1 month') BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '7 days';


-- 50. EVENT MANAGEMENT SYSTEM QUERIES --

-- Event-wise participant count
SELECT e.title, COUNT(a.user_id) as attendee_count
FROM events e
LEFT JOIN attendees a ON e.id = a.event_id
GROUP BY e.title
ORDER BY attendee_count DESC;

-- Capacity alerts
SELECT e.title, e.max_capacity, COUNT(a.user_id) as current_attendees,
       CASE WHEN COUNT(a.user_id) >= e.max_capacity THEN 'FULL' ELSE 'AVAILABLE' END as status
FROM events e
LEFT JOIN attendees a ON e.id = a.event_id
GROUP BY e.title, e.max_capacity
ORDER BY status, e.title;