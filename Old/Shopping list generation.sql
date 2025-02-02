SELECT "MEP".recipe_select_sp('{Pot roast, Soy glazed salmon}'::character varying[]
);



select item, ingredient_type, sum(amount) as Amount, unit
from (
	select a2_recipes.* 
	from "MEP".a2_recipes
	join "MEP".a4_menu
	on a2_recipes.recipe = a4_menu.recipe_name)
group by item, ingredient_type, unit;
