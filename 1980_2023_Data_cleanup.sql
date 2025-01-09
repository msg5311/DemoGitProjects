select * from "Helios_project".goodreads_1980_2023
where authors like 'Brandon Sanderson';

-- Clean the genres column of '' and []:
update "Helios_project".goodreads_1980_2023
set genres = replace(replace(replace(genres,'''',''),'[',''),']','');

-- Add columns for the top four genres:
alter table "Helios_project".goodreads_1980_2023 add genre_1 varchar(50);
alter table "Helios_project".goodreads_1980_2023 add genre_2 varchar(50);
alter table "Helios_project".goodreads_1980_2023 add genre_3 varchar(50);
alter table "Helios_project".goodreads_1980_2023 add genre_4 varchar(50);

-- Populate the new columns with a genre:
update "Helios_project".goodreads_1980_2023
set genre_1 = split_part(genres, ',',1);

update "Helios_project".goodreads_1980_2023
set genre_2 = split_part(genres, ',',2);

update "Helios_project".goodreads_1980_2023
set genre_3 = split_part(genres, ',',3);

update "Helios_project".goodreads_1980_2023
set genre_4 = split_part(genres, ',',4);

-- Change publication_date column type to date, and remove misc text from column:
alter table "Helios_project".goodreads_1980_2023 alter publication_date type DATE
using
case
	when publication_date like 'Published %' then cast (replace(publication_date, 'Published ','') as date)
	else cast (publication_date as date)
	end
;

alter table "Helios_project".goodreads_1980_2023 add publication_year integer;
update "Helios_project".goodreads_1980_2023
set publication_year = date_part('year',publication_date);

-- Create a list of the top 15 genres:
with top_genre_cte as (
select genre_1, sum(num_ratings) as totalratings, 'top 15' as category
from "Helios_project".goodreads_1980_2023
group by genre_1
order by totalratings desc
limit 15
),

-- Rank the top 15 genres:
top_genre_ranked_cte as (
select *, rank() over(partition by category order by totalratings desc) as genre_rank
from top_genre_cte
)

-- Join in the ranking of every genre to main list of books:
select *
from "Helios_project".goodreads_1980_2023
inner join top_genre_ranked_cte
on "Helios_project".goodreads_1980_2023.genre_1 = top_genre_ranked_cte.genre_1
order by num_ratings desc;



