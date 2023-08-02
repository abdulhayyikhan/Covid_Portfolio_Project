Select *
From [Covid Project]..CovidDeaths
Where continent is Not Null
Order By 3,4


Select location, date, total_cases, new_cases, total_deaths, population
From [Covid Project]..CovidDeaths
Where continent is Not Null
Order By 1,2


--Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Covid Project]..CovidDeaths
Where location like 'Pakistan'
and continent is Not Null
Order By 1,2


--Total Cases vs Population
--Shows what percentage of population got covid

Select location, date, total_cases, population, (total_cases/population)*100 as CasePercentage
From [Covid Project]..CovidDeaths
--Where location like 'Pakistan'
Where continent is Not Null
Order By 1,2


--Countries with highest infection rate compared to Population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as InfectedPopulationPercentage
From [Covid Project]..CovidDeaths
--Where location like 'Pakistan'
Where continent is Not Null
Group By location, population
Order By InfectedPopulationPercentage desc


--Countries with the highest death Count per Population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Covid Project]..CovidDeaths
--Where location like 'Pakistan'
Where continent is Not Null
Group By location
Order By TotalDeathCount desc


--Continents with the highest death Count per Population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Covid Project]..CovidDeaths
Where continent is Not Null
Group By continent
Order By TotalDeathCount desc


--Global Numbers

Select SUM(new_cases) As Total_Cases, SUM(cast(new_deaths As int)) As Total_Deaths,
SUM(cast(new_deaths As int))/SUM(new_cases)*100 as Death_Percentage
From [Covid Project]..CovidDeaths
where continent is Not Null
--Group By date
Order By 1,2


--Looking at Total Population vs Vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations)) Over (Partition By dea.location Order By dea.location, dea.date) as Rolling_People_Vaccinated
From [Covid Project]..CovidDeaths dea
Join [Covid Project]..CovidVaccinations vac
	On dea.location = vac.location
	And dea.date = vac.date
where dea.continent is Not Null
Order By 2,3


--USE CTE

With PopvsVac(continent, location, date, population, new_vaccinations, Rolling_People_Vaccinated)
As (
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations)) Over (Partition By dea.location Order By dea.location, dea.date) as Rolling_People_Vaccinated
From [Covid Project]..CovidDeaths dea
Join [Covid Project]..CovidVaccinations vac
	On dea.location = vac.location
	And dea.date = vac.date
where dea.continent is Not Null
--Order By 2,3
)
Select *, (Rolling_People_Vaccinated/population)*100
From PopvsVac


--Use Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rolling_People_Vaccinated numeric
)

Insert Into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations)) Over (Partition By dea.location Order By dea.location, dea.date) as Rolling_People_Vaccinated
From [Covid Project]..CovidDeaths dea
Join [Covid Project]..CovidVaccinations vac
	On dea.location = vac.location
	And dea.date = vac.date
--where dea.continent is Not Null
--Order By 2,3

Select *, (Rolling_People_Vaccinated/population)*100
From #PercentPopulationVaccinated


--Creating View to store Data for later visualization

--Drop View if exists PercentPopulationVaccinated
Create View PercentPopulationVaccinated As
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations)) Over (Partition By dea.location Order By dea.location, dea.date) as Rolling_People_Vaccinated
From [Covid Project]..CovidDeaths dea
Join [Covid Project]..CovidVaccinations vac
	On dea.location = vac.location
	And dea.date = vac.date
where dea.continent is Not Null
--Order By 2,3












































