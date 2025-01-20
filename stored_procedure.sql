create table "MEP".names_import (id numeric, name character varying);

create or replace procedure "MEP".name_import_sp ()
language 'plpgsql'
as $$

begin

-- Insert the values for columns id,name,birth_year into the test table from the names_import table
insert into "MEP".test 
select id,name,birth_year
from "MEP".names_import;

-- next update the column age in test table with the caluclation todays year minus birth year:
update "MEP".test 
set age = extract('year' from current_date)-birth_year
;
commit;


end;
$$;

call "MEP".name_import_sp();