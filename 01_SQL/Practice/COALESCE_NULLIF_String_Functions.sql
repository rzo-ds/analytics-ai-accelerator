 CREATE TABLE customer_contacts (
    customer_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20)
);

INSERT INTO customer_contacts
VALUES
('Amit','amit@gmail.com','9876543210'),
('Neha',NULL,'9876543211'),
('Rahul','rahul@gmail.com',NULL),
('Priya',NULL,NULL);

select *
from customer_contacts cc ;

--Q1 Show: Customer, Email - If Email is NULL show: Not Provided
select customer_name, coalesce(email  , 'Not Provided')
from customer_contacts;

--Q2 Show: Customer, Phone - If Phone is NULL show: Not Available
select customer_name , coalesce(phone , 'Not Provided')
from customer_contacts;

/*Q3 Show: Customer, Preferred Contact - Logic:
Use Email if available
Else use Phone
Else show 'No Contact Available'*/
select customer_name , coalesce(email , phone , 'Not provided') as Preferred_Contact
from customer_contacts;

CREATE TABLE product_sales (
    product_name VARCHAR(50),
    sales_amount NUMERIC,
    quantity INT
);


INSERT INTO product_sales
VALUES
('Laptop',50000,5),
('Mobile',30000,3),
('Tablet',10000,0);


select *
from product_sales ps ;

--Q4 Show: Product, Sales, Quantity, Revenue Per Unit
select *, sales_amount / Nullif(quantity , 0) as RPU
from product_sales;

--Q5 ⭐ Show:Product, Revenue Per Unit - If result is NULL show: Not Applicable
select product_name,  coalesce(sales_amount / Nullif(quantity , 0), '0')
from product_sales;

with RPU as
(
select product_name,  sales_amount / Nullif(quantity , 0) as RPU1
from product_sales)
select product_name, COALESCE(rpu1::text, 'Not Applicable') 
from RPU;

