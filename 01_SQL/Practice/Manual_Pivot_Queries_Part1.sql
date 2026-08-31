CREATE TABLE sales_data1 (
    customer_name VARCHAR(50),
    month VARCHAR(10),
    revenue NUMERIC
);

INSERT INTO sales_data1
VALUES
('A', 'Jan', 1000),
('A', 'Feb', 1500),
('A', 'Mar', 2000),
('B', 'Jan', 1200),
('B', 'Feb', 1800),
('B', 'Mar', 2500);

select * from sales_data1 sd;


/*
 Q1 ⭐ Pivot Revenue by Month

Expected Output:

customer_name | Jan | Feb | Mar
--------------------------------
A             |1000 |1500 |2000
B             |1200 |1800 |2500
 */
select sd.customer_name, 
sum(
    case
        when month = 'Jan' then revenue
        else 0
    end
) as Jan,
sum(
    case
        when month = 'Feb' then revenue
        else 0
    end
) as Feb,
sum(
    case
        when month = 'Mar' then revenue
        else 0
    end
) as Mar
from sales_data1 sd 
group by sd.customer_name 
order by sd.customer_name ;

CREATE TABLE sales_orders_pivot (
    customer_name VARCHAR(50),
    month VARCHAR(10),
    order_id INT
);

INSERT INTO sales_orders_pivot
VALUES
('A', 'Jan', 101),
('A', 'Jan', 102),
('A', 'Feb', 103),
('A', 'Mar', 104),
('A', 'Mar', 105),
('B', 'Jan', 106),
('B', 'Feb', 107),
('B', 'Feb', 108),
('B', 'Mar', 109);

select * from sales_orders_pivot sop ;

--Q2 ⭐ Pivot Order Count by Month
select sop.customer_name,
Count(
case 
	when sop.month='Jan' then sop.order_id 
end
) as Jan,
Count(
case 
	when sop.month='Feb' then sop.order_id 
end
) as Feb,
Count(
case 
	when sop.month='Mar' then sop.order_id 
end
) as Mar
from sales_orders_pivot sop
group by sop.customer_name 
order by sop.customer_name ;

CREATE TABLE city_sales (
    city VARCHAR(50),
    month VARCHAR(10),
    revenue NUMERIC
);

INSERT INTO city_sales
VALUES
('Mumbai', 'Jan', 1000),
('Mumbai', 'Feb', 1500),
('Mumbai', 'Mar', 2000),
('Delhi',  'Jan', 1200),
('Delhi',  'Feb', 1800),
('Delhi',  'Mar', 2500),
('Pune',   'Jan', 900),
('Pune',   'Feb', 1100),
('Pune',   'Mar', 1400);

select * from city_sales cs ;

--Q3 ⭐⭐ Revenue Pivot by City and Month
select cs.city,
SUM(
case
	when cs.month='Jan' then cs.revenue 
	else 0
end
) as Jan,
SUM(
case
	when cs.month='Feb' then cs.revenue 
	else 0
end
) as Feb,
SUM(
case
	when cs.month='Mar' then cs.revenue 
	else 0
end
) as Mar
from city_sales cs
group by cs.city 
order by cs.city ;

/*Q4 ⭐⭐ Revenue Pivot + Total Revenue

Expected output:

City	Jan	Feb	Mar	Total_Revenue
Delhi	1200	1800	2500	5500
Mumbai	1000	1500	2000	4500
Pune	900	1100	1400	3400
*/

select cs.city,
SUM(
case
	when cs.month='Jan' then cs.revenue 
	else 0
end
) as Jan,
SUM(
case
	when cs.month='Feb' then cs.revenue 
	else 0
end
) as Feb,
SUM(
case
	when cs.month='Mar' then cs.revenue 
	else 0
end
) as Mar,
SUM(cs.revenue ) as TR
from city_sales cs 
group by cs.city
order by cs.city ;

CREATE TABLE city_sales_year (
    city VARCHAR(50),
    sales_year INT,
    revenue NUMERIC
);

INSERT INTO city_sales_year
VALUES
('Mumbai', 2023, 10000),
('Mumbai', 2024, 15000),
('Mumbai', 2025, 18000),
('Delhi', 2023, 12000),
('Delhi', 2024, 17000),
('Delhi', 2025, 22000),
('Pune', 2023, 8000),
('Pune', 2024, 11000),
('Pune', 2025, 14000);

select * from city_sales_year;

/*Q5 ⭐⭐⭐ Revenue Pivot by City and Year
 Expected Output
| City   |  2023 |  2024 |  2025 | Total_Revenue |
| ------ | ----: | ----: | ----: | ------------: |
| Delhi  | 12000 | 17000 | 22000 |         51000 |
| Mumbai | 10000 | 15000 | 18000 |         43000 |
| Pune   |  8000 | 11000 | 14000 |         33000 | */

select csy.city ,
SUM(
case
	when csy.sales_year =2023 then csy.revenue 
	else 0
end
) as "2023",
SUM(
case
	when csy.sales_year =2024 then csy.revenue 
	else 0
end
) as "2024",
SUM(
case
	when csy.sales_year =2025 then csy.revenue 
	else 0
end
) as "2025",
SUM(csy.revenue ) as TR
from city_sales_year csy 
group by csy.city 
order by csy.city ;
