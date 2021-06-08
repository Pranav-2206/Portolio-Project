use Project




--Selecting data I would be using mostly
select location, date, total_cases, new_cases, total_deaths, population from death
	order by 1,2


--Total Cases v/s total Deaths and finding DEATH RATE In a Country 
select location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 
	as 'Death Rate' from death order by 1; 


--Total Cases v/s total Deaths and finding DEATH RATE In INDIA
select location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 
	as 'Death Rate' from death where location = 'India' order by 1; 


--Percent Of Population Infected 
select location,date, population, total_cases, (total_cases/population)*100 as 'Percentage of Population Infected' 
	 from death order by 1,2; 


--highest infection rates per population 
select location,
population, max(total_cases) as HighestInfectionCount , max(total_cases/population)*100 as Percentage_Population_infected
from death  group by location, population order by Percentage_Population_infected desc ;


--Showing Countries with Highest death tally and Death_Rate
select location,
population, max(cast(total_deaths as int)) as HighestDeathTally , max(total_deaths/total_cases)*100 
	as 'Death Rate'
from death where continent is not null group by location, population order by 3 desc ;


--Deaths Per continents
select continent, max(cast(total_deaths as int)) as HighestDeaths from Project..death where 
continent is not null group by continent order by 
HighestDeaths desc; 

 
 --Global Numbers
select sum(new_cases) as Total_cases, sum(cast(new_deaths as int)) as Total_deaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as Overall_death_percentage
 from death where continent is not null;



--Total vaccination v/s Population ROLLING VACCINATION SUM
select death.location, death.continent, death.date, death.population, vaccine.new_vaccinations
, sum(convert(int, vaccine.new_vaccinations)) over (partition by death.location order by death.location, death.date) as Rolling_vaccination_sum
from vaccine join death 
on vaccine.location = death.location and vaccine.date = death.date where death.continent is
not null and death.location = 'India'
order by 1,2,3


-- how many of the population got the jab ... Gotta use the CTE OR TEMP TABLE
with Percentjabbed (continent, location, date, population, New_Vaccinations, Rolling_Vaccination_sum) 
as
(
select death.location, death.continent, death.date, death.population, vaccine.new_vaccinations
, sum(convert(int, vaccine.new_vaccinations)) over (partition by death.location order by death.location, death.date) as Rolling_vaccination_sum
from vaccine join death 
on vaccine.location = death.location and vaccine.date = death.date where death.continent is
not null and death.location = 'India'
--order by 1,2,3
)
select *, (Rolling_Vaccination_sum/population)*100 as Percentage_Vaccinated from Percentjabbed



-- Doing the same effect using TEMP TABLE

drop table if exists #Percent_Vaccination_Done 
create table #Percent_Vaccination_Done
( location nvarchar(250),
 continent nvarchar(250), date datetime, Population numeric, New_caccinations numeric, RollingVaccinationSum numeric ) 

insert into #Percent_Vaccination_Done 
select death.location, death.continent, death.date, death.population, vaccine.new_vaccinations
, sum(convert(int, vaccine.new_vaccinations)) over (partition by death.location order by death.location, death.date) as Rolling_vaccination_sum
from vaccine join death 
on vaccine.location = death.location and vaccine.date = death.date where death.continent is
not null and death.location = 'India'
--order by 1,2,3


select *, (RollingVaccinationSum/population)*100 as Percentage_Vaccinated from #Percent_Vaccination_Done