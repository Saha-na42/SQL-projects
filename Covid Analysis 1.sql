SELECT * FROM covid_analysis.covid_stats;

ALTER TABLE `covid_analysis`.`covid_stats` 
CHANGE COLUMN `Country/Region` `Location` TEXT NULL DEFAULT NULL ;
ALTER TABLE `covid_analysis`.`covid_stats` 
CHANGE COLUMN `New cases` `new_cases` TEXT NULL DEFAULT NULL ;
ALTER TABLE `covid_analysis`.`covid_stats`
CHANGE COLUMN `New deaths` `new_deaths` TEXT NULL DEFAULT NULL ;

-- Data to be explored 

SELECT Date, Location, Confirmed, Deaths, new_cases, new_deaths 
FROM covid_analysis.covid_stats
ORDER BY 1,2;

-- Total cases vs Total Deaths
SELECT Date, Location, Confirmed, Deaths, new_cases, new_deaths, Deaths/Confirmed  
FROM covid_analysis.covid_stats
ORDER BY 1,2;
SELECT Date, Location, Confirmed, Deaths, new_cases, new_deaths, (Deaths/Confirmed)*100 as Deathrate 
FROM covid_analysis.covid_stats
ORDER BY 1,2;

-- Likelihood of a person from a country getting infected 
SELECT Date, Location, Confirmed, Deaths, new_cases, new_deaths, (Deaths/Confirmed)*100 as Deathrate 
FROM covid_analysis.covid_stats
WHERE Location = 'India'
ORDER BY 1,2 DESC;

-- Countries with Highest Infection Rate 
SELECT  Location, MAX(Confirmed) as HighestInfectionCount 
FROM covid_analysis.covid_stats
GROUP BY Location 
ORDER BY HighestInfectionCount desc;

-- Countries with Highest Death Rate
SELECT  Location, MAX(Deaths) as Totaldeathcount
FROM covid_analysis.covid_stats
GROUP BY Location 
ORDER BY Totaldeathcount desc;

-- Total cases vs Total Deaths (worldwide combined)
SELECT  SUM(new_cases) as Total_Cases, SUM(new_deaths) as Total_Deaths, 
(SUM(new_deaths)/SUM(new_cases))*100 as Total_deathrate
FROM covid_analysis.covid_stats
WHERE Location is not null
ORDER BY 1,2;

-- Worldometer_data

SELECT * FROM covid_analysis.worldometer_data;
ALTER TABLE `covid_analysis`.`worldometer_data` 
CHANGE COLUMN `Country/Region` `Location` TEXT NULL DEFAULT NULL ;

SELECT Location, Population
FROM covid_analysis.worldometer_data;

SELECT distinctrow stat.Location, wd.Population, 
SUM(stat.new_cases) over (partition by stat.location order by stat.Location) as Totalcases
FROM covid_analysis.covid_stats  stat
join covid_analysis.worldometer_data wd
On stat.Location = wd.Location
Order by 1,2; 

-- GDP
SELECT *
FROM covid_analysis.`gdp_percapita 2019-2021`;
ALTER TABLE `covid_analysis`.`gdp_percapita 2019-2021` 
CHANGE COLUMN `Country/Territory` `Location` TEXT NULL DEFAULT NULL ;
ALTER TABLE `covid_analysis`.`gdp_percapita 2019-2021` 
CHANGE COLUMN `gdp_estimate after` `gdp_estimate_aftercovid` TEXT NULL DEFAULT NULL ;
ALTER TABLE `covid_analysis`.`gdp_percapita 2019-2021` 
CHANGE COLUMN `Year as per IMF` `year_c`  TEXT NULL DEFAULT NULL ;

select Location, MAX(gdp_estimate_aftercovid) as HighestGDP
FROM covid_analysis.`gdp_percapita 2019-2021`
group by Location
order by HighestGDP asc;

