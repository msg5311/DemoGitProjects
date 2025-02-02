
-- Outstanding items:
-- Need to update the amount in the pantry based on the selected recipes.
-- Can either replace the entries entirely, or update the amounts. 
-- Lean towards the latter, bc we will eventually want to include the purchase date of the ingredient and keep that. 

-- Input the recipes you want to make this week:
SELECT "MEP".recipe_select_sp('{Butter chicken}'::character varying[]);

-- With the results of the menu, create a list of ingredients you need for the recipes:
with ing_list_cte as (
select item as r_item, ingredient_type, sum(base_amount) as r_amount, base_unit as r_unit
from (
	select a2_recipes.* 
	from "MEP".a2_recipes
	join "MEP".a4_menu
	on a2_recipes.recipe = a4_menu.recipe_name)
group by item, ingredient_type, base_unit),

-- See what items are in the pantry:
join_cte as (
select ing_list_cte.*, a0.base_amount as p_amount, a0.base_unit as p_unit
from ing_list_cte
left join "MEP".a0_pantry as a0
on ing_list_cte.r_item = a0.generic_item_name),

-- Create the amount remaining column:
calc_cte as (
select *, p_amount - r_amount as p_amount_rem
from join_cte),


-- Flag what the status of each item is that is required:
amt_rem_cte as (
select *,
	case 
		when p_amount_rem > 0 then 'N'
		when p_amount <=0 then 'Y'
		when p_amount is null then 'Y'
	end as add_to_list
	
from calc_cte)

select * from amt_rem_cte;

-- Join with all ingredients purchased to pull in price and amount you can purchase in:
select arc.r_item, arc.r_amount, a1.price, a1.amount, a1.unit
from amt_rem_cte as arc
inner join "MEP".a1_all_ingredients_purchased as a1
on arc.r_item = a1.generic_item_name;

---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

basket_cte as (
select a1.generic_item_name, a1.price, a1.amount, a1.unit, ing_list_cte.Amount as recipe_amt, ing_list_cte.unit as recipe_unit
from "MEP".a1_all_ingredients_purchased as a1
inner join ing_list_cte
on a1.generic_item_name = ing_list_cte.item)

select * from basket_cte;








join_cte as (
select ing_list_cte.*, a0.amount as recipe_amount, a0.unit as recipe_unit
from ing_list_cte
inner join "MEP".a0_pantry as a0
on ing_list_cte.item = a0.generic_item_name),

amt_rem_cte as (
select *, join_cte.amount - join_cte.recipe_amount as amt_remaining
from join_cte)




;

-- select * into "MEP".a0_pantry from basket_cte;

delete from "MEP".a0_pantry;

