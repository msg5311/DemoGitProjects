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