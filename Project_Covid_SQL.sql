select * from coviddeaths order by 3,4;
Select * from covidvaccinations order by 3,4;
use portfolioproject;

Select location, date, total_cases, new_cases, total_deaths, population
from coviddeaths order by 1,2;

-- (Ques)Looking at Total_Cases vs Total_Deaths
Select location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100,4) as Death_percentage
from coviddeaths where location like '%states%' order by 1,2;

-- Looking at Total_cases vs Population
-- (ques)shows what percentage popualtion got covid
Select location, date,population, total_cases,
round((total_deaths/population)*100,4) as Death_percentage
from coviddeaths where location like '%states%' order by 1,2;

-- (Ques)Looking at countries with Highgest Infection Rate compared to population
Select location, population, max(total_cases)
as HighestInfectionCount, max(total_cases/population)*100 
as PercentPopulationinfected
from coviddeaths group by location, population order by PercentPopulationinfected desc;

-- (Ques)Showing country with highest Death Count per Population
Select location, max(total_deaths)
as HighestdeathsCount
from coviddeaths 
group by location order by HighestdeathsCount desc;

-- (Ques)Showing continent with highest Death_Count per Population
Select continent, max(total_deaths) 
as HighestdeathsCount
from coviddeaths 
group by continent order by HighestdeathsCount desc;

-- Global Numbers
SELECT
SUM(new_cases) As total_cases, sum(new_deaths) 
as total_deaths,
round((sum(new_deaths)/SUM(new_cases))*100,4) as DeathPercentage 
from coviddeaths;
-----------------------------------------------
Select * from covidvaccinations;
use portfolioproject;

-- Join coviddeaths and covidvaccinations
Select * from coviddeaths d 
join 
covidvaccinations v 
on 
d.location = v.location and d.date = v.date; 

-- Using Join
-- Looking at Total Population vs Vaccinations
Select d.continent, d.location, d.date, d.population, v.total_vaccinations
from coviddeaths d 
join covidvaccinations v
on d.location = v.location and d.date = v.date;

-- Innerjoin 
Select d.continent, d.location,  d.total_deaths from coviddeaths d 
inner join covidvaccinations v on d.location = v.location;

-- Calculate total vacinations according to population and date with location
Select d.continent, d.location, d.date, d.population, v.total_vaccinations,
sum(v.total_vaccinations) 
over (partition by d.location order by d.location, d.date) 
as RollingPeopleVaccinated
from coviddeaths d 
join covidvaccinations v
on d.location = v.location and d.date = v.date;

-- USING CTE
With PopvsVac ( continent, location, date, population, total_vaccinations, RollingPeopleVaccinated)
as
(
Select d.continent, d.location, d.date, d.population, v.total_vaccinations,
sum(v.total_vaccinations) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from coviddeaths d join covidvaccinations v
on d.location = v.location and d.date = v.date
)
Select *, ((RollingPeopleVaccinated/population)*100) as percentagePeopleVaccinated
from PopvsVac;
 
-- create view to store data for visualization
create view percentagePeopleVaccinated as
Select d.continent, d.location, d.date, d.population, v.total_vaccinations,
sum(v.total_vaccinations) over (partition by d.location order by d.location, d.date) 
   as RollingPeopleVaccinated
from coviddeaths d join covidvaccinations v
on d.location = v.location and d.date = v.date;






