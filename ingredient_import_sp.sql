-- Outstanding items:
-- 


-- Code to create a blank table to receive ingredients test:
select * into "MEP".all_ingredients_test from "MEP".all_ingredients_purchased;
delete from "MEP".z_all_ingredients_test;
alter table "MEP".ingredient_import_test drop column base_unit_identifier, drop column conversion, drop column unit_price;

-- Begin stored procedure:
create or replace procedure "MEP".ingredient_import_sp ()
language 'plpgsql'
as $$

begin

-- Take values from ingredient import list, join on solid_weight_conv table to convert and get to unit price, then append to all ingredients list:
insert into "MEP".z_all_ingredients_test 

with
solid_cte as (

-- Solid weight conv join:
select z_ingredient_import_test.*,b1_solid_weight_conv.base as base_unit_identifier, b1_solid_weight_conv.conv as conversion,  round(price/(amount*b1_solid_weight_conv.conv),2) as unit_price
from "MEP".z_ingredient_import_test
inner join "MEP".b1_solid_weight_conv
on z_ingredient_import_test.unit = b1_solid_weight_conv.recipe
where b1_solid_weight_conv.base = 'oz'),

liquid_cte as (
-- liquid weight conv join:
select z_ingredient_import_test.*, b2_liquid_vol_conv.base as base_unit_identifier, b2_liquid_vol_conv.conv as conversion, round(price/(amount*b2_liquid_vol_conv.conv),2) as unit_price
from "MEP".z_ingredient_import_test
inner join "MEP".b2_liquid_vol_conv
on z_ingredient_import_test.unit = b2_liquid_vol_conv.recipe
where b2_liquid_vol_conv.base = 'fl oz'),

-- Unit and sub_unit items:
unit_cte as (
select *, measurement_type as base_unit_identifier, 1 as conversion, round(price/(amount),2) as unit_price
from "MEP".z_ingredient_import_test
where lower(measurement_type) like 'unit' or lower(measurement_type) = 'sub_unit')

-- union these two together:
select * from solid_cte
union
select * from liquid_cte
union
select * from unit_cte

commit;


end;
$$; 

-- Call stored procedure:
call "MEP".ingredient_import_sp ();