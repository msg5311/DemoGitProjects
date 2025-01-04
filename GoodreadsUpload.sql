
-- Initial view of data:
SELECT * FROM "Helios_project".goodreads_top100k
order by totalratings desc;



-- Add columns for the top 4 genres
alter table "Helios_project".goodreads_top100k add genre_1 varchar(50);
alter table "Helios_project".goodreads_top100k add genre_2 varchar(50);
alter table "Helios_project".goodreads_top100k add genre_3 varchar(50);
alter table "Helios_project".goodreads_top100k add genre_4 varchar(50);

-- Update these new columns for genres
update "Helios_project".goodreads_top100k
set genre_1 = split_part(genre, ',',1);

update "Helios_project".goodreads_top100k
set genre_2 = split_part(genre, ',',2);

update "Helios_project".goodreads_top100k
set genre_3 = split_part(genre, ',',3);

update "Helios_project".goodreads_top100k
set genre_4 = split_part(genre, ',',4);

-- Pull list of titles totalratings desc
select title, author, genre_1, totalratings
from "Helios_project".goodreads_top100k
order by totalratings desc

-- Rank the books in each category
select title, author, rating, totalratings, reviews,
genre_1,
rank () over ( partition by genre_1
order by totalratings desc
) as Rank_no
from "Helios_project".goodreads_top100k
where genre_1 like 'Romance%'
order by Rank_no asc
;

-- Create top 10 rank of books by category
select genre_1, Rank_Nummy, title, author, totalratings
from (
	select title, author, totalratings, genre_1, rank()
		over (partition by genre_1
			order by totalratings desc) as Rank_Nummy
	from "Helios_project".goodreads_top100k
	) where Rank_Nummy <= 10
	order by genre_1 asc;

-- Group by genre to see what is most popular
select genre_1, sum(totalratings) as sum_ratings, avg(rating) as avg_rating
from "Helios_project".goodreads_top100k
group by genre_1
order by sum_ratings desc
limit 15;



-- Create new table based on narrowed search:
create table "Helios_project".narrow_search
as


-- CTE to filter down the top genres
with top_genre_cte as (
select genre_1, sum(totalratings) as sum_ratings, avg(rating) as avg_rating
from "Helios_project".goodreads_top100k
group by genre_1
order by sum_ratings desc
limit 15
),
-- CTE to rank the main table in genre:
total_list_cte as (
select title, genre_1, rank() over (partition by goodreads_top100k.genre_1 order by totalratings desc) as genre_rank
from "Helios_project".goodreads_top100k
order by totalratings desc
)

-- create table of only the top 15 genres, and the top 50 books of each genre:
select goodreads_top100k.title, goodreads_top100k.genre_1, totalratings, rating, reviews, genre_rank
from "Helios_project".goodreads_top100k
inner join top_genre_cte
on "Helios_project".goodreads_top100k.genre_1 = top_genre_cte.genre_1

inner join total_list_cte
on "Helios_project".goodreads_top100k.title = total_list_cte.title

where genre_rank <= 50
order by totalratings desc;

















