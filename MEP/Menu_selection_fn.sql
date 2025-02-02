
-- Sample select statement to create a grocery list:
select item, ingredient_type, sum(amount) as Amount, unit
from (
	select *
	from "MEP".a2_recipes
	where recipe like '%Butternut' or recipe like '%Butter chicken')
group by item, ingredient_type, unit
order by item desc;


-- Create function to promt a user with a menu for the week:
create or replace function "MEP".recipe_select_sp(p_recipe character varying (100)[])
returns text
language 'plpgsql'

cost 100
volatile
as $BODY$
declare
v_array_length numeric(10,0) := 0;
v_msg character varying(100) := null;

-- Creates array:
begin
	delete from "MEP".a4_menu;
	v_array_length := array_length(p_recipe,1);

	if(v_array_length > 0) then
		for i in 1..v_array_length loop
			insert into "MEP".a4_menu (recipe_name) values(p_recipe[i]);
		end loop;

		v_msg := 'Array processed successfully with length'||v_array_length;
	else

		v_msg := 'Array not processed successfully.';
	end if;

return v_msg;

end;
$BODY$;
