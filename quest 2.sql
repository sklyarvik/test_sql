--Создание тестовых таблиц
CREATE TABLE IF NOT EXISTS employee (
    id int PRIMARY KEY,
    name VARCHAR
);
CREATE TABLE IF NOT EXISTS sales (
    id int PRIMARY KEY,
    employee_id int,
    price int
);
--Наполняем тестовыми данными
TRUNCATE TABLE employee;
TRUNCATE TABLE sales;

INSERT INTO employee(ID, name) VALUES (1, 'Иван');
INSERT INTO employee(ID, name) VALUES (2, 'Виталий');
INSERT INTO employee(ID, name) VALUES (3, 'John');

INSERT INTO sales(ID, employee_id, price) VALUES (1, 1, 100);
INSERT INTO sales(ID, employee_id, price) VALUES (2, 2, 1000);
INSERT INTO sales(ID, employee_id, price) VALUES (3, 1, 300);
INSERT INTO sales(ID, employee_id, price) VALUES (4, 3, 2000);
INSERT INTO sales(ID, employee_id, price) VALUES (5, 2, 150);
INSERT INTO sales(ID, employee_id, price) VALUES (6, 3, 12000);
INSERT INTO sales(ID, employee_id, price) VALUES (7, 1, 1000);
INSERT INTO sales(ID, employee_id, price) VALUES (8, 2, 150);
INSERT INTO sales(ID, employee_id, price) VALUES (9, 2, 1);

--Задание
WITH SalesSummary AS (
  SELECT
    e.id AS employee_id,
    e.name AS employee_name,
    COUNT(s.id) AS total_sales_count,
    SUM(s.price) AS total_sales_sum
  FROM
    employee e
  LEFT JOIN
    sales s ON e.id = s.employee_id
  GROUP BY
    e.id, e.name
)
SELECT
  employee_id,
  employee_name,
  total_sales_count,
  total_sales_sum,
  RANK() OVER (ORDER BY total_sales_count DESC) AS sales_rank_by_count,
  RANK() OVER (ORDER BY total_sales_sum DESC) AS sales_rank_by_sum
FROM
  SalesSummary
ORDER BY
  total_sales_count DESC, total_sales_sum DESC;
