

-- Stored procedure to import new recipes into recipe file:
create or replace procedure "MEP".recipe_import_sp ()
language 'plpgsql'
as $$

begin

insert into "MEP".a2_recipes

select * from "MEP".a3_recipes_import

commit;

end;
$$;

-- Call stored procedure:
call "MEP".recipe_import_sp();