-- Raise exception criteria to add to recieps to the recipe book:

create or replace procedure "MEP".test_sp2(p_recipe character varying(100))
language plpgsql
as $$
begin
	if not exists (select 1 from "MEP".a2_recipes where recipe = p_recipe) then
		raise info 'Item "%" does not exist in the table.', p_recipe;
	else raise info 'Success! Items added to the grocery list.';
	end if;
end;
$$;

call "MEP".test_sp2('Burrito chicken');



