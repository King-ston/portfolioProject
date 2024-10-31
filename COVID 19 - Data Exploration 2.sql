
/*
--Covid 19 Data Exploration

-- Skill used: CTE's, Windows Function, Aggregate Function, Converting Data Types
*/

select *
from CovidDeaths
where continent is not null
order by 3,4



Select Location, year(date), sum(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by date, location
order by TotalDeathCount desc




-- Top 10 Countries with Lowest Death Count per Year

with Deaths_Rate as 
(
Select Location, year(date) as years, sum(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by year(date), location
), death_ranking  as
(
select *, DENSE_RANK() over(partition by years order by totaldeathcount) as Dense_Ranking
from Deaths_Rate
where TotalDeathCount is not null
)
select*
from death_ranking
where Dense_Ranking <= 10




-- Global Covid-19 Death Count Ranking: Top 10 Countries

with Deaths_Rate as 
(
Select Location, year(date) as years, sum(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by year(date), location
), Death_Ranking as
(
select *, DENSE_RANK() over(partition by years order by totaldeathcount desc) as Dense_Ranking
from Deaths_Rate
where TotalDeathCount is not null
)
select*
from Death_Ranking
where dense_ranking <= 10


-- COVID-19 Cases/Deaths Annual

select year(date) as years, sum(total_cases) as totalcase, sum(convert(int,total_deaths)) as totaldeaths
from CovidDeaths
where continent is not null
group by year(date)
order by 2


-- COVID-19 Cases/Deaths by Continent(Annual)

select  continent, year(date) as years, sum(total_cases) as totalcase, sum(convert(int,total_deaths)) as totaldeaths
from CovidDeaths
where continent is not null
group by year(date), continent
order by 2


-- RollingSum of COVID -19 Deaths by Continent(Annual)


with rolling as
(
select  continent, year(date) as years, sum(convert(int,total_deaths)) as totaldeaths
from CovidDeaths
where continent is not null
group by year(date), continent
--order by 2

)
select  continent,years, totaldeaths, 
sum(totaldeaths) over(partition by years order by continent) as rolling_sum_of_deaths
from rolling



-- Breaking Down COVID-19 Deaths by Continent and Region using CTE

with region_cte as
(
select continent, location, year(date) as years, sum(convert(int,total_deaths)) as totaldeaths
from CovidDeaths
where continent is not null
and total_deaths is not null
group by  year(date),location, continent
), region_breakdown as
(
select *, DENSE_RANK() over(partition by continent, years order by totaldeaths desc) as dense_ranking
from region_cte
)
select *
from region_breakdown
where dense_ranking <= 10




-- Top 10 Total Deaths by Continent and Region


with GEO_DEATHS_BREAKDOWN as
(
select continent, location, sum(convert(int,total_deaths)) as total_Deaths
from CovidDeaths
where continent is not null
group by continent, location
), GEO_DEATHS as
(
select *, DENSE_RANK() over(partition by continent order by total_Deaths desc) as Ranking
from GEO_DEATHS_BREAKDOWN
where total_Deaths is not null
)
select *
from GEO_DEATHS
where ranking <= 10


-- The Rate of Infection in a Country by Ages

select location, sum(total_cases) as totalcases, cast(avg(median_age) as int) as adolescence ,
cast(avg(aged_65_older) as int) adult,
cast(avg(aged_70_older) as int) as old
from CovidDeaths
where continent is not null
and total_cases is not null
group by  location
order by 2 desc




-- rate of people with diabetes and their life expectancy

select continent, sum(total_cases) as totalcase,
round(avg(diabetes_prevalence), 2) as diabetes_prevalence, 
round(avg(life_expectancy),2) as life_expectancy
from CovidDeaths
where continent is not null
group by continent
order by 1


-- number of smokers infected in a region

with smokers as
(
select continent, location, sum(total_cases) as totalcase,
sum(try_convert( int,male_smokers)) as male, sum(try_convert( int,female_smokers)) as female 
from CovidDeaths
where continent is not null
group by location, continent
)
select *
from smokers
where female is not null
or male is not null
order by 1











