CREATE TABLE employee_sales (
    employee_id INT,
    employee_name VARCHAR(50),
    department_id INT,
    salary INT
);

INSERT INTO employee_sales
VALUES
(1001,'Ramesh',1,35000),
(1002,'Suresh',2,45000),
(1003,'Roshan',1,55000),
(1004,'Jatin',3,29000),
(1005,'Dan',1,38000),
(1006,'Karan',2,62000),
(1007,'Aman',2,62000),
(1008,'Priya',3,41000);

--Write a query showing: Employee Name, Salary, Company Average Salary
select e.employee_name, e.salary, Avg(e.salary ) over()
from employees e;

--Write a query showing: Employee Name, Department, Salary, Department Average Salary
select employee_name, department_id, salary, Avg(salary) over(partition by department_id)
from employees;

--Rank employees by salary descending using:ROW_NUMBER()
select employee_name, salary, row_number() over(order by salary desc) as row_num
from employees;

--