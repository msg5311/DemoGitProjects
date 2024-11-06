select *
from e_customers;

-- Partition by tells sql what column to use as a subset for the function.
select c.customer_id, 
first_name, 
order_total, 
Max(order_total) 
over (partition by c.customer_id) as max_order_total
from e_customers c
join f_customer_orders co
	on c.customer_id = co.customer_id
	group by c.customer_id, first_name, order_total
order by customer_id ASC
;

-- Row number test
select c.customer_id, 
first_name, 
order_total,
row_number() over(partition by c.customer_id order by order_total ASC) as row_num -- generate a row number, over the data set, subset by customer id, and ordered by order_total in that subset.
from e_customers c
join f_customer_orders co
	on c.customer_id = co.customer_id;

-- use rownumber to identify the top 2 orders from each customer:
select *
from (
	select c.customer_id, 
	first_name, 
	order_total,
	row_number() over(partition by c.customer_id order by order_total ASC) as row_num -- generate a row number, over the data set, subset by customer id, and ordered by order_total in that subset.
	from e_customers c
	join f_customer_orders co
		on c.customer_id = co.customer_id
) as row_table -- Creating subquery
where row_num < 3
;