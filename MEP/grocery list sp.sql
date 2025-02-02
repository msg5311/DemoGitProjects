

begin

delete from "MEP".c1_grocery_list;

insert into "MEP".c1_grocery_list

-- With the results of the menu, create a list of ingredients you need for the recipes:
-- Updated grocery list sp:

with ing_list_cte as (
select item as r_item, ingredient_type, sum(base_amount) as r_amount, base_unit as r_unit
from (
	select a2.* 
	from "MEP".a2_recipes as a2
	join "MEP".a4_menu as a4
	on a2.recipe = a4.recipe_name)
group by item, ingredient_type, base_unit),

-- See what items are in the pantry:
join_cte as (
select ing_list_cte.*, coalesce(a0.current_base_amt,0) as p_amount, a0.base_unit as p_unit
from ing_list_cte
left join "MEP".a0_pantry as a0
on ing_list_cte.r_item = a0.item),

-- Create the amount remaining column:
calc_cte as (
select *, p_amount - r_amount as p_amount_rem
from join_cte),

-- Flag what the status of each item is that is required:
amt_rem_cte as (
select *,
	case 
		when p_amount_rem > 0 then 'N'
		when p_amount_rem <=0 then 'Y'
		when p_amount is null then 'Y'
	end as add_to_list
	
from calc_cte),



--create table c_grocery_list as 
grocery_list_cte as (
select r_item as item, r_amount as amount, r_unit as unit, p_amount_rem 
from amt_rem_cte 
where add_to_list = 'Y')

select glc.item, glc.amount, glc.unit, a1.price, a1.amount as sold_amt, a1.unit as sold_unit, a1.store, case when glc.p_amount_rem = 0 then 1 else ceiling(abs(glc.p_amount_rem) / a1.amount) end as qty, case when glc.p_amount_rem = 0 then 1 * a1.amount else ceiling(abs(glc.p_amount_rem) / a1.amount)*a1.amount end as purchase_amt
from grocery_list_cte as glc
left join "MEP".a1_all_ingredients_purchased as a1
on glc.item = a1.generic_item_name
where a1.unit_price = (select min(a2.unit_price) from "MEP".a1_all_ingredients_purchased as a2 where a1.generic_item_name = a2.generic_item_name);



commit;

end;
