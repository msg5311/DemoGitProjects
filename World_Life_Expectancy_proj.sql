select country,year, concat(country,year) as combo, count(concat(country,year)) as tally
from mydata
GROUP BY country, year, combo
having count(concat(country,year)) > 1
;

Select *
From(
    select row_id,
    concat(country,year),
    row_number () OVER(PARTITION BY concat(country,year) order by concat(country,year)) as Row_Num
    from mydata
    ) as Row_table
Where Row_num > 1
;

Delete from mydata
where 
    row_id IN (
        Select row_id
From(
    select row_id,
    concat(country,year),
    row_number () OVER(PARTITION BY concat(country,year) order by concat(country,year)) as Row_Num
    from mydata
    ) as Row_table
Where Row_num > 1

    )
;

select *
from mydata
where status ISNULL
;

select distinct(country)
from mydata
where status = 'Developing'
;

update mydata
set status = 'Developing'
where country in (
    select distinct(country)
    from mydata
    where status = 'Developing'
    );

select *
from mydata
where status ISNULL
;