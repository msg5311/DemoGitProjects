create table "MEP".test (id numeric, name character varying);

create procedure "MEP".new_sp (numeric, character varying)
language 'plpgsql'
as $$

begin

insert into "MEP".test (id,name) values ($1,$2);
commit;


end;
$$;

call "MEP".new_sp(4,'Taylor');