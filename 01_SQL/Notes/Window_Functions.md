# SQL Window Functions

## What is a Window Function?

A window function performs calculations across a set of rows while preserving individual rows.

### GROUP BY Example

```sql
SELECT department_id,
       AVG(salary)
FROM employees
GROUP BY department_id;
```

Output:

| Department | Avg Salary |
|------------|------------|
| 1 | 42666 |
| 2 | 45000 |

Rows collapse into a single row per group.

---

### Window Function Example

```sql
SELECT employee_name,
       salary,
       AVG(salary) OVER() AS company_avg
FROM employees;
```

Output:

| Employee | Salary | Company Avg |
|-----------|---------|-------------|
| Ramesh | 35000 | 40400 |
| Suresh | 45000 | 40400 |

Rows remain visible.

---

# OVER()

## Purpose

Defines the window of rows over which a calculation is performed.

## Syntax

```sql
AGG_FUNCTION() OVER()
```

## Example

```sql
SELECT employee_name,
       salary,
       AVG(salary) OVER() AS company_avg
FROM employees;
```

## Business Use

- Show every employee alongside company average salary.
- Compare employee salary against company average.

---

# PARTITION BY

## Purpose

Divides rows into groups while keeping all rows visible.

Think:

> GROUP BY without collapsing rows

## Syntax

```sql
OVER(PARTITION BY column_name)
```

## Example

```sql
SELECT employee_name,
       department_id,
       salary,
       AVG(salary)
       OVER(PARTITION BY department_id) AS dept_avg
FROM employees;
```

## Business Use

- Compare employee salary against department average.
- Compare product sales against category average.

---

# ROW_NUMBER()

## Purpose

Assigns a unique sequential number to every row.

## Syntax

```sql
ROW_NUMBER()
OVER(ORDER BY salary DESC)
```

## Example

| Salary | Row Number |
|---------|-----------|
| 100 | 1 |
| 100 | 2 |
| 90 | 3 |
| 80 | 4 |

## Business Use

- Latest order per customer
- Highest-paid employee per department
- Most recent transaction

## Important

- No ties allowed.
- Every row gets a unique number.

---

# RANK()

## Purpose

Assigns rank while allowing ties.

## Syntax

```sql
RANK()
OVER(ORDER BY salary DESC)
```

## Example

| Salary | Rank |
|---------|------|
| 100 | 1 |
| 100 | 1 |
| 90 | 3 |
| 80 | 4 |

Notice:

Rank 2 is skipped.

## Business Use

- Competition ranking
- Sales leaderboard
- Employee performance ranking

---

# DENSE_RANK()

## Purpose

Assigns rank while allowing ties.

No gaps in rank numbers.

## Syntax

```sql
DENSE_RANK()
OVER(ORDER BY salary DESC)
```

## Example

| Salary | Dense Rank |
|---------|-----------|
| 100 | 1 |
| 100 | 1 |
| 90 | 2 |
| 80 | 3 |

## Business Use

- Top 5 customers
- Top 10 products
- Top 3 salaries

---

# NTILE()

## Purpose

Splits rows into equal buckets.

## Syntax

```sql
NTILE(4)
OVER(ORDER BY salary DESC)
```

## Example

| Salary | Quartile |
|---------|----------|
| 100 | 1 |
| 95 | 1 |
| 90 | 2 |
| 85 | 2 |
| 80 | 3 |
| 75 | 3 |
| 70 | 4 |
| 65 | 4 |

## Business Use

- Customer segmentation
- Top 25% customers
- Revenue quartiles

---

# LAG()

## Purpose

Accesses the previous row value.

## Syntax

```sql
LAG(column_name)
OVER(ORDER BY column_name)
```

## Example

```sql
SELECT month,
       sales,
       LAG(sales)
       OVER(ORDER BY month) AS previous_month_sales
FROM sales_data;
```

Output:

| Month | Sales | Previous Month |
|--------|--------|---------------|
| Jan | 100 | NULL |
| Feb | 120 | 100 |
| Mar | 150 | 120 |

## Business Use

- Month-over-Month Growth
- Previous Transaction Analysis
- Trend Analysis

---

# LEAD()

## Purpose

Accesses the next row value.

## Syntax

```sql
LEAD(column_name)
OVER(ORDER BY column_name)
```

## Example

```sql
SELECT month,
       sales,
       LEAD(sales)
       OVER(ORDER BY month) AS next_month_sales
FROM sales_data;
```

Output:

| Month | Sales | Next Month |
|--------|--------|-----------|
| Jan | 100 | 120 |
| Feb | 120 | 150 |
| Mar | 150 | NULL |

## Business Use

- Forecasting
- Upcoming Milestones
- Next Purchase Analysis

---

# FIRST_VALUE()

## Purpose

Returns the first value in a window.

## Example

```sql
SELECT employee_name,
       salary,
       FIRST_VALUE(salary)
       OVER(ORDER BY salary DESC) AS highest_salary
FROM employees;
```

## Business Use

- Compare every employee against highest salary.
- Compare product sales against best-selling product.

---

# LAST_VALUE()

## Purpose

Returns the last value in a window.

## Example

```sql
SELECT employee_name,
       salary,
       LAST_VALUE(salary)
       OVER(
           ORDER BY salary
           ROWS BETWEEN UNBOUNDED PRECEDING
           AND UNBOUNDED FOLLOWING
       ) AS lowest_salary
FROM employees;
```

## Business Use

- Compare every employee against lowest salary.
- Compare products against worst performer.

---

# Running Total

## Purpose

Calculates cumulative sum.

## Example

```sql
SELECT month,
       sales,
       SUM(sales)
       OVER(ORDER BY month) AS running_total
FROM sales_data;
```

Output:

| Month | Sales | Running Total |
|--------|--------|--------------|
| Jan | 100 | 100 |
| Feb | 150 | 250 |
| Mar | 200 | 450 |

## Business Use

- Revenue Tracking
- Budget Monitoring
- Cumulative Sales Analysis

---

# Moving Average

## Purpose

Calculates average over a moving window.

## Example

```sql
SELECT month,
       sales,
       AVG(sales)
       OVER(
           ORDER BY month
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS moving_avg
FROM sales_data;
```

## Business Use

- Trend Analysis
- Demand Forecasting
- Seasonal Analysis

---

# Most Important Interview Patterns

## Top N Employees

```sql
DENSE_RANK()
```

## Highest Salary Per Department

```sql
ROW_NUMBER()
OVER(PARTITION BY department_id ORDER BY salary DESC)
```

## Month-over-Month Growth

```sql
LAG()
```

## Customer Segmentation

```sql
NTILE()
```

## Running Revenue

```sql
SUM() OVER()
```

---

# Interview Memory Trick

| Function | Purpose |
|-----------|----------|
| OVER() | Window Definition |
| PARTITION BY | Group Without Collapsing |
| ROW_NUMBER() | Unique Ranking |
| RANK() | Ties + Skip |
| DENSE_RANK() | Ties + No Skip |
| LAG() | Previous Row |
| LEAD() | Next Row |
| NTILE() | Buckets |
| SUM() OVER() | Running Total |
| AVG() OVER() | Moving Average |

---

# Quick Revision

ROW_NUMBER() → Unique row numbering

RANK() → Ties allowed, ranks skipped

DENSE_RANK() → Ties allowed, no ranks skipped

LAG() → Previous row value

LEAD() → Next row value

PARTITION BY → Group data without collapsing rows

NTILE() → Divide data into buckets

SUM() OVER() → Running total

AVG() OVER() → Moving average