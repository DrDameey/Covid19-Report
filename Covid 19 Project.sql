--SELECTING DATA NEEDED FOR ANALYSIS
Select*
From PortfolioProject..CovidDeaths
Where continent is not null
And continent like '%Africa%'
Order By 3,4

Select*
From PortfolioProject..CovidVaccinations
Where continent is not null
And continent like '%Africa%'
Order By 3,4

------------------------------------------------
--TOTAL CASES VS TOTAL DEATHS
Select location, date, total_cases, total_deaths, total_deaths/total_cases * 100 AS DeathPercentage
From PortfolioProject..CovidDeaths
Where Continent is not null
and Location like '%Nigeria%'


------------------------------------------------
-- TOTAL CASES VS POPULATION IN NIGERIA
Select Continent, Location, population, Max (total_cases) as MaxTotalCases
, Max(total_cases/population) * 100 AS PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where continent is not null
and location like '%Nigeria%'
Group By Continent, Location, population


------------------------------------------------
-- HIGHEST INFECTION RATES CHECKED AGAINST POPULATION IN AFRICA
Select Continent, Location, population, MAX(total_cases) as HighestInfectionCount
, MAX((total_cases/population)) * 100 AS PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where continent is not null
And Continent like '%Africa%'
Group By Continent, Location, Population
Order By PercentPopulationInfected desc

-------------------------------------------------
-- HIGHEST DEATH COUNTS CHECKED AGAINST POPULATION IN AFRICA
Select Location, population, MAX(Cast(total_deaths as int)) as TotalDeathCount
, MAX(Cast(total_deaths as int))/population * 100 as PercentageTotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
And continent like '%Africa%'
Group By Location, population
Order By TotalDeathCount desc


-------------------------------------------------
--THE NUMBER OF VACCINES RECEIVED IN EACH COUNTRY
Select dea.continent, dea.location, dea.population
,Sum(Cast(vac.new_vaccinations as int)) as SumNewVaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	And dea.date = vac.date
Where dea.continent is not null
and dea.continent Like '%Africa%'
Group By dea.continent, dea.location, dea.population
Order By SumNewVaccinations desc


--------------------------------------------------
-- COMPARING THE TOTAL POPULATION AGAINST THE NUMBER OF PEOPLE VACCINATED IN EACH COUNTRY
With PopVsVac (location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(Cast (vac.new_vaccinations as int)) Over (Partition By dea.location order by dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	And dea.date = vac.date
Where dea.location Like '%Nigeria%'
and dea.continent is not null
--Order By 2,3
)

Select *, (RollingPeopleVaccinated/population)*100 as PercentageRollingPeopleVaccinated
From PopVsVac

