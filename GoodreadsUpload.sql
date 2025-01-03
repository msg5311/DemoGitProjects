
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
where genre_1 like 'Fantasy%'
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



-- Sort authors descending by total ratings
select author, sum(totalratings) as tot_ratings, count(title) as books
from "Helios_project".goodreads_top100k
group by author

order by tot_ratings desc
;



-- Trim the genre column to only the top 4 categories
select title, genre, split_part(genre, ',',1) || ', ' || split_part(genre, ',',2) || ', ' || split_part(genre, ',',3) || ', ' || split_part(genre, ',',4) as fourth
from "Helios_project".goodreads_top100k
order by totalratings desc;