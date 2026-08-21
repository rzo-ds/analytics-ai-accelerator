CREATE TABLE employee_text (
    employee_name VARCHAR(50),
    email VARCHAR(100)
);

INSERT INTO employee_text
VALUES
('amit sharma','AMIT@GMAIL.COM'),
('NeHa Gupta','NEHA@YAHOO.COM'),
('rahul Verma','RAHUL@OUTLOOK.COM');

select *
from employee_text;

--Q1 Show: Original Name, UPPER Name
select et.employee_name , UPPER(et.employee_name ) as UPPER
from employee_text et ;

--Q2 Show: Original Email, lowercase Email
select et.email , lower(et.email ) as lower
from employee_text et ;

--Q3 Show: Employee Name, Proper Case Name
select et.employee_name , initcap(et.employee_name )
from employee_text et ;

--Q4 Show: Employee Name, Character Count
select et.employee_name , length(et.employee_name )
from employee_text et ;

--Q5 ⭐ Show: Employee Name, First 4 Characters
select et.employee_name , left(et.employee_name,4)
from employee_text et ;

--Q6 ⭐ Show: Employee Name, Last 5 Characters
select et.employee_name , right(et.employee_name , 5)
from employee_text et ;

 --Q7 ⭐⭐ Show: Employee Name, Replace spaces with '-'
select et.employee_name , replace(et.employee_name ,' ','-')
from employee_text et ;

CREATE TABLE messy_names (
    employee_name VARCHAR(50)
);

INSERT INTO messy_names
VALUES
('   Amit Sharma   '),
('   Neha Gupta'),
('Rahul Verma   ');

select *
from messy_names mn ;

--Q8 — TRIM() Show: Original Name, Clean Name
select mn.employee_name , TRIM(mn.employee_name )
from messy_names mn;

--Q9 — SUBSTRING() Show: Employee Name, Characters 1 to 5
select et.employee_name, substring(et.employee_name from 1 for 5 )
from employee_text et ;

--Q10 — CONCAT() Show: Employee Name, Email, Employee Contact - Expected: amit sharma | AMIT@GMAIL.COM
select et.employee_name , et.email  , concat(et.employee_name ,' | ', et.email ) as Employee_Contact
from employee_text et ;

/*
Q11 ⭐ Data Cleaning Scenario
Using employee_text Show: Employee Name, Username
Logic:
Convert name to lowercase
Replace spaces with underscore
*/
select et.employee_name , lower(replace(et.employee_name, ' ', '_')) as Username
from employee_text et ;