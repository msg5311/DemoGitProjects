SELECT * FROM "MEP".z_test_1;
SELECT * FROM "MEP".z_test_2;
call "MEP".z_test();

-- For easy updates in one of the test tables:
update "MEP".z_test_1
set base_amount = 50
where item ='Olive oil';

insert into "MEP".z_test_2 (item, measurement_type, base_amount, base_unit)
values ('Olive oil', 'Liquid-volume', '80','fl oz');

-- Creation of the update test procedure:
create or replace procedure "MEP".z_test()
language plpgsql
as $$

begin

with cte as (
select * from "MEP".z_test_1 as zt1
union all
select * from "MEP".z_test_2 as zt2),

-- Tallies up the amounts of all ingredients:
update_cte as (
select item, measurement_type, base_unit, sum(base_amount) as current_base_amt
from cte
group by item, measurement_type, base_unit)

-- For items already in the pantry, this updates the amounts:
update "MEP".z_test_1 as zt1
set base_amount = uc.current_base_amt
from update_cte as uc
where zt1.item = uc.item;

-- Identifies items that are not already in the pantry:
insert into "MEP".z_test_1
select zt2.*
from "MEP".z_test_2 as zt2
left outer join "MEP".z_test_1 as zt1
on zt2.item = zt1.item
where zt1.base_amount is null;

commit;
end;
$$;



---------------


