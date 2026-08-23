TRUNCATE TABLE orders_date;

INSERT INTO orders_date
VALUES
(1,'2024-01-15',1000),
(2,'2024-01-25',1500),
(3,'2024-02-10',2000),
(4,'2024-02-20',2500),
(5,'2024-03-05',3000),
(6,'2024-03-18',3500),
(7,'2024-04-08',1800),
(8,'2024-04-22',2200),
(9,'2024-05-12',2800),
(10,'2024-05-25',3200),
(11,'2024-06-10',3500),
(12,'2024-06-20',4000);

select * from orders_date od ;


--Q1 — Month End Date Show: Order Date, Month Start, Month End
select od.order_date , date_trunc('month', od.order_date )::date as month_start, (date_trunc('month', od.order_date ) + '1 month -1'):: date as Month_end
from orders_date od ;

--Q2 — Quarter Revenue Show: Quarter, Revenue
select date_trunc('Quarter', od.order_date )::date as Quarter, sum(od.revenue ) 
from orders_date od 
group by quarter 
order by quarter ;

--Q3 — Quarter + Year Show: Year, Quarter
select extract(Quarter from od.order_date ) as Quarter, extract(Year from od.order_date ) as year, sum(od.revenue)
from orders_date od 
group by Quarter, year;

--Q4 ⭐ — Running 3-Month Revenue Show: Month, Revenue, 3-Month Revenue
select date_trunc('month', od.order_date )::date as month,
sum(od.revenue),
sum(sum(od.revenue )) over(order by date_trunc('month', od.order_date ) rows between 2 preceding and current row)
from orders_date od
group by  DATE_TRUNC('month', od.order_date)
order by month ;

--Q5 ⭐ — 3-Month Moving Average Show: Month, Revenue, 3-Month Moving Average
select date_trunc('month', od.order_date )::date as month,
sum(od.revenue),
avg(sum(od.revenue )) over(order by date_trunc('month', od.order_date ) rows between 2 preceding and current row)
from orders_date od
group by  DATE_TRUNC('month', od.order_date)
order by month ;

--Q6 ⭐⭐ — Current Month vs Previous Month Show: Month, Revenue, Previous Month Revenue, Difference, Growth %
with order_stats as (
select date_trunc('month',od.order_date )::date as month,
sum(od.revenue ) as rev
from orders_date od 
group by date_trunc('month',od.order_date )
)
select month, rev, lag(rev)  over(order by month) as PMR,
rev - lag(rev)  over(order by month) as diff,
round(
(
((rev - lag(rev)  over(order by month))/lag(rev)  over(order by month) *100.0)
)
,2) as growth
from order_stats;