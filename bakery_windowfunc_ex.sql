-- lag and lead statements:
select *,
lag(salary) over(partition by department),
lead(salary) over(partition by department)
from h_employees;

select *, lag_col - salary as pay_disc
from
(select *, -- subquery
lag(salary) over(partition by department order by employee_id) as lag_col
from h_employees) as lag_table;

select *, 
case
	when salary > lag_col then 'More'
	when salary < lag_col then 'Less'
	else 'Even'
	end as category_salary
from
(select *,
	lead(salary) over(partition by department order by employee_id) as lag_col
	from h_employees) as lag_table
;
