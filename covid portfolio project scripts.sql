select * from PortfolioProject.coviddeaths
order by 3,4;

#select * from PortfolioProject.covidvaccinations
#-order by 3,4;
# select data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from coviddeaths
where continent is not null
order by 1,2;

# look at total cases vs total deaths
# shows likelihood of dying if you contract in your country
select location, date, total_cases, total_deaths, (total_deaths/coviddeaths.total_cases)*100 as deathPercentage
from coviddeaths
where continent is not null
# where location like 'Canada'
order by 1,2;

# looking at total cases vs Populations
# shows what percentage of population got covid
select location, date,population, total_cases, (coviddeaths.total_cases/coviddeaths.population)*100 as CasePercentage
from coviddeaths
where continent is not null
# where location like 'Canada'
order by 1,2;

# looking at countries with highest infection rate compare to population

set global sql_mode='';
SELECT any_value(location),
       date,
       population,
       max(total_cases) HighestInfectionCount,
       max((total_cases/population))*100 PercentPopulationInfected
from coviddeaths
where continent is not null
Group by any_value(location), any_value(population)
order by PercentPopulationInfected desc ;


# showing the countries with the highest death count population
SELECT any_value(location), max(total_deaths) TotalDeathCount
from coviddeaths
where continent is not null
Group by any_value(location)
order by TotalDeathCount desc ;

# let's break things down by continent
SELECT continent, max(total_deaths) TotalDeathCount
from coviddeaths
where continent is not null
Group by continent
order by TotalDeathCount desc ;

# Showing continents with highest death count per population
SELECT continent, max(total_deaths) TotalDeathCount
from coviddeaths
where continent is not null
Group by continent
order by TotalDeathCount desc ;

# global numbers
select
        sum(new_cases),
        sum(new_deaths),
        (sum(coviddeaths.new_deaths)/sum(coviddeaths.new_cases))*100 as deathPercentage
from coviddeaths
where continent is not null
# where location like 'Canada'
# group by date
order by 1,2;

# looking at total population vs vaccinations
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
       sum( vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date)
from PortfolioProject.coviddeaths dea
join PortfolioProject.covidvaccinations2 vac
    on dea.location =  vac.location
    and dea.date = vac.date
where dea.continent is not null
order by 1,2;

# use CTE

with PopvsVac (continent, location, Date, population, New_Vaccinations, RollingPeopleVaccinated)
as ( select dea.continent,dea.location, dea.date,dea.population, vac.new_vaccinations,
            sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
#     (RollingPeopleVaccinated/population)*100
from PortfolioProject.coviddeaths dea
join PortfolioProject.covidvaccinations2 vac
    on dea.location =  vac.location
    and dea.date = vac.date
where dea.continent is not null)
# order by 1,2
select *, (RollingPeopleVaccinated/population)*100 as VaccinatedRate
from PopvsVac;

# TEMP TABLE
create table PercentPopulationVaccinated
    (continent nvarchar(255),
    location nvarchar(255),
    date datetime,
    Population numeric,
    new_vaccinations numeric,
    RollingPeopleVaccinated numeric);
insert into PercentPopulationVaccinated
select dea.continent,dea.location, dea.date,dea.population, vac.new_vaccinations,
            sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
#     (RollingPeopleVaccinated/population)*100
from PortfolioProject.coviddeaths dea
join PortfolioProject.covidvaccinations2 vac
    on dea.location =  vac.location
    and dea.date = vac.date
where dea.continent is not null
select *, (RollingPeopleVaccinated/population)*100 as VaccinatedRate
from PercentPopulationVaccinated;

# creating view to store data for later visualizations

create view PercentPopulationVaccinated2 as
    select dea.continent,dea.location, dea.date,dea.population, vac.new_vaccinations,
            sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
#     (RollingPeopleVaccinated/population)*100
from PortfolioProject.coviddeaths dea
join PortfolioProject.covidvaccinations2 vac
    on dea.location =  vac.location
    and dea.date = vac.date
where dea.continent is not null;