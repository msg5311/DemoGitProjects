with group_cte as (
select generic_item_name, unit, count (unit) as county
from "MEP".ingredient_cost_by_store
group by generic_item_name, unit),


rank_cte as (
select *,  
rank () over( partition by generic_item_name order by county desc) as ranky
from group_cte),

limit_cte as (
select * from rank_cte where county = 1
)

select ingredient_cost_by_store.*,limit_cte.unit as base_unit_identifier
from "MEP".ingredient_cost_by_store
join limit_cte
on ingredient_cost_by_store.generic_item_name = limit_cte.generic_item_name
;
