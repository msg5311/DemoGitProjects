select *
from a_allstats
order by total_yds desc
;

update a_allstats set pass_yds = 0 where pass_yds is null;
update a_allstats set pass_td = 0 where pass_td is null;
update a_allstats set rush_yds = 0 where rush_yds is null;
update a_allstats set rush_td = 0 where rush_td is null;
update a_allstats set rec_yds = 0 where rec_yds is null;
update a_allstats set rec_td = 0 where rec_td is null;
update a_allstats set rec = 0 where rec is null;
update a_allstats set yac = 0 where yac is null;

alter table a_allstats add total_yds decimal(10,2) generated always as (pass_yds + rush_yds + rec_yds) stored;

alter table a_allstats add proj_yds decimal(10,2) generated always as (18/gp * (total_yds)) stored;

-- Temporary tables: 
-- Used for storing intermediate results for complex queries, similar to CTEs

create temporary table temp_table
(name varchar(50),
pos varchar(50),
gp int,
total_yds decimal(10,2)
);


create temp table temp_table_stats as
select *
from a_allstats;

create temp table new_temp_stats as
select name, pos, gp, pass_yds, rush_yds, rec_yds
from a_allstats;

alter table new_temp_stats add total_yds decimal(10,2) generated always as (pass_yds + rush_yds + rec_yds) stored;
alter table new_temp_stats add proj_yds decimal(10,2) generated always as (total_yds * 18) stored;

-- CTE:
with CTE_Example as 
select
from a_allstats

alter table a_allstats add column team_name varchar(50) default 'NYJ';

-- CTE example:

-- creating a CTE to use for calculations below:
with position_cte as (
select pos, max(total_yds) as max_yds
	from a_allstats
	group by pos
)

-- running calculations in the CTE and referencing it several times:
select * from position_cte where max_yds > (select avg(max_yds) from position_cte) order by max_yds desc;

