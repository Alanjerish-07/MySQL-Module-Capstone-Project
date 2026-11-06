CREATE DATABASE elearning;
USE elearning;

-- 1. Learners
CREATE TABLE learners (
    learner_id INT PRIMARY KEY,
    full_name VARCHAR(50),
    country VARCHAR(30)
);

-- 2. Courses
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    category VARCHAR(30),
    unit_price DECIMAL(10,2)
);

-- 3. Purchases
CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY,
    learner_id INT,
    course_id INT,
    quantity INT,
    purchase_date DATE,
    FOREIGN KEY (learner_id) REFERENCES learners(learner_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Sample Data
INSERT INTO learners VALUES
(1,'Arun','India'),
(2,'Priya','India'),
(3,'John','USA'),
(4,'Sara','UK'),
(5,'Kavin','India');

INSERT INTO courses VALUES
(101,'Python','Programming',5000),
(102,'SQL','Database',4000),
(103,'Power BI','Analytics',4500),
(104,'Excel','Analytics',3000),
(105,'Java','Programming',5500);

INSERT INTO purchases VALUES
(1,1,101,2,'2026-01-10'),
(2,1,102,1,'2026-01-12'),
(3,2,103,2,'2026-02-05'),
(4,3,101,1,'2026-02-10'),
(5,4,104,3,'2026-03-01'),
(6,5,102,2,'2026-03-05'),
(7,5,103,1,'2026-03-08'),
(8,2,101,1,'2026-03-15');

-- INNER JOIN
SELECT l.full_name, c.course_name, c.category,
       p.quantity,
       FORMAT(p.quantity*c.unit_price,2) AS total_amount,
       p.purchase_date
FROM purchases p
INNER JOIN learners l ON p.learner_id=l.learner_id
INNER JOIN courses c ON p.course_id=c.course_id
ORDER BY total_amount DESC;

-- LEFT JOIN
SELECT l.full_name, c.course_name, p.quantity
FROM learners l
LEFT JOIN purchases p ON l.learner_id=p.learner_id
LEFT JOIN courses c ON p.course_id=c.course_id;

-- RIGHT JOIN
SELECT c.course_name, c.category, p.quantity
FROM purchases p
RIGHT JOIN courses c ON p.course_id=c.course_id;

-- Q1. Total spending of each learner
SELECT l.full_name, l.country,
       FORMAT(SUM(p.quantity*c.unit_price),2) AS total_spending
FROM learners l
LEFT JOIN purchases p ON l.learner_id=p.learner_id
LEFT JOIN courses c ON p.course_id=c.course_id
GROUP BY l.learner_id, l.full_name, l.country
ORDER BY total_spending DESC;

-- Q2. Top 3 purchased courses
SELECT c.course_name,
       SUM(p.quantity) AS total_quantity
FROM purchases p
JOIN courses c ON p.course_id=c.course_id
GROUP BY c.course_id, c.course_name
ORDER BY total_quantity DESC
LIMIT 3;

-- Q3. Category revenue and unique learners
SELECT c.category,
       FORMAT(SUM(p.quantity*c.unit_price),2) AS total_revenue,
       COUNT(DISTINCT p.learner_id) AS unique_learners
FROM purchases p
JOIN courses c ON p.course_id=c.course_id
GROUP BY c.category
ORDER BY total_revenue DESC;

-- Q4. Learners purchasing from more than one category
SELECT l.full_name,
       COUNT(DISTINCT c.category) AS category_count
FROM learners l
JOIN purchases p ON l.learner_id=p.learner_id
JOIN courses c ON p.course_id=c.course_id
GROUP BY l.learner_id, l.full_name
HAVING COUNT(DISTINCT c.category) > 1;

-- Q5. Courses not purchased
SELECT c.course_id, c.course_name, c.category
FROM courses c
LEFT JOIN purchases p ON c.course_id=p.course_id
WHERE p.purchase_id IS NULL; 