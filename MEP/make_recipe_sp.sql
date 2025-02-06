

create or replace procedure "MEP".make_recipe_sp(p_recipe character varying(100))
language plpgsql
as $$
begin
	if not exists (select 1 from "MEP".a2_recipes where recipe = p_recipe) then
		raise info 'Recipe "%" does not exist in the table. Please check spelling and try again.', p_recipe;
	
		else if exists (
			select a2.item, a2.base_amount as recipe_amt, a2.base_unit as recipe_unit, a0.current_base_amt, a0.base_unit,
			(coalesce(a0.current_base_amt,0) - a2.base_amount) as rem_amt
			from "MEP".a2_recipes as a2
			left join "MEP".a0_pantry as a0
			on a2.item = a0.item
			where a2.recipe = p_recipe and (coalesce(a0.current_base_amt,0) - a2.base_amount) <= 0
			) then raise info 'Insufficient ingredients to make "%". Please select a new recipe.', p_recipe;
		else 
		with update_cte as (
		select a2.item, a2.base_amount as recipe_amt, a2.base_unit as recipe_unit, a0.current_base_amt, a0.base_unit,
			(coalesce(a0.current_base_amt,0) - a2.base_amount) as rem_amt
			from "MEP".a2_recipes as a2
			left join "MEP".a0_pantry as a0
			on a2.item = a0.item
			where a2.recipe = p_recipe)
			update "MEP".a0_pantry as a0
			set current_base_amt = update_cte.rem_amt
			from update_cte
			where a0.item = update_cte.item;
		
		raise info 'Success! Lets start cooking!';
		end if;
	end if;
end;
$$;

