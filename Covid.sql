Select location,time, total_cases,total_deaths, (total_deaths/total_cases)*100
as Death_Percentage
from covid_deaths
where location like '%Czech%'
order by death_percentage desc;
-- Rough estimate probability of dying depending on the date  in the Czech Republic

Create or replace view death_probability as
Select location,time, total_cases,total_deaths, (total_deaths/total_cases)*100
as Death_Percentage
from covid_deaths
where location like '%Czech%'
order by death_percentage desc;
-- View of probability of dying in the Czechia

select location,time, total_cases,population, (total_cases/population)*100
as Infected_people
from covid_deaths
where location like '%Czech%'
order by infected_people desc;
-- Rough estimate percentage wise infected vs population in the Czech Republic

create or replace view infected_percentage_of_population as
select location,time, total_cases,population, (total_cases/population)*100
as Infected_people
from covid_deaths
where location like '%Czech%'
order by infected_people desc;
-- View of infected percentage of population 

select location,time,new_cases,population, (new_cases/population)*100
as Infected_people
from covid_deaths
where location like '%Czech%'
order by infected_people desc;
-- rough estime of probabily to get infected depending on the date in the Czech Republic

Create or replace view probability_of_getting_infected as 
select location,time,new_cases,population, (new_cases/population)*100
as Infected_people
from covid_deaths
where location like '%Czech%'
order by infected_people desc;
-- View probability of getting infected in the Czech republic

select location,population,max(total_cases) as highest_infection_count, MAX(total_cases/population)*100
as Infected_people
from covid_deaths
where continent is not null
group by location,population
order by infected_people desc;
-- Highest amount of infected per country ordered by percentage of infected 

Create or replace view Max_infected_percentage as
select location,population,max(total_cases) as highest_infection_count, MAX(total_cases/population)*100
as Infected_people
from covid_deaths
where continent is not null
group by location,population
order by infected_people desc;
-- View of max percentage of infected by country

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as Death_Percentage
from covid_deaths
where continent is not null
order by 1,2;
-- Death percentage worldwide

Select location, SUM(cast(new_deaths as int)) as Total_Death_count
From Covid_deaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by Total_Death_count desc;
-- Death count by continent

Create or replace view Total_death_count as
Select location, SUM(cast(new_deaths as int)) as Total_Death_Count
From Covid_deaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by Total_Death_Count desc;
--View of  Death count by continent

Select Location, Population, MAX(total_cases) as Highest_infected_number,  Max((total_cases/population))*100 as Infected_percentage_population
From covid_deaths
Group by Location, Population
order by Infected_percentage_population desc;
-- Highest number of infected per country

Create or replace view Infected_percentage_population as
Select Location, Population, MAX(total_cases) as Highest_infected_number,  Max((total_cases/population))*100 as Infected_percentage_population
From covid_deaths
Group by Location, Population
order by Infected_percentage_population desc;
-- View of Highest number of infected per country

select location, max(cast(total_deaths as int )) as deceased
from covid_deaths
where continent is not null
group by location
order by deceased desc;
-- deceased people by location

select location, max(cast(total_deaths as int )) as deceased
from covid_deaths
where continent is null
group by location
order by deceased desc;
-- deceased people by Continent

Select time,sum(new_cases) as number_of_new_cases , sum(new_deaths) as number_of_new_deaths, 
sum(new_deaths)/sum(new_cases)*100 as percentage_of_deaths_to_cases
from covid_deaths
where continent is not null
group by time
order by 1,2;
-- number of new cases, number of new deaths and percentage of dead to infected per day

Create or replace view death_ratio as
Select time,sum(new_cases) as number_of_new_cases , sum(new_deaths) as number_of_new_deaths, 
sum(new_deaths)/sum(new_cases)*100 as percentage_of_deaths_to_cases
from covid_deaths
where continent is not null
group by time
order by 1,2;
-- View of death ratio(death to cases)

Select d.continent, d.location, d.time, d.population
, MAX(v.total_vaccinations) as ammount_of_vaccinated
From covid_deaths d
Join covid_vaccination v
	On d.location = v.location
	and d.time = v.time
where d.continent is not null 
group by d.continent, d.location, d.time, d.population
order by 1,2,3;
-- Ammount of vaccinated per country

Create or replace view Amount_of_vaccinated as
Select d.continent, d.location, d.time, d.population
, MAX(v.total_vaccinations) as ammount_of_vaccinated
From covid_deaths d
Join covid_vaccination v
	On d.location = v.location
	and d.time = v.time
where d.continent is not null 
group by d.continent, d.location, d.time, d.population
order by 1,2,3;
-- View of ammount of vaccinated per country

With Population_vaccinated (Continent, Location,time, population,new_vaccinations, total_vaccinated)
as(
select d.continent, d.location, d.time, d.population, v.new_vaccinations, sum(v.new_vaccinations) over( partition by d.location order by d.location, d.time) as total_vaccinated
from covid_deaths d
join covid_vaccination v
on d.location=v.location
and d.time=v.time
where d.continent is not null
order by 2,3)
Select Continent, Location,time, population,new_vaccinations, total_vaccinated,( total_vaccinated / population)*100 as Percentage_of_vaccinated from Population_vaccinated;
-- Percentage of vaccinated people in population

Create or replace view vaccinated_population as
select d.continent, d.location, d.time, d.population, v.new_vaccinations, sum(v.new_vaccinations) over( partition by d.location order by d.location, d.time) as total_vaccinated
from covid_deaths d
join covid_vaccination v
on d.location=v.location
and d.time=v.time
where d.continent is not null
order by 2,3;
-- View of newly vaccinated and total number of vaccinated per country
