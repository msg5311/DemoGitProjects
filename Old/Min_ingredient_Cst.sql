--SELECT * FROM "MEP".all_ingredients_purchased


select generic_item_name, store, min(unit_price)
from "MEP".all_ingredients_purchased
group by generic_item_name, store;

select generic_item_name, Giant, TJs, Costco
from 
( select generic_item_name, store, unit_price
from "MEP".all_ingredients_purchased
) s
pivot
(
min(unit_price) for store in (Giant, TJs, Costco)
) p;

-- Min ingredient cost by store:
select generic_item_name,
min(case when store = 'Giant' then unit_price end) as Giant,
min(case when store = 'TJs' then unit_price end) as TJs,
min(case when store = 'Costco' then unit_price end) as Costco
from "MEP".all_ingredients_purchased
group by generic_item_name
order by generic_item_name Asc;
;
