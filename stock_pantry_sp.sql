-- Stock pantry query:
-- Accounts for items already in pantry, and adds new items.

insert into "MEP".a0_pantry
select c1.item
from "MEP".c1_grocery_list as c1
left outer join "MEP".a0_pantry as a0
on c1.item = a0.item
where a0.current_base_amt is null;

with grocery_bag_cte as (
select c1.item, c1.sold_amt, c1.sold_unit, c1.store, item_list.measurement_type
from "MEP".c1_grocery_list as c1
left join (
	select generic_item_name, measurement_type
	from "MEP".a1_all_ingredients_purchased as a1
	group by generic_item_name, measurement_type
) as item_list
on c1.item = item_list.generic_item_name),

solid_cte as (

-- Solid weight conv join to get base units for shopping list:
select gbc.*,b1.base as base_unit, b1.conv as multiplier, (gbc.sold_amt * b1.conv) as base_amount
from grocery_bag_cte as gbc
inner join "MEP".b1_solid_weight_conv as b1
on gbc.sold_unit = b1.recipe
where b1.base = 'oz'),

-- same for liquid items:
liquid_cte as (
select gbc.*,b2.base as base_unit, b2.conv as multiplier, (gbc.sold_amt * b2.conv) as base_amount
from grocery_bag_cte as gbc
inner join "MEP".b2_liquid_vol_conv as b2
on gbc.sold_unit = b2.recipe
where b2.base = 'fl oz'),

-- Same for unit items:
unit_cte as (
select gbc.*,lower(gbc.sold_unit) as base_unit, 1 as multiplier, (gbc.sold_amt * 1) as base_amount
from grocery_bag_cte as gbc
where lower(gbc.sold_unit) = 'unit' or lower(gbc.sold_unit) = 'sub_unit'),

union_cte as (
select item,measurement_type,base_unit,base_amount from solid_cte
union
select item,measurement_type,base_unit,base_amount from liquid_cte
union
select item,measurement_type,base_unit,base_amount from unit_cte
union
select item,measurement_type,base_unit,current_base_amt as base_amount from "MEP".a0_pantry where measurement_type is not null
),

update_cte as (
select item, measurement_type, base_unit, sum(base_amount) as current_base_amt
from union_cte
group by item, measurement_type, base_unit)

update "MEP".a0_pantry as a0
set current_base_amt = uc.current_base_amt, measurement_type = uc.measurement_type, base_unit = uc.base_unit
from update_cte as uc
where a0.item = uc.item;