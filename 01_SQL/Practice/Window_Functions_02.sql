CREATE TABLE monthly_sales (
    month_no INT,
    month_name VARCHAR(10),
    sales INT
);

INSERT INTO monthly_sales
VALUES
(1,'Jan',100),
(2,'Feb',120),
(3,'Mar',150),
(4,'Apr',130),
(5,'May',170),
(6,'Jun',200);

select * from monthly_sales;

--Write a query showing:Month, Sales, Previous Month Sales
select month_name, sales, lag(sales) over(order by month_no) as Previous_Month_Sales
from monthly_sales;

--Write a query showing:Month, Sales, Previous Month Sales, Difference
select month_name , sales , lag(sales ) over(order by month_no ) as Previous_Month_Sales, sales - lag(sales ) over(order by month_no ) as Difference 
from monthly_sales;

--Write a query showing:Month, Sales, Previous Month Sales, Growth %
select month_name , sales, lag(sales) over(order by month_no ) as Previous_Month_Sales, 
round(
(
(sales - 
lag(sales)
over(order by month_no))
*100.0
)
/
lag(sales ) over(order by month_no),2
) as Growth
from monthly_sales;

--Write a query showing:Month, Sales, Next Month Sales
select month_name , sales , lead(sales) over(order by month_no) as Nect_Month_Sales
from monthly_sales;

--Write a query showing:Month, Sales, Running Total
select month_name , sales , sum(sales ) over(order by month_no ) as Running_Total
from monthly_sales;

--Write a query showing:Month, Sales, Running Average
select month_name , sales , Avg(sales ) over(order by month_no ) as Running_Average
from monthly_sales;

--Which month had the highest increase compared to the previous month?
WITH growth_sales AS
(
    SELECT month_name,
           sales,
           sales - LAG(sales)
           OVER(ORDER BY month_no) AS difference
    FROM monthly_sales
)
SELECT *
FROM growth_sales
where difference is not Null
ORDER BY difference DESC
LIMIT 1;

--Practice 1 Show:Month, Sales, First Month Sales, Difference From First Month
select month_name , sales , first_value(sales ) over(order by month_no ) as First_Month_Sales, sales - first_value(sales ) over(order by month_no ) as diff
from monthly_sales;

--Practice 2 Show:Month, Sales, Final Month Sales, Difference From Final Month
select month_name , sales , last_value(sales) over(order by month_no rows between unbounded preceding and unbounded following) as last_Month_Sales, sales - last_value(sales) over(order by month_no rows between unbounded preceding and unbounded following) as diff
from monthly_sales;

--Practice 3 Divide months into: Top Half and Bottom Half, using: NTILE(2)
select *, ntile(2) over(order by sales desc) as bucket
from monthly_sales;

--Practice 4 ⭐ Show: Month, Sales, 3-Month Moving Average
select month_name , sales , AVG(sales) over(order by month_no rows between 2 preceding and current row) as three_Month_Moving_Average
from monthly_sales;

--Mini Case Study
--Which month had the highest sales?
with sales_rank as
(
select *, row_number() over(order by sales desc) as RW
from monthly_sales
)
select month_name,sales  
from sales_rank
where Rw =1;

--Which month had the lowest sales?
with sales_rank as
(
select *, row_number() over(order by sales) as RW
from monthly_sales
)
select month_name,sales  
from sales_rank
where Rw =1;

--Which months are above average sales?
with sales_ma as
(
select *, AVG(sales ) over() as avg
from monthly_sales
)
select month_name,sales  
from sales_ma
where sales > avg;

--Rank months by sales.
select month_name , sales,  Rank() over(order by sales desc)
from monthly_sales;

--⭐ Show: Month, Sales, Previous Month Sales, Growth %, Rank by Sales, Running Total

select month_name,
sales ,
lag(sales) over(order by month_no ) as PMS,
Round(
((sales - lag(sales) over(order by month_no )) * 100.0 / lag(sales) over(order by month_no ))
,2) as Growth,
Rank() over(order by sales desc) as RBS,
sum(sales) over(order by month_no ) as RT
from monthly_sales;