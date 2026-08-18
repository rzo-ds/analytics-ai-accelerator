CREATE TABLE customer_purchases_v2
(
    customer_name VARCHAR(50),
    city VARCHAR(30),
    amount INT
);

INSERT INTO customer_purchases_v2
VALUES
('Amit','Mumbai',12000),
('Neha','Delhi',7000),
('Rahul','Mumbai',3000),
('Priya','Pune',15000),
('Karan','Delhi',4500),
('Sneha','Mumbai',9000);

select *
from customer_purchases_v2;

--Practice Questions

--Q1 Show: Customer, Amount, Segment - High Value >=10000 | Medium Value >=5000 | Low Value <5000 - Use CASE.
select customer_name,
amount,
case
	when amount >= 10000 then 'High Value'
	when amount >= 5000 then 'Medium Value'
	else 'Low Value'
end as segment
from customer_purchases_v2;

--Q2 Show: Customer, City, Amount, Revenue Category Premium | Regular | Basic - Create your own logic using CASE.
select customer_name,
city,
amount,
case
	when amount >= 15000 then 'Premium'
	when amount >= 7000 then 'Regular'
	else 'Basic'
end as Category
from customer_purchases_v2;

--Q3 Find: Total High Value Revenue - Using CASE inside SUM.
select 
Sum(
case
	when amount >= 10000 then amount
	else 0
end) as hvr
from customer_purchases_v2;

/*Q4 Find: Customer Count By Segment Expected output:
Segment       Customers
High Value    2
Medium Value  3
Low Value     1
*/

with customer_segment as 
(
select customer_name,
amount,
case
	when amount >= 10000 then 'High Value'
	when amount >= 5000 then 'Medium Value'
	else 'Low Value'
end as segment
from customer_purchases_v2
)
select segment, count(*) 
from customer_segment 
group by segment;

--Q5 ⭐ Find: City, Total Revenue, High Value Revenue
select city, sum(amount) as revenue,
Sum(
case
	when amount >= 10000 then amount
	else 0
end) as hvr
from customer_purchases_v2
group by city;

--Q6 ⭐⭐ Find: Customer, Amount, Revenue Rank Within Segment
with customer_segment as 
(
select customer_name,
amount,
case
	when amount >= 10000 then 'High Value'
	when amount >= 5000 then 'Medium Value'
	else 'Low Value'
end as segment
from customer_purchases_v2
)
select * , rank() over(partition by segment order by amount desc)
from customer_segment;

