-- Transposing conversion table to be column dominant:

SELECT * FROM public.liquid_vol_conversions

with cte_transform as (

select lvc.to_unit, t.base,t.conversion
from liquid_vol_conversions as lvc
	cross join lateral (
		values
		(lvc.fl_oz_base,'fl_oz_base'),
		(lvc.tsp_base,'tsp_base'),
		(lvc.tbs_base,'tbs_base'),
		(lvc.ml_base,'ml_base'),
		(lvc.c_base,'c_base')
	) as t(conversion,base)
order by to_unit, base
)

select to_unit as recipe, replace(base,'_base','') as base, conversion
from cte_transform
;

-- create table for solid_weight conversions:

create table solid_weight_conversions (
recipe varchar(50),
oz decimal(10,2),
g decimal(10,2),
lb decimal(10,2)
);

-- add values to table:

insert into solid_weight_conversions
values
('oz',1,28.3495,0.0625),
('g', 0.0353,1,0.0022),
('lb', 16,453.59237,1)
;

select * from solid_weight_conversions;

