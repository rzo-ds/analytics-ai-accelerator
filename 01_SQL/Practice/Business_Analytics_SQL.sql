CREATE TABLE sales_data (
    order_id INT,
    customer_name VARCHAR(50),
    product_name VARCHAR(50),
    order_date DATE,
    quantity INT,
    sales_amount INT
);

INSERT INTO sales_data
VALUES
(1,'Amit','Laptop','2026-01-05',1,50000),
(2,'Neha','Mouse','2026-01-10',2,2000),
(3,'Rahul','Keyboard','2026-01-15',1,3000),
(4,'Priya','Laptop','2026-02-01',1,52000),
(5,'Amit','Monitor','2026-02-12',1,12000),
(6,'Neha','Laptop','2026-02-18',1,51000),
(7,'Rahul','Mouse','2026-03-02',3,3000),
(8,'Priya','Keyboard','2026-03-08',2,6000),
(9,'Amit','Laptop','2026-03-15',1,53000),
(10,'Neha','Monitor','2026-03-20',1,13000);

SELECT *
FROM sales_data;


--Q1 Show:Product Name, Total Quantity Sold - Sort highest quantity first.
select product_name , sum(quantity ) as TQD
from sales_data
group by product_name
order by TQD desc;

--Q2 Show:Customer Name, Total Orders - Sort highest orders first.
select customer_name , count(customer_name) as Total_order
from sales_data
group by customer_name 
order by Total_order desc ;

--Q3 Find:Top Revenue Customer - Return: Customer Name, Revenue
with sales_stats as 
(
select customer_name , SUM(sales_amount ) as Revenue, row_number() over(order by SUM(sales_amount ) desc) as rn
from sales_data
group by customer_name
)
select customer_name, revenue  
from sales_stats
where rn=1;

--Q4 Find:Top Revenue Product - Return: Product Name, Revenue
with sales_stats as 
(
select product_name , SUM(sales_amount ) as Revenue, row_number() over(order by SUM(sales_amount ) desc) as rn
from sales_data
group by product_name 
)
select product_name , revenue  
from sales_stats
where rn=1;

--Q5 ⭐ Show:Month, Revenue - Using:DATE_TRUNC - Sort month ascending.
select date_trunc('month', order_date) as month, SUM(sales_amount) as Revenue
from sales_data
group by "month" 
order by "month" ;

--Q6 ⭐ Show: Customer Name, Revenue, Revenue Rank
select customer_name , SUM(sales_amount ) as Revenue, rank() over(order by SUM(sales_amount ) desc)
from sales_data
group by customer_name ;

--Q7 — Running Revenue Show: Month, Revenue, Running Revenue
select date_trunc('month', order_date) as month , sum(sales_amount ) as Revenue, sum(sum(sales_amount )) over(order by date_trunc('month', order_date)) as Running_Revenue
from sales_data
group by "month" ;

--Q8 — Revenue Contribution % Show: Customer, Revenue, Contribution %
select  customer_name, sum(sales_amount ) as revenue, round((sum(sales_amount )/sum(sum(sales_amount)) over()) *100,2) as contribution
from sales_data
group by customer_name
order by revenue desc;

--Q9 — Top 2 Customers By Revenue - Return: Customer, Revenue, Rank
with sales_rank as (
select customer_name , sum(sales_amount ) as revenue, rank() over(order by sum(sales_amount ) desc)
from sales_data
group by customer_name)
select *
from sales_rank
where rank <=2;

--Q10 ⭐ Month-over-Month Growth % - Show:, Month, Revenue, Previous Month Revenue, Growth %

select Date_trunc('month',order_date ) as month, SUM(sales_amount ) as revenue,
lag(SUM(sales_amount )) over(order by Date_trunc('month',order_date )) as PMR,
Round(
((SUM(sales_amount )-lag(SUM(sales_amount )) over(order by Date_trunc('month',order_date ))) *100.0 / lag(SUM(sales_amount )) over(order by Date_trunc('month',order_date )) )
,2) as Growth
from sales_data
group by month
order by month;
