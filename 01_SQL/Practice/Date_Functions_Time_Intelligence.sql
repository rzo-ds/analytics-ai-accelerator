/*
===========================================
Module: Date Functions & Time Intelligence
Date: 10-Aug-2026
Database: PostgreSQL

Topics Covered:
1. EXTRACT()
2. DATE_TRUNC()
3. AGE()
4. INTERVAL
5. TO_CHAR()
6. Monthly Sales Analysis
7. Relative Date Filtering

Author: Arzoo Gupta
===========================================
*/


CREATE TABLE orders (
    order_id INT,
    customer_name VARCHAR(50),
    order_date DATE,
    amount INT
);

INSERT INTO orders
VALUES
(1,'Amit','2026-01-15',5000),
(2,'Neha','2026-02-10',7000),
(3,'Rahul','2026-02-25',3000),
(4,'Priya','2026-03-12',8000),
(5,'Amit','2026-03-28',6000),
(6,'Neha','2026-04-15',9000),
(7,'Rahul','2026-05-05',4000),
(8,'Priya','2026-05-20',7500);

select * from orders ;

--Q1 Show:Order ID, Order Date, year, month, Day using Extract()
select order_id, order_date, extract(year from order_date) as year, extract(month from order_date) as month, extract(day from order_date) as day
from orders;

--Q2 Show:Order ID, Order Date, Month Start Date using DATE_TRUNC()
select order_id, order_date , DATE_TRUNC('month', order_date )
from orders;

--Q3 Find total sales by month.
with orders_stats as 
(
select *, DATE_TRUNC('month', order_date ) as month
from orders
)
select month, SUM(amount)
from orders_stats
group by month
order by month;

--Q4 Show:Order ID, Order Date, Days Since Order Using Age()
select order_id , order_date , Age(current_date,order_date)
from orders;

--Q5 Show:Order Date, Expected Delivery Date using INTERVAL
select order_date , order_date + interval '7 days' as expected_delivery_date
from orders;

--Q6 Show: Order ID, Order Date, Month Name using TO_CHAR()
select order_id, order_date ,to_char(order_date , 'Month') as month
from orders;

--Q7 ⭐ Find total sales by Month Name.
select to_char(order_date, 'Month') as month, sum(amount)
from orders
group by month;

--Q8 ⭐⭐ Find orders placed in the last 60 days.
select * 
from orders
where order_date > current_date - interval '60 days';