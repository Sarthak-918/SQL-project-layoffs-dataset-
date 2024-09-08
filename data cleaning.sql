-- data cleaning of a company layoffs dataset from around the world


-- creating the table to then import the data from the CSV file
create table layoffs (
	"company" varchar(50),
    "location" varchar(50),
	"industry" varchar(50),
	"total_laid_off" float(50),
	"percentage_laid_off" float(50),
	"date" text,
	"stage" varchar(50),
	"country" varchar(50),
	"funds_raised_millions" float(50)
)

-- create another table layoffs2 which is the same as the original table 
-- so we can make changes in that table and not change the original data 
CREATE TABLE layoffs2 (LIKE layoffs INCLUDING ALL);

select * from layoffs2;

insert into layoffs2
select * 
from layoffs;

--identifying the duplicate rows
with cte_1 as 
(
select *,
row_number() over(partition by company,location,industry,total_laid_off,
	percentage_laid_off,"date",stage,country,funds_raised_millions) as row_num
from layoffs2
)
select *
from cte_1 where row_num>1

-- deleting the duplicate rows
WITH cte_1 AS
(
SELECT ctid, 
ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off,
percentage_laid_off, "date", stage, country, funds_raised_millions ORDER BY ctid) AS rn
FROM layoffs2
)
delete from layoffs2 
WHERE ctid IN (
    SELECT ctid FROM cte_1 WHERE rn > 1);

select company,trim(company)
from layoffs2;

select distinct(industry)
from layoffs2 order by 1;

--there are different names of crypto industry so we make them all the same 
-- we do this with other industries as well
select * 
from layoffs2 where industry like 'Crypto%';

update layoffs2
set industry='Crypto'
where industry like 'Crypto%';

select distinct(country)
from layoffs2 order by 1;

--cleaning the data by removing unwanted values before or after the name like .,/
update layoffs2
set country=trim(trailing '.' from country)
where country like ('United States%');

-- changing the date format as per your need 
UPDATE layoffs2
SET "date" = TO_CHAR(TO_DATE("date", 'MM-DD-YYYY'), 'DD-MM-YYYY');


-- filling the empty industries values by checking other records
select *
from layoffs2
where industry is null;

select *
from layoffs2 where company='Carvana';

update layoffs2
set industry='Transportation'
where company='Carvana';

-- deleting the rows where the total laid off and the percentage laid off number are both zero
-- as they are of no use to us and we cant fill them with the information we have 
select *
from layoffs2 where total_laid_off is null 
and percentage_laid_off is null;

delete
from layoffs2 where total_laid_off is null 
and percentage_laid_off is null;



