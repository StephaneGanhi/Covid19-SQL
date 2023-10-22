# PortfolioProject

Introduction
This report presents a series of SQL queries used to analyze COVID-19 related data. The dataset includes information on COVID-19 cases, deaths, and vaccinations, with a focus on various countries and continents. The goal of these queries is to gain insights into the pandemic's impact on different regions and to track vaccination progress.

Data Sources
The data is extracted from two tables within the "PortfolioProject" database: CovidDeaths$ and CovidVaccinations$. These tables contain information on COVID-19 cases, deaths, and vaccinations across multiple locations and dates.

SQL Queries
1. Data Retrieval and Sorting
The initial queries retrieve data from the CovidDeaths$ table, ordering it by the third and fourth columns (location and date). The code follows the pattern:

sql
Copy code
SELECT *
FROM PortfolioProject..CovidDeaths$
ORDER BY 3, 4
2. Selecting Relevant Data
This step involves selecting specific columns (location, date, total_cases, total_deaths, and population) from the CovidDeaths$ table, further sorted by location and date. The data focuses on key metrics for analysis.

sql
Copy code
SELECT location, date, total_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths$
ORDER BY 1, 2
3. Analyzing Death Percentage
This query calculates the percentage of deaths relative to total cases for a specific location (e.g., Belgium). The code calculates the "DeathPercentage" by dividing the total deaths by total cases and multiplying by 100.

sql
Copy code
SELECT location, date, total_cases, total_deaths, CAST (total_deaths AS float) / total_cases * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths$
WHERE location like '%Belgium%'
ORDER BY 1, 2
4. Analyzing Cases Percentage
This query calculates the percentage of cases relative to the population for all locations, providing insight into the impact of COVID-19 on different countries and regions.

sql
Copy code
SELECT location, date, total_cases, Population, CAST(total_cases as float) / population * 100 AS CasesPercentage
FROM PortfolioProject..CovidDeaths$
ORDER BY 1, 2
5. Countries with Highest Infection Rate
This query identifies countries with the highest infection rates compared to their populations. It calculates the "CasesPercentage" and sorts by the highest infection count.

sql
Copy code
SELECT location, Population, cast(max(total_cases) as float) as HighestInfection, CAST(max(total_cases) as float) / population * 100 AS CasesPercentage
FROM PortfolioProject..CovidDeaths$
GROUP BY location, population
ORDER BY HighestInfection desc
6. Countries with Highest Death Count per Population
This query focuses on countries with the highest death counts per population. It groups data by location and calculates the "TotalDeathCount."

sql
Copy code
SELECT location, cast(max(total_deaths) as float) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc
7. Analysis by Continent
These queries extend the analysis to the continent level, identifying continents with the highest death counts.

sql
Copy code
SELECT location, cast(max(total_deaths) as float) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc

SELECT continent, cast(max(total_deaths) as float) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc
8. Global Data Analysis
The final set of queries focuses on global data analysis, calculating total cases, total deaths, and death percentages. The results are grouped by date to visualize the progression of the pandemic over time.

sql
Copy code
SELECT date, SUM(CAST(new_cases as float)) AS total_cases, SUM(CAST(new_deaths as float)) AS total_deaths, SUM(cast(new_deaths as float))/ Sum(Cast(new_cases as float)) * 100 as DeathPercentage 
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
GROUP BY date 
ORDER BY 1, 2

SELECT SUM(CAST(new_cases as float)) AS total_cases, SUM(CAST(new_deaths as float)) AS total_deaths, SUM(cast(new_deaths as float))/ Sum(Cast(new_cases as float)) * 100 as DeathPercentage 
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
ORDER BY 1, 2

