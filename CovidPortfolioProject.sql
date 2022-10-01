Select *
from SQLPortfoliaProject..Coviddeaths
order by 3,4

Select *
from SQLPortfoliaProject..Coviddeaths
Where continent is not null
order by 3,4

--Select *
--from SQLPortfoliaProject..Covidvacine
--order by 3,4

Select location, date, population, total_cases, new_cases, total_deaths
from SQLPortfoliaProject..Coviddeaths
Where continent is not null
order by 1,2


Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from SQLPortfoliaProject..Coviddeaths
Where continent is not null
order by 1,2


Select location, date, total_cases, population, (total_cases/population)*100 as PopulationPercentage
from SQLPortfoliaProject..Coviddeaths
Where continent is not null
order by 1,2

Select Location, population, Max(total_cases) as HighestInfected, Max((total_cases/population))*100 as PopulationPercentageInfected
From SQLPortfoliaProject..Coviddeaths
Where continent is not null
Group by location, population
order by PopulationPercentageInfected desc

Select Location, Max(total_deaths) as TotalDeathsCount
From SQLPortfoliaProject..Coviddeaths
Where continent is not null
Group by location
order by TotalDeathsCount desc

Select continent, Max(total_deaths) as TotalDeathsCount
From SQLPortfoliaProject..Coviddeaths
Where continent is not null
Group by continent
order by TotalDeathsCount desc

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/Sum(New_Cases)*100 as PopulationPercentage
From SQLPortfoliaProject..Coviddeaths
Where continent is not null
Group by date
order by 1,2

Select  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/Sum(New_Cases)*100 as PopulationPercentage
From SQLPortfoliaProject..Coviddeaths
Where continent is not null
--Group by date
order by 1,2

Select *
from SQLPortfoliaProject..Coviddeaths dea
join SQLPortfoliaProject..Covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date

Select dea.continent, vac.location, vac.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
from  SQLPortfoliaProject..Coviddeaths dea
join SQLPortfoliaProject..Covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
order by 2,3


with popvsvac (continent, location, date, population, vaccinations, Rollingpeoplevaccinated ) 
as
(
Select dea.continent, vac.location, vac.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
from SQLPortfoliaProject..Coviddeaths dea
join SQLPortfoliaProject..Covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
select *, (Rollingpeoplevaccinated/population)*100 as percentagepopvac
from popvsvac 

Drop Table if  exists #percentagepopulationvaccinated 
create Table #percentagepopulationvaccinated 
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population NUMERIC,
New_vaccination NUMERIC,
Rollingpeoplevaccinated NUMERIC
)

Insert Into  #percentagepopulationvaccinated
Select dea.continent, vac.location, vac.date, dea.population, vac.new_vaccinations,
SUM(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
from SQLPortfoliaProject..Coviddeaths dea
join SQLPortfoliaProject..Covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
--Where dea.continent is not null
--order by 2,3
select *, (Rollingpeoplevaccinated/population)*100 as percentagepopvac
from #percentagepopulationvaccinated 

Create View percentagepopulationvaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
from SQLPortfoliaProject..Coviddeaths dea
join SQLPortfoliaProject..Covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
--order by 2,3


Select * 
from percentagepopulationvaccinated