
-- creating table in the database

drop table olympics;
create table olympics(
	id text,
	name text,
	sex text,
	age text, -- has NA values hence the reason we have it defined as text
	height text, -- has NA values hence the reason we have it defined as text
	weight text, -- has NA values hence the reason we have it defined as text
	team text,
	noc text,
	games text,
	year smallint,
	season text,
	city text,
	sport text,
	event text,
	medal text
);

select * from olympics;

copy olympics
from 'C:\Users\KEVIN\Desktop\SQL_Analysis_Posgre\athlete_events.csv'
with(format csv, header)

-- We have missing values from the table, the same is on weight Age and Height, 

select
	count(*)
from olympics
where age = 'NA' -- age we have about 9474

select 
	count(*)
from olympics
where weight = 'NA' -- Weight has 62875 missing actual weight

select
	count(*)
from olympics
where height = 'NA' -- Height has 60171 missing actual weight

-- plan is to perform analysis on everything, the number of missing values are handful.

--Creating country database
create table countries(
	code text,
	country text,
	note text
)

copy countries
from 'C:\Users\KEVIN\Desktop\SQL_Analysis_Posgre\noc_regions.csv'
with(format csv, header)

--Joining Country with Olympics data
select *
from olympics o
left join countries c
on o.noc = c.code

--Creating a view, to only maintain the columns needed.
create view olympics_data as
select 
	name,
	sex,
	age,
	height,
	weight,
	team,
	games,
	year,
	season,
	city,
	sport,
	event,
	medal,
	country
from olympics o
left join countries c
on o.noc = c.code


--Snippet

select * from olympics_data
limit 5

-- ***Questions****
-- Participating nations -- Total of 206 countries have graced the competition since it was first held

select 
 count(distinct country) as participating_countries
from olympics_data

--Number of Athletes -- 134732
select
	count(distinct name) as participating_athletes
from olympics_data

--Sports count -- 66 sporting disciplines

select
	count(distinct sport) as sports
from olympics_data

--Olympics competition -- 35 Olympics competition have been held

select
	count(distinct year) as number_of_olympics_held
from olympics_data


-- Seasons for the competition
select
	distinct year,
	season
from olympics_data

-- Country participation per year - 2016 recorded the highest while 1896 recorded the lowest.
select
	distinct year,
	count(distinct country)
from olympics_data
group by year
order by count(distinct country) desc


--The country that has participated the most
-- Top 20 countries that have most appearance
select 
	distinct country,
	count(distinct year)
from olympics_data
group by country
order by count(distinct year) desc
limit 20

-- Bottom 20 countries that have least appearance
select 
	distinct country,
	count(distinct year)
from olympics_data
group by country
order by count(distinct year) asc
limit 20


--Most featured sport in order

select 
	distinct sport,
	count(distinct year)
from olympics_data
group by sport
order by count(distinct year) desc


--Medals -- Oldest athletes to ever win a gold medals(Top 20)

select
	distinct name,
	age,
	event
from olympics_data
where medal ='Gold' and age <> 'NA'
order by age desc
limit 20;

--Gender Representation
select
(select
	count(sex) 
from olympics_data
where sex = 'M') as male_athletes,
(select
	count(sex) 
from olympics_data
where sex = 'F') as female_athletes


--Medals tally per county
select
	distinct country,
	count(medal)
from olympics_data
where medal <>'NA'
group by country
order by count(medal) desc


select * from olympics_data
limit 5

create extension tablefunc;



--Total medals

create view gold as
select
	country,
	count(medal)
from olympics_data
where medal = 'Gold'
group by country


create view silver as
select
	country,
	count(medal)
from olympics_data
where medal = 'Silver'
group by country


create view bronze as
select
	country,
	count(medal)
from olympics_data
where medal = 'Bronze'
group by country


create view total_medal as
select
	country,
	count(medal)
from olympics_data
where medal <> 'NA'
group by country



--Medlas Tally
select 
	country,
	g.count as gold,
	s.count as silver,
	b.count as bronze,
	tm.count
from total_medal tm
left join gold g
using(country)
left join silver s
using(country)
left join bronze b
using(country)
order by tm.count desc





































