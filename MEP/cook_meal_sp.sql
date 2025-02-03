

-- Test if you have the necessary ingredients to make a meal:

call "MEP".z_test('Arugala farro salad');

create or replace procedure "MEP".z_test(p_recipe varchar(100))
language plpgsql
as $$
begin

with cte as (
select a0.*, a2.base_amount as amt_out, a2.base_unit as unit_out, greatest(a0.current_base_amt - a2.base_amount,0) as new_base_amt 
from "MEP".a0_pantry as a0
left join "MEP".a2_recipes as a2
on a0.item = a2.item
where a2.recipe = p_recipe)

update "MEP".a0_pantry as a0
set current_base_amt = cte.new_base_amt
from cte
where a0.item = cte.item;

commit;
end;
$$;