-- Identify most expensive ingredient in each recipe:

-- creating CTE cost_cte with largest cost for each recipe:
with cost_cte as (
select recipe, max(cost) as expensive
from recipe_ingredient_list
group by recipe
)

-- joining with the full recipe list to get corresponding item: 
select ril.recipe, ril.item, cost_cte.expensive
from recipe_ingredient_list as ril
join cost_cte
on ril.cost = cost_cte.expensive
where ril.recipe = cost_cte.recipe
order by expensive desc
;

-- show which items are the most popular:
select item, count(*) as count_item
from recipe_ingredient_list
group by item
order by count_item desc;

-- create total cost of each recipe:
select recipe, sum(cost) as total_cost
from recipe_ingredient_list
group by recipe
order by total_cost desc;

