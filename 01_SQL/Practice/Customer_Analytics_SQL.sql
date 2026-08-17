CREATE TABLE customer_purchases (
    order_id INT,
    customer_name VARCHAR(50),
    order_date DATE,
    amount INT
);

INSERT INTO customer_purchases
VALUES
(1,'Amit','2026-01-05',500),
(2,'Neha','2026-01-10',300),
(3,'Amit','2026-02-15',700),
(4,'Rahul','2026-02-20',400),
(5,'Neha','2026-03-05',600),
(6,'Amit','2026-03-12',800),
(7,'Rahul','2026-03-25',500),
(8,'Priya','2026-04-10',900),
(9,'Amit','2026-04-15',400),
(10,'Neha','2026-04-22',700);

select *
from customer_purchases cp ;


--Part A — Customer Fundamentals

--Q1 Show: Customer, Total Revenue - Sort highest revenue first.
select customer_name , sum(amount ) as total_revenue
from customer_purchases
group by customer_name 
order by total_revenue desc;

--Q2 Show: Customer, Total Orders - Sort highest orders first.
select customer_name , count(*) as Total_order
from customer_purchases
group by customer_name 
order by total_order desc;

--Q3 Show: Customer, Average Order Value
select customer_name , avg(amount ) as aov
from customer_purchases 
group by customer_name
order by aov desc;

--Q4 Find: Top Revenue Customer Return: Customer,Revenue
with crr as 
(
select customer_name , SUM(amount ) as revenue, rank() over(order by SUM(amount ) desc) as rn
from customer_purchases
group by customer_name 
)
select customer_name , revenue 
from crr
where rn =1;

--Q5 Find: Customer with Most Orders Return: Customer,Orders
with cor as 
(
select customer_name , count(* ) as orders, rank() over(order by count(* ) desc) as rn
from customer_purchases
group by customer_name 
)
select customer_name , orders , rn
from cor
where rn =1;

--Part B — Customer Lifetime Analytics

--Q6 Show:Customer, Order Date, Amount, Customer Lifetime Revenue
select customer_name , order_date , amount , sum(amount ) over(partition by customer_name ) as CLR
from customer_purchases;

--Q7 Show: Customer, Order Date, Amount, Running Customer Revenue
select customer_name , order_date , amount , sum(amount ) over(partition by customer_name order by order_date ) as RCR
from customer_purchases;

--Q8 Show: Customer, Order Date, Amount, Previous Purchase Amount
select customer_name , order_date , amount , lag(amount ) over(partition by customer_name order by order_date ) as PPA
from customer_purchases;

--Q9 Show: Customer, Order Date, Amount, Difference From Previous Purchase
select customer_name , order_date , amount , amount - lag(amount ) over(partition by customer_name order by order_date ) as DFPP
from customer_purchases;

--Q10 ⭐ Show: Customer, Revenue, Contribution % - Contribution to total company revenue.
with CPC as 
(
select customer_name ,
SUM(amount ) as Revenue
from customer_purchases 
group by customer_name
)
select *,
round((revenue /sum(revenue ) over()) * 100.0, 2) as contribution
from cpc
order by contribution desc; 

--Part C — Interview Level

--Q11 ⭐⭐ For each customer find: First Purchase Date - Expected: Customer, First Purchase Date
with CRP as
(
select customer_name , order_date as FPD, rank() over(partition by customer_name order by order_date ) as rn
from customer_purchases
)
select * 
from crp
where rn=1;

--Q12 ⭐⭐ For each customer find: Latest Purchase Date - Expected: Customer, Latest Purchase Date
with CRP as
(
select customer_name , order_date as LPD, rank() over(partition by customer_name order by order_date desc) as rn
from customer_purchases
)
select * 
from crp
where rn=1;

--Q13 ⭐⭐ Find customers with: More than 2 purchases
with COC as 
(
select customer_name, count(*) as orders
from customer_purchases
group by customer_name)
select *
from coc
where orders >2
order by orders desc;

--Q14 ⭐⭐⭐ For each customer show: Customer, First Purchase Date, Latest Purchase Date, Lifetime Revenue, Total Orders
select customer_name, min(order_date ) as FPD, max(order_date ) as LPD, sum(amount ) as LTR, count(*) as Total_orders
from customer_purchases
group by customer_name 
order by total_orders desc;
