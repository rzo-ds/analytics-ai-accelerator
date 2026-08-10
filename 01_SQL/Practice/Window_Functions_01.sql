--Write a query showing: Employee Name, Salary, Company Average Salary using over ()
select employee_name, salary , Avg(salary) over() as Avg_salary
from employees;

--Write a query showing: Employee Name, Department, Salary, Department Average Salary using PARTITION BY.
select employee_name, department_id, salary , AVG(salary) over(partition by department_id) as department_avg_slary
from employees;

--Assign ROW_NUMBER by salary descending.
select *, row_number() over(order by salary desc)
from employees;

--Assign RANK by salary descending.
select *, rank() over(order by salary desc)
from employees;

--Assign DENSE_RANK by salary descending.
select *, dense_rank() over (order by salary desc)
from employees;

--Find Top 3 Salaries.
with rnk as
(select *, rank() over(order by salary desc) as rank_s
from employee_sales
)
select * from rnk where rank_s <= 3;

--Find highest-paid employee in each department.
with rnk as
(
select *, dense_rank() over(partition by department_id order by salary desc) as rw
from employee_sales
)
select * from rnk where rw=1;

--Find second-highest-paid employee in each department.
with rnk as
(
select *, dense_rank() over(partition by department_id order by salary desc) as rw
from employee_sales
)
select * from rnk where rw=2;