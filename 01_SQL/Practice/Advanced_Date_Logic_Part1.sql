--Advanced Date Logic — Part 1

CREATE TABLE orders_date (
    order_id INT,
    order_date DATE,
    revenue NUMERIC
);

INSERT INTO orders_date
VALUES
(1,'2024-01-15',1000),
(2,'2024-01-25',1500),
(3,'2024-02-10',2000),
(4,'2024-02-20',2500),
(5,'2024-03-05',3000),
(6,'2024-03-18',3500);

select *
from orders_date od ;

--Q1 Show: Order ID, Order Date, Month Start Date
select od.order_id , od.order_date , date_trunc('month', od.order_date )
from orders_date od;

--Q2 Show: order ID, Order Date, Month Number, Quarter, Year
select od.order_id , od.order_date , Extract(month from od.order_date ) as Month_numer, Extract(Quarter from od.order_date ) as Quarter, Extract(Year from od.order_date ) as year
from orders_date od ;

--Q3 Show: month, Revenue
select date_trunc('Month', od.order_date) as month, sum(od.revenue ) as rev
from orders_date od 
group by "month" 
order by "month" ;

--Q4 Show: Month, Revenue, Previous Month Revenue
select date_trunc('Month', od.order_date) as month, sum(od.revenue ) as rev,
lag(sum(od.revenue )) over(order by date_trunc('Month', od.order_date) ) as pmr
from orders_date od 
group by "month" 
order by "month" ;

--Q5 ⭐ Show: Month, Revenue, Previous Month Revenue, Growth %
select date_trunc('Month', od.order_date) as month, sum(od.revenue ) as rev,
lag(sum(od.revenue )) over(order by date_trunc('Month', od.order_date) ) as pmr,
round(
(
(sum(od.revenue )-lag(sum(od.revenue )) over(order by date_trunc('Month', od.order_date) ))/lag(sum(od.revenue )) over(order by date_trunc('Month', od.order_date) ) * 100.0
)
,2) as growth
from orders_date od 
group by "month" 
order by "month" ;

--Q6 ⭐⭐ Show: month, Revenue, YTD Revenue - (YTD = cumulative revenue from start of year)
select date_trunc('Month', od.order_date) as month, sum(od.revenue ) as rev,
sum(sum(od.revenue )) over(order by date_trunc('Month', od.order_date) ) as YTD
from orders_date od 
group by "month" 
order by "month" ;