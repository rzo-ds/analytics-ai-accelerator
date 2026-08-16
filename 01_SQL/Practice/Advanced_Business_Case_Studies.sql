CREATE TABLE customer_orders (
    order_id INT,
    customer_name VARCHAR(50),
    order_date DATE,
    amount INT
);

INSERT INTO customer_orders
VALUES
(1,'Amit','2024-01-05',1000),
(2,'Amit','2024-01-20',1500),
(3,'Neha','2024-01-10',2000),
(4,'Rahul','2024-02-01',3000),
(5,'Amit','2024-02-15',2500),
(6,'Neha','2024-02-20',1800),
(7,'Priya','2024-03-01',4000),
(8,'Rahul','2024-03-10',2200),
(9,'Amit','2024-03-25',3500);

select *
from customer_orders;

--Q1 — Customer Revenue Show: Customer, Revenue - Sort highest revenue first.
select customer_name, SUM(amount) as revenue
from customer_orders
group by customer_name
order by revenue desc;


--Q2 — Customer Revenue Rank Show: Customer, Revenue, Revenue Rank
select customer_name , SUM(amount ) as revenue, rank() over(order by SUM(amount ) desc) as revenue_rank
from customer_orders
group by customer_name
order by revenue desc;

--Q3 — Running Revenue By Customer Show: Customer, Order Date, Amount, Running Revenue
select customer_name, order_date , amount, sum(amount ) over(partition by customer_name order by order_date ) as Running_revenue
from customer_orders;

--Q4 — Previous Order Amount Show: Customer, Order Date, Amount, Previous Order Amount
select customer_name , order_date , amount , lag(amount ) over(partition by customer_name order by order_date ) as POA
from customer_orders;

--Q5 — Difference From Previous Order Show: Customer, Order Date, Amount, Previous Amount, Difference
select customer_name , order_date , amount , lag(amount ) over (partition by customer_name order by order_date ) as PA, amount- lag(amount ) over (partition by customer_name order by order_date ) as Difference
from customer_orders;

--Q6 — First Order Amount Show: Customer, Order Date, Amount, First Order Amount
select customer_name, order_date , amount , first_value(amount ) over(partition by customer_name order by order_date ) as foa
from customer_orders;

--Q7 — Latest Order Amount Show: Customer, Order Date, Amount, Latest Order Amount
select customer_name , order_date , amount , last_value(amount ) over (partition by customer_name order by order_date rows between unbounded preceding and unbounded following) as loa
from customer_orders;

--Q8 — Customer Lifetime Revenue Show: Customer , Order Date, Amount, Lifetime Revenue - Every row of a customer should show the same total revenue.
select customer_name ,order_date , amount , sum(amount ) over(partition by customer_name ) as LTR
from  customer_orders;

--Q9 ⭐ Highest Order For Each Customer Return: Customer, Order Date, Amount
with amount_rank as (
select customer_name , order_date , amount , rank() over(partition by customer_name order by amount desc ) as rnk
from customer_orders)
select customer_name , order_date , amount 
from amount_rank
where rnk=1;

--Q10 ⭐⭐ Analyst Interview Question Show: Customer. Order Date, Amount, Customer Revenue Rank - Rank customers based on: Total Revenue not individual orders.
with sr as 
(
select customer_name ,   sum(amount ) as TR, rank() over(order by sum(amount ) desc) as rn
from customer_orders
group by customer_name)
select co.customer_name , co.order_date , co.amount, sr.rn
from customer_orders co
join sr 
on co.customer_name = sr.customer_name 
order by sr.rn, co.order_date;