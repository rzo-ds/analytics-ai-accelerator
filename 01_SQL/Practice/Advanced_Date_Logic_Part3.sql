select * from orders_date od ;


/*
Q1 — YTD Revenue by Year

Imagine your table has multiple years.

Show:

Year
Month
Revenue
YTD Revenue
*/

select od.order_date, extract(month from od.order_date ) as month, extract(Year from od.order_date ) as year , 
sum(od.revenue)  over(partition by extract(Year from od.order_date ) order by od.order_date rows between unbounded preceding and current row  ) as YTD
from orders_date od
order by od.order_date;

/*
 Q2 — Month-to-Date (MTD)

For our monthly dataset:

Month Revenue = MTD Revenue

But if data were daily:

Date
Revenue
MTD Revenue

Show MTD revenue restarting every month.
 */
select od.order_date, od.revenue,
sum(od.revenue)  over(partition by extract(year from od.order_date ), extract(month from od.order_date )   order by od.order_date rows between unbounded preceding and current row ) as MTD
from orders_date od
order by od.order_date;

/*
 Q3 ⭐ Fiscal Year (April–March)

Very important because you've already worked with April–March fiscal calendars in Power BI.

Create:
Month
Fiscal Year

Logic:
Apr 2024 → FY 2024-25
May 2024 → FY 2024-25
...
Mar 2025 → FY 2024-25
Apr 2025 → FY 2025-26
 */

with fiscal as 
(
select extract(month from od.order_date ) as mon, extract(year from od.order_date) as yr
from orders_date od
)
select "mon" ,
"yr" ,
case
	when mon <=3 then 'FY ' || yr-1 || '-' || right(yr::text,2)
	when mon >=4 then 'FY ' || yr || '-' || right((yr+1)::text, 2)
	else 'Other Ficsl Yer'
end as Fiscal_Year
from fiscal; 

/*
Q4 ⭐ Revenue by Fiscal Year

Show:

Fiscal Year
Revenue

Use the fiscal year logic from Q3.
*/
with fiscal as 
(
select od.revenue,
case
	when extract(month from od.order_date ) <=3 then 'FY ' || extract(year from od.order_date )-1 || '-' || right(extract(year from od.order_date )::text,2)
	when extract(month from od.order_date ) >=4 then 'FY ' || extract(year from od.order_date ) || '-' || right((extract(year from od.order_date )+1)::text, 2)
	else 'Other Ficsl Yer'
end as Fiscal_Year
from orders_date od
)
select Fiscal_Year, sum(revenue)
from fiscal
group by fiscal.fiscal_year 
order by fiscal.fiscal_year ;

--Q5 ⭐⭐ Rolling 12-Month Revenue
with RM as
(
select date_trunc('month', od.order_date)::date as mon, sum(od.revenue ) as revenue
from orders_date od 
group by date_trunc('month', od.order_date)
order by date_trunc('month', od.order_date)
)
select mon , revenue ,
sum(revenue ) over(order by mon rows between 11 preceding and current row ) as R12M
from RM;

/*Q6 ⭐⭐ Interview Question

Show:
Month
Revenue
Previous Month Revenue
3-Month Moving Average
YTD Revenue*/

with ods as
(
select date_trunc('month', od.order_date )::date as mon, sum(revenue) as rev
from orders_date od
group by date_trunc('month', od.order_date )
)
select mon , rev ,
lag(rev ) over (order by mon ) as PMR,
avg(rev) over(order by mon rows between 2 preceding and current row ) as AVG,
sum(rev) over(partition by date_trunc('year', mon ) order by mon rows between unbounded preceding and current row) as ytd
