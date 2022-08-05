# overview
=======================================================================

select
        sum(new_cases),
        sum(new_deaths),
        (sum(coviddeaths.new_deaths)/sum(coviddeaths.new_cases))*100 as deathPercentage
from coviddeaths
where continent is not null
GROUP BY date
order by 1,2;

Daily 
=======================================================================
# looking at total cases vs Populations
select location, date,population, total_cases, (coviddeaths.total_cases/coviddeaths.population)*100 as CasePercentage
from coviddeaths
order by 1,2;

# look at total cases vs total deaths
select location, date, total_cases, total_deaths, (total_deaths/coviddeaths.total_cases)*100 as deathPercentage
from coviddeaths
order by 1,2;

Ranking 
=======================================================================
select  location,
        sum(new_cases),
        sum(new_deaths),
        (sum(coviddeaths.new_deaths)/sum(coviddeaths.new_cases))*100 as deathPercentage
from coviddeaths
where continent is not null
GROUP BY location
order by deathPercentage desc;

Vaccination
=======================================================================
# global numbers - vaccination
select  location,
        sum(new_vaccinations)
from covidvaccinations2
GROUP BY location
order by location;

# global numbers - vaccination - top 20
select  location,
        sum(new_vaccinations)
from covidvaccinations2
GROUP BY location
order by sum(new_vaccinations) desc
limit 20;

