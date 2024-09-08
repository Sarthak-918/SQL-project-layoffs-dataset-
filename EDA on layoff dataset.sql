-- EDA on company layoffs dataset from around the world
-- First import the data from CSV file into layoff table and make another table layoffs2
-- which is the copy of the original table and now we can work on our data 

select * from layoffs2;

select total_laid_off 
from layoffs2;

--checking the number of people laid off 
select max(total_laid_off),min(total_laid_off),avg(total_laid_off)
from layoffs2;

--all the companies that fully shut down 
select company,percentage_laid_off,funds_raised_millions 
from layoffs2
where percentage_laid_off ='1'
order by 1;

--companies with the highest laid off employees
select company,sum(total_laid_off) 
from layoffs2
where total_laid_off is not null
group by company
order by 2 desc;

--industries with most laid off employees
select industry,sum(total_laid_off) 
from layoffs2
where total_laid_off is not null
group by industry
order by 2 desc;


--countries with highest laid off employees
select country,sum(total_laid_off) 
from layoffs2
where total_laid_off is not null
group by country
order by 2 desc;

--which year had how many layoffs
select substring(date,1,4)as year,sum(total_laid_off)
from layoffs2
where substring(date,1,4) is not null
group by substring(date,1,4)
order by 1;


--ordering the layoffs by each month throughout the years
select substring(date,1,7)as month_and_year,sum(total_laid_off)
from layoffs2
where substring(date,1,7) is not null
group by substring(date,1,7)
order by 1;

--rolling total of layoffs by each month

with rolling_total as
(
select substring(date,1,7)as month_and_year,sum(total_laid_off) as total
from layoffs2
where substring(date,1,7) is not null
group by substring(date,1,7)
order by 1	
)
select month_and_year,total,sum(total)over(order by month_and_year)
from rolling_total;

--which companies laid off how many employees per year
select company,substring(date,1,4),sum(total_laid_off) 
from layoffs2
where substring(date,1,4) is not null
group by company,substring(date,1,4)
order by 1,2;










