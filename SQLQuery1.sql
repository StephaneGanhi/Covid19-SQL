SELECT *
FROM PortfolioProject.. CovidDeaths$
ORDER BY 3, 4

--SELECT *
--FROM PortfolioProject.. CovidVaccinations$
--ORDER BY 3, 4

-- Select data that we are going to be using

SELECT location, date, total_cases, total_deaths, population
FROM PortfolioProject.. CovidDeaths$
ORDER BY 1, 2

-- Looking at the total_cases vs total_deaths
-- Shows likelihood of dying if you contact kcovid in your country 
SELECT location, date, total_cases, total_deaths, CAST (total_deaths AS float) / total_cases * 100 AS DeathPercentage
FROM PortfolioProject.. CovidDeaths$
where location like '%Belgium%'
ORDER BY 1, 2


-- Looking at Total_Cases vs Population
-- Shows what percentage of population got covid

SELECT location, date, total_cases, Population, CAST(total_cases as float) / population * 100 AS CasesPercentage
FROM PortfolioProject.. CovidDeaths$
--where location like '%Belgium%'
ORDER BY 1, 2

--Looking at countries with highest infection rate compare to the population

SELECT location,Population,cast(max(total_cases) as float) as HighestInfection, CAST(max(total_cases)as float) / population * 100 AS CasesPercentage
FROM PortfolioProject.. CovidDeaths$
--where location like '%Belgium%'
GROUP BY location, population
ORDER BY HighestInfection desc

-- Showing countries with Highest Death Count per population

SELECT location, cast(max(total_deaths) as float) as TotalDeathCount
FROM PortfolioProject.. CovidDeaths$
--where location like '%Belgium%'
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc

-- let's break things down by continent

SELECT location, cast(max(total_deaths) as float) as TotalDeathCount
FROM PortfolioProject.. CovidDeaths$
--where location like '%Belgium%'
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc

-- Showing the continent with the HighestDeathCount

SELECT continent, cast(max(total_deaths) as float) as TotalDeathCount
FROM PortfolioProject.. CovidDeaths$
--where location like '%Belgium%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc


-- Global Numbers 
SELECT date, SUM(CAST(new_cases as float)) AS total_cases, SUM(Cast(new_deaths as float)) AS total_deaths, SUM(cast(new_deaths as float))/ Sum(Cast(new_cases as float)) * 100 as DeathPercentage 
FROM PortfolioProject.. CovidDeaths$
--where location like '%Belgium%'
WHERE continent is not null
GROUP BY date 
ORDER BY 1, 2

SELECT SUM(CAST(new_cases as float)) AS total_cases, SUM(Cast(new_deaths as float)) AS total_deaths, SUM(cast(new_deaths as float))/ Sum(Cast(new_cases as float)) * 100 as DeathPercentage 
FROM PortfolioProject.. CovidDeaths$
--where location like '%Belgium%'
WHERE continent is not null
--GROUP BY date 
ORDER BY 1, 2

-- Looking at Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(cast(vac.new_vaccinations as float)) over (Partition by dea.Location order by dea.location,
  dea.date) as RollingPeopleVaccinated
 -- , (RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2, 3

-- Use CTE 

with PopvsVac (continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(cast(vac.new_vaccinations as float)) over (Partition by dea.Location order by dea.location,
  dea.date) as RollingPeopleVaccinated
 -- , (RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2, 3
)
select *, CAST(RollingPeopleVaccinated as float)/Population * 100
from PopvsVac


-- TEMP TABLE
Drop table if exists #PercentPopulationVaccinated

Create table  #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(cast(vac.new_vaccinations as float)) over (Partition by dea.Location order by dea.location,
  dea.date) as RollingPeopleVaccinated
 -- , (RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2, 3

select *, CAST(RollingPeopleVaccinated as float)/Population * 100
from #PercentPopulationVaccinated


-- Creating views to store data for later visualisation

create view PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(cast(vac.new_vaccinations as float)) over (Partition by dea.Location order by dea.location,
  dea.date) as RollingPeopleVaccinated
 -- , (RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2, 3



select * 
from PercentPopulationVaccinated










