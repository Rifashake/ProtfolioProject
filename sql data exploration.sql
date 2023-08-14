

SELECT * from project1..COVIDDEATHS
select iso_code,continent,location,date,population from project1..COVIDDEATHS ORDER BY 3,4
--SELECT * FROM dbo.COVIDVACCINATION ORDER BY 3,4



--SELECT DATA THAT WE ARE GOING TO BE USING


select location,date,total_cases,new_cases,total_deaths,population from project1..COVIDDEATHS order by 1,2

--Looking at Total Cases vs Total Deaths

alter table dbo.COVIDDEATHS alter column total_cases float
alter table dbo.COVIDDEATHS alter column total_deaths float

select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from project1..COVIDDEATHS 
where location like '%states%'
order by 1,2

--Looking at total cases vs population
--shows what percentage of population affected by covid

select location,date,total_cases,population,(total_cases/population)*100 as percentageofpopulationinfected
from project1..COVIDDEATHS 
where location like '%states%'
order by 1,2

--Looking at countries with highest infection rate compared to population

select location,population, MAX(total_cases) as HighestInfectionCount, 
MAX((total_cases/population))*100 as percentofpopulationinfected
from project1..COVIDDEATHS 
group by location,population
order by percentofpopulationinfected desc



--Showing countries with highest death count per population


select location, MAX(total_deaths) as totaldeathCount
from  project1..COVIDDEATHS 
where continent is not null
group by location
order by  totaldeathCount desc


--LET'S BREAK THINGS DOWN BY CONTINENT



--select continent, MAX(total_deaths) as totaldeathCount
--from dbo.COVIDDEATHS 
--where continent is not null
--group by continent
--order by  totaldeathCount desc


--showing continents with highest death count per population


select continent, MAX(total_deaths) as totaldeathCount
from project1..COVIDDEATHS 
where continent is not null
group by continent
order by  totaldeathCount desc

--GLOBAL NUMBERS

select SUM(new_cases) as total_cases,SUM(new_deaths) as total_deaths,SUM(new_deaths)/SUM(new_cases)*100 as deathpercentage
from project1..COVIDDEATHS 
where continent is not null
--group by date
order by 1,2


--Looking at  Total Population vs Vaccinatons

select death.continent,death.location,death.date,death.population,vacc.new_vaccinations,
sum(CONVERT(int,vacc.new_vaccinations)) over (partition by death.location order by death.location,death.date)
from project1..COVIDDEATHS death
join  project1..COVIDVACCINATION vacc
ON death.location = vacc.location
and death.date = vacc.date
where death.continent is not null
order by 2,3


--USE CTE

With popvsvac (continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as
(
select death.continent,death.location,death.date,death.population,vacc.new_vaccinations,
sum(CONVERT(int,vacc.new_vaccinations)) over (partition by death.location order by death.location,death.date) as rollingpeoplevaccinated
from project1..COVIDDEATHS death
join  project1..COVIDVACCINATION vacc
ON death.location = vacc.location
and death.date = vacc.date
where death.continent is not null
)
select *,(rollingpeoplevaccinated/population)*100
from popvsvac



--TEMPORARY TABLE

create table percentageofpopulationvaccinatedss
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into percentageofpopulationvaccinatedss

select death.continent,death.location,death.date,death.population,vacc.new_vaccinations,
sum(cast(vacc.new_vaccinations as bigint)) over (partition by death.location order by death.location,death.date) as rollingpeoplevaccinated
from project1..COVIDDEATHS death
join  project1..COVIDVACCINATION vacc
ON death.location = vacc.location
and death.date = vacc.date
where death.continent is not null

select *,(rollingpeoplevaccinated/population)*100
from percentageofpopulationvaccinatedss


--CREATING VIEW TO STORE DATA FOR VISUALISATION


create View percentpopulationvaccinatedS as
select death.continent,death.location,death.date,death.population,vacc.new_vaccinations,
sum(cast(vacc.new_vaccinations as bigint)) over (partition by death.location order by death.location,death.date) as rollingpeoplevaccinated
from project1..COVIDDEATHS death
join  project1..COVIDVACCINATION vacc
ON death.location = vacc.location
and death.date = vacc.date
where death.continent is not null

SELECT * from percentpopulationvaccinatedS