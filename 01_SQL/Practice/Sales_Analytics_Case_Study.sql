CREATE TABLE sales_orders (
    order_id INT,
    customer_name VARCHAR(50),
    product_name VARCHAR(50),
    order_date DATE,
    sales_amount INT
);

INSERT INTO sales_orders
VALUES
(1,'Amit','Laptop','2024-01-05',50000),
(2,'Neha','Mouse','2024-01-10',1000),
(3,'Amit','Keyboard','2024-01-15',2000),
(4,'Rahul','Laptop','2024-02-01',50000),
(5,'Priya','Monitor','2024-02-05',12000),
(6,'Amit','Mouse','2024-02-10',1000),
(7,'Neha','Laptop','2024-03-01',50000),
(8,'Rahul','Keyboard','2024-03-05',2000),
(9,'Priya','Laptop','2024-03-15',50000),
(10,'Amit','Monitor','2024-03-20',12000);

select *
from sales_orders;

--Part A — Basic Analytics

--Q1 Show: Product Name, Revenue - Sort highest revenue first.
select product_name , sum(sales_amount) as revenue
from sales_orders
group by product_name
order by revenue desc;

--Q2 Show: Customer Name, Revenue - Sort highest revenue first.
select customer_name  , sum(sales_amount) as revenue
from sales_orders
group by customer_name 
order by revenue desc;

--Q3 Show: Month, Revenue
select date_trunc('month', order_date ) as month, sum(sales_amount ) as revenue
from sales_orders
group by month
order by month desc;

--Q4 Show: Month, Revenue, Revenue Rank	
select date_trunc('month', order_date ) as month, sum(sales_amount) as revenue, rank() over(order by sum(sales_amount) desc) as rn
from sales_orders
group by month
order by rn ;

--Part B — Window Functions

--Q5 Show: Customer, Order Date, Sales Amount, Running Revenue
select customer_name , order_date , sales_amount , sum(sales_amount ) over(PARTITION BY customer_name order by order_date ) as running_revenue
from sales_orders;

--Q6 Show: Customer, Order Date, Sales Amount, Previous Order Amount
select customer_name , order_date , sales_amount , lag(sales_amount ) over(PARTITION BY customer_name order by order_date ) as POA
from sales_orders;

--Q7 Show: Customer, Order Date, Sales Amount, Lifetime Revenue
select customer_name, order_date , sales_amount , sum(sales_amount) over(PARTITION BY customer_name) as LTR
from sales_orders ;

--Q8 Show: Customer, Revenue, Contribution %
with  sales_stats as (
select customer_name , sum(sales_amount ) as revenue
from sales_orders
group by customer_name)
select *,
round(
(revenue / sum(revenue ) over()) *100.0 
,2) as Contribution
from sales_stats
order by contribution desc;

--Part C — Interview Level


--Q9 ⭐ Find: Top Revenue Product. Return: Product, Revenue
with ss as
(
select product_name ,
sum(sales_amount ) as Revenue,
rank() over(order by sum(sales_amount ) desc) as rn
from sales_orders
group by product_name
)
select *
from ss
where rn=1;

--Q10 ⭐ Find: Top Revenue Customer. Return: Customer, Revenue
with ss as
(
select customer_name  ,
sum(sales_amount ) as Revenue,
rank() over(order by sum(sales_amount ) desc) as rn
from sales_orders
group by customer_name 
)
select *
from ss
where rn=1;

--Q11 ⭐⭐ For each month: Find the highest revenue customer. Expected: Month, Customer, Revenue 


-- Approach1 
with ss as 
(
select distinct date_trunc('month', order_date ) as month,
customer_name  ,
sum(sales_amount) over(partition by  date_trunc('month', order_date ), customer_name ) as revenue
from sales_orders
order by "month"
),
ranked_data as 
(
select *, rank() over(partition by "month"  order by revenue desc) as rn
from ss
)
select * 
from ranked_data
where rn=1
order by "month" ;

--Approach 2
select  date_trunc('month', order_date ) as month,
customer_name  ,
sum(sales_amount) 
from sales_orders
group by "month", customer_name 
order by "month";

--Q12 ⭐⭐ For each month: Find the highest revenue product.  Expected: Month, Product, Revenue
with ss as 
(
select distinct date_trunc('month', order_date) as month,
product_name ,
SUM(sales_amount ) over(partition by date_trunc('month', order_date), product_name ) as revenue
from sales_orders
)
,
ranked_ss as
(
select *, rank() over(partition by "month" order by revenue desc) as rn
from ss
)
select *
from ranked_ss
where rn=1
order by month;

