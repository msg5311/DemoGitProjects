-- drop tables for reset:
drop table a_allstats;
drop table fantasy_points_rules;

-- create a_allstats table:
create table a_allstats (
name char(50),
id int not null primary key generated by default as identity);

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

-- insert names from passing dataset to main set:
insert into a_allstats(name)
select name
from passing_stats;

-- insert names from receiving dataset to main set:
insert into a_allstats (name)
select name
from receiving_stats;

-- insert names from rushing dataset to main set:
insert into a_allstats (name)
select name
from rushing_stats;

 -- adds cols missing from main table:
alter table a_allstats 
add gp int null,
add avg decimal(10,2),
add lng int null,
add yds_g decimal(10,2),
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
set		(pass_yds,pass_td,gp)
		= (ps.pass_yds, ps.pass_td,ps.gp)
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

-- Removing duplicates:
with duplicates as(
	select name,id, Row_Number() Over(
	partition by name, pos
	order by id asc -- this dictates the order in the temp table.
	) as rownum
	from a_allstats
)
delete from a_allstats
using duplicates
where a_allstats.id = duplicates.id and duplicates.rownum > 1;

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
add column fantasy_pass_pts decimal(10,2),
add column fantasy_rush_pts decimal(10,2),
add column fantasy_rec_pts decimal(10,2)
;

update a_allstats
set fantasy_pass_pts = (pass_yds * fantasy_points_rules.yds_value) + (pass_td * fantasy_points_rules.td_value)
from fantasy_points_rules
where category = 'pass';

update a_allstats
set fantasy_rush_pts = (rush_yds * fantasy_points_rules.yds_value) + (rush_td * fantasy_points_rules.td_value)
from fantasy_points_rules
where category = 'rush';

update a_allstats
set fantasy_rec_pts = min((rec_yds * fantasy_points_rules.yds_value) + (rec_td * fantasy_points_rules.td_value) + (rec * fantasy_points_rules.count_value),0)
from fantasy_points_rules
where category = 'rec';

alter table a_allstats
add testing decimal(10,2);

-- Replace nulls in fantasy pts cols with zeros...  change previous updates statements to min() in future:
update a_allstats set fantasy_pass_pts = 0 where fantasy_pass_pts is null;
update a_allstats set fantasy_rush_pts = 0 where fantasy_rush_pts is null;
update a_allstats set fantasy_rec_pts = 0 where fantasy_rec_pts is null;

update a_allstats
set fantasy_pts = fantasy_pass_pts + fantasy_rush_pts + fantasy_rec_pts;

select *
from a_allstats
order by fantasy_pts desc;