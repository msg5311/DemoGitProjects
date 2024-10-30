-- select statement to view data:
select *
from a_allstats
order by name;

-- delete and drop statements to reset data:
delete from a_allstats where name not like '%QB%';

alter table a_allstats
drop column rush_td;

-- Passing, receiving, and rushing dataset alterations:
alter table passing_stats rename column yds to pass_yds;
alter table passing_stats rename column td to pass_td;
alter table passing_stats add category char(50) default ('passing');

alter table receiving_stats rename column yds to rec_yds;
alter table receiving_stats rename column td to rec_td;
alter table receiving_stats add category char(50) default ('receiving');

alter table rushing_stats rename column yds to rush_yds;
alter table rushing_stats rename column td to rush_td;
alter table rushing_stats add category char(50) default ('rushing');

-- insert names from receiving dataset to main ste:
insert into a_allstats (name)
select name
from receiving_stats;

-- insert names from rushing dataset to main set:
insert into a_allstats (name)
select name
from rushing_stats;

 -- adds cols missing from main table:
alter table a_allstats 
add pass_yds int null,
add pass_td int null,
add rec_yds int null,
add rec_td int null,
add rush_yds int null,
add rush_td int null,
add yac int null,
add rec int null;

-- Update passing cols:
update a_allstats
set		(pass_yds,pass_td)
		= (ps.pass_yds, ps.pass_td)
from passing_stats ps
where a_allstats.name = ps.name;

-- Update receiving cols:
update a_allstats
set 	(rec_yds,gp,avg,lng,rec_td,yac,yds_g,rec)
		= (rs.rec_yds, rs.gp, rs.avg, rs.lng, rs.rec_td,rs.yac,rs.yds_g,rs.rec)
from receiving_stats rs
where a_allstats.name = rs.name;

-- Update rushing cols:
update a_allstats
set	(rush_yds,gp,avg,lng,rush_td,yds_g)
	= (gg.rush_yds,gg.gp,gg.avg,gg.lng,gg.rush_td,gg.yds_g)
from rushing_stats gg
where a_allstats.name = gg.name;

-- Extract position from name:
alter table a_allstats
add pos char(50);

update a_allstats
set pos = right(name,2)
;

-- Data cleansing:
delete from a_allstats where name = 'Total';
update a_allstats
set name = left(name,length(name)-2);


-- create table:
create table fantasy_points_rules (
category char(50),
yds_value decimal(10,2),
td_value decimal(10,2),
count_value decimal(10,2)
);

-- insert values into fantasy table:
insert into fantasy_points_rules (category,yds_value,td_value,count_value)
values
('rec', 0.1,6,0.5),
('rush', 0.1,6,0),
('pass',0.04,4,0)
;

select * from fantasy_points_rules;

-- add fantasy points column into main table:
alter table a_allstats
add column fantasy_pts decimal(10,2);
