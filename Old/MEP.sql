
-- ingredients_cost_by_store table needs some extra columns that are based on ranks and calculations:

-- groups table by ingredients and counts how many times a unit is used for an ingredient:
with group_cte as (
select generic_item_name, unit, count (unit) as county
from "MEP".ingredient_cost_by_store
group by generic_item_name, unit),

-- Ranks the grouping of ingredients to determine the most common unit:
rank_cte as (
select *,  
rank () over( partition by generic_item_name order by county desc) as ranky
from group_cte),

-- Limits the list to only the most common unit for each ingredient:
limit_cte as (
select * from rank_cte where ranky = 1
),

-- Joins this ingredient into the main table: 
base_cte as (
select ingredient_cost_by_store.*,limit_cte.unit as base_unit_identifier
from "MEP".ingredient_cost_by_store
join limit_cte
on ingredient_cost_by_store.generic_item_name = limit_cte.generic_item_name)

--select * 
--from base_cte
--inner join "MEP".liquid_vol_conv
--on base_cte.unit || base_cte.base_unit_identifier = liquid_vol_conv.recipe||liquid_vol_conv.base
--where base_Cte.measurement_type = 'Liquid-volume';

select base_cte.*, base_cte.amount * solid_weight_conv.conv as conversion
from base_cte
inner join "MEP".solid_weight_conv
on base_cte.unit || base_cte.base_unit_identifier = solid_weight_conv.recipe||solid_weight_conv.base
where base_cte.measurement_type = 'Solid-weight' and base_cte.generic_item_name = 'Salted butter';
