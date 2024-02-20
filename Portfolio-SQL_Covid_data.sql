/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

Select * 
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 3,4


-- Select Data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2

-- Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid in the States

Select location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
and continent is not null
order by 1,2

-- Total Cases vs Population
-- Shows what percentage of Population infected with Covid 

Select location, date, total_cases, Population, (cast(total_cases as float)/cast(Population as float))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
order by 1,2


-- Countries with highest Infection Rate compared to Population

Select location, Population, MAX(cast(total_cases as int)) as HighestInfectionCount, (Max(total_cases)/Population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by location, population
Order by PercentPopulationInfected desc

-- Countries with highest Death Count per Population

Select location, Population, MAX(cast(total_deaths as float)) as TotalDeathCount, (Max(cast(total_deaths as float))/Population)*100 as PercentagePopulationDeath
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by location, population
Order by PercentagePopulationDeath desc

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(total_deaths as float)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc

-- Global Death percentage


Select  SUM(new_cases) as total_cases, SUM(cast(new_deaths as float)) as TotalDeathCount, SUM(cast(new_deaths as float))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
--Group by date
Order by 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations
, SUM(Convert(float, vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.date) 
as TotalVaccination
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3

-- Using CTE to perform Calculation on Partition By in previous query

With PopVsVac (continent, location, date, population, new_vaccinations, TotalVaccination)
as
(
Select dea.continent, dea.location, dea.date, population, new_vaccinations
, SUM(Convert(float, vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.date) 
as TotalVaccination
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select *, (TotalVaccination/population)*100 as VaccinatedPercentage
From PopVsVac
order by 2,3


-- Using Temp Table to perform Calculation on Partition By in previous query

Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
TotalVaccination numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, population, new_vaccinations
, SUM(Convert(float, vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.date) 
as TotalVaccination
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is not null
--order by 2,3

Select *, (TotalVaccination/population) * 100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create view PercentPopulationVaccine as
Select dea.continent, dea.location, dea.date, population, new_vaccinations
, SUM(Convert(float, vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.date) 
as TotalVaccination
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
