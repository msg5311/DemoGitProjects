
call "MEP".stock_pantry_sp();

-- SP to stock pantry:

create or replace procedure "MEP".stock_pantry_sp()
language plpgsql
as $$

begin

insert into "MEP".a0_pantry

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

-- Solid weight conv join:
select gbc.*,b1.base as base_unit, b1.conv as multiplier, (gbc.sold_amt * b1.conv) as base_amount
from grocery_bag_cte as gbc
inner join "MEP".b1_solid_weight_conv as b1
on gbc.sold_unit = b1.recipe
where b1.base = 'oz'),

liquid_cte as (
select gbc.*,b2.base as base_unit, b2.conv as multiplier, (gbc.sold_amt * b2.conv) as base_amount
from grocery_bag_cte as gbc
inner join "MEP".b2_liquid_vol_conv as b2
on gbc.sold_unit = b2.recipe
where b2.base = 'fl oz'),

unit_cte as (
select gbc.*,lower(gbc.sold_unit) as base_unit, 1 as multiplier, (gbc.sold_amt * 1) as base_amount
from grocery_bag_cte as gbc
where lower(gbc.sold_unit) = 'unit' or lower(gbc.sold_unit) = 'sub_unit')

select item,measurement_type,base_unit,base_amount from solid_cte
union
select item,measurement_type,base_unit,base_amount from liquid_cte
union
select item,measurement_type,base_unit,base_amount from unit_cte

commit;

end;
$$;