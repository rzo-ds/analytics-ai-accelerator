select * from employees e ;
select * from departments d ;
select * from bonuses b ;


-- show Employee Name Department Name Salary sorted by salary descending.
select employee_name, departname_name ,salary 
from employees e
join departments d 
on e.department_id  = d.department_id
order by e.salary desc;

--Show all employees earning more than the company average salary.
select e.employee_name 
from employees e 
where e.salary > (select AVG(e2.salary) from employees e2 );

--Show the employee with the highest salary.

--Subquery
select e.employee_name 
from employees e 
where e.salary = (select Max(e2.salary) from employees e2 );

--ORDER BY + LIMIT
select e.employee_name 
from employees e 
order by e.salary desc
limit 1;

--Show Department Name, Employee Count
select d.departname_name , count(e.employee_id ) as count1
from employees e 
join departments d 
on d.department_id =e.department_id 
group by d.departname_name 
order by count1 desc;

--show Department Name, Average Salary sorted highest to lowest.
select d.departname_name, AVG(e.salary) as Average_salary
from departments d 
join employees e 
on d.department_id  = e.department_id
group by d.departname_name
order by Average_salary desc ;

--Show departments whose average salary is above company average salary.
select d.departname_name, AVG(e.salary) as Department_Average_salary
from departments d 
join employees e 
on d.department_id = e.department_id
group by d.departname_name
having AVG(e.salary) > (select Avg(salary) from employees);

--Show employees earning above their department average.
select e.employee_name 
from employees e
where e.salary > (select Avg(salary) from employees group by department_id having department_id=e.department_id);

--Show employees earning the highest salary within their department.
select e.employee_name 
from employees e
where e.salary = (select Max(salary) from employees group by department_id having department_id=e.department_id);

--Show employees who received a bonus.
select employee_name 
from employees e
where exists (select employee_id from bonuses b where e.employee_id = b.employee_id );

--Show employees who did NOT receive a bonus.
select employee_name 
from employees e
where not exists (select employee_id from bonuses b where e.employee_id = b.employee_id );

--Create a CTE: DepartmentStats containing: Department Name, Employee Count, Average Salary, Maximum Salary
with DepartmentStats as
(select d.departname_name, count(e.employee_id), AVG(e.salary ), MAX(e.salary)
from employees e
join departments d 
on e.department_id = d.department_id
group by d.departname_name)
select * from DepartmentStats;

--Using the same CTE, show only the department with the highest average salary
with DepartmentStats as
(select d.departname_name, count(e.employee_id), AVG(e.salary ) as avg1, MAX(e.salary) as max_salary
from employees e
join departments d 
on e.department_id = d.department_id
group by d.departname_name)
select departname_name from DepartmentStats order by avg1 desc limit 1;

--Which department contributes the most total salary expense?
with DepartmentStats as
(select d.departname_name, count(e.employee_id), AVG(e.salary ), MAX(e.salary) as max_salary, SUM(e.salary) as sum_salary
from employees e
join departments d 
on e.department_id = d.department_id
group by d.departname_name)
select departname_name, sum_salary from DepartmentStats order by sum_salary desc limit 1;

--Find employees whose salary is greater than the average salary of ALL employees who received a bonus.
SELECT employee_name
FROM employees
WHERE salary >
(
SELECT AVG(e.salary)
FROM employees e
JOIN bonuses b
ON e.employee_id=b.employee_id
);



