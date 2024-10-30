-- select statement to view data:
select *
from a_allstats
order by pos
;

-- delete and drop statements to reset data:
delete from a_allstats where name not like '%QB%';
alter table a_allstats
drop column pos;

-- insert names from receiving dataset to main ste:
insert into a_allstats (name)
select name
from receiving_stats;

-- insert names from rushing dataset to main set:
insert into a_allstats (name)
select name
from rushing_stats;

 -- adds receiving cols missing from main table:
alter table a_allstats 
add yac int null,
add rec int null;

-- adds rushing cols missing from main table:

-- Update cols that are in both table:
update a_allstats
set 	(yds,gp,avg,lng,td,yac,yds_g,rec)
		= (rs.yds, rs.gp, rs.avg, rs.lng, rs.td,rs.yac,rs.yds_g,rs.rec)
from receiving_stats rs
where a_allstats.name = rs.name;

-- Update cols that are in both tables (rushing and main):
update a_allstats
set	(yds,gp,avg,lng,td,yds_g)
	= (gg.yds,gg.gp,gg.avg,gg.lng,gg.td,gg.yds_g)
from rushing_stats gg
where a_allstats.name = gg.name;

-- Extract position from name:
alter table a_allstats
add pos char(50);

update a_allstats
set pos = right(name,2)
;

-- Delete total rows:
delete from a_allstats where name = 'Total';

-- create table:
create table fantasy_points_rules (
category char(50),
point_value decimal(10,2)
);

-- insert values into fantasy table:
insert into fantasy_points_rules (category,point_value)
values
('rec_yds', 0.1),
('rush_yds', 0.1),
('pass_yds',0.04),
('rec_td',6),
('rush_td',6),
('pass_td',4),
('rec_count',0.5);

select * from fantasy_points_rules;

