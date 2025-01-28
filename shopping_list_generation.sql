
-- Input the recipes you want to make this week:
SELECT "MEP".recipe_select_sp('{Burrito chicken}'::character varying[]
);

-- With the results of the menu, create a list of ingredients you need for the recipes:
with ing_list_cte as (
select item as r_item, ingredient_type, sum(amount) as r_amount, unit as r_unit
from (
	select a2_recipes.* 
	from "MEP".a2_recipes
	join "MEP".a4_menu
	on a2_recipes.recipe = a4_menu.recipe_name)
group by item, ingredient_type, unit),

-- See what items are in the pantry:
join_cte as (
select ing_list_cte.*,a0.amount as p_amount, a0.unit as p_unit
from ing_list_cte
inner join a0_pantry as a0
on ing_list_cte.r_item = a0.generic_item_name),

-- Create the amount remaining column:
amt_rem_cte as (
select *, p_amount - r_amount as p_amount_rem
from join_cte)

-- Only return negative items:

select *
from amt_rem_cte
where p_amount_rem < 0;


basket_cte as (
select a1.generic_item_name, a1.price, a1.amount, a1.unit, ing_list_cte.Amount as recipe_amt, ing_list_cte.unit as recipe_unit
from "MEP".a1_all_ingredients_purchased as a1
inner join ing_list_cte
on a1.generic_item_name = ing_list_cte.item),

join_cte as (
select ing_list_cte.*, a0.amount as recipe_amount, a0.unit as recipe_unit
from ing_list_cte
inner join "MEP".a0_pantry as a0
on ing_list_cte.item = a0.generic_item_name)

select *, join_cte.amount - join_cte.recipe_amount as amt_remaining
from join_cte;

-- select * into "MEP".a0_pantry from basket_cte;

