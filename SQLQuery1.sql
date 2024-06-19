
select * from  projecta..CovidDeaths
order by 3,4
select * from  projecta..CovidVaccinations
order by 3,4


select  location, date, total_cases, new_cases, total_deaths, population
from projecta..CovidDeaths
order by 1,2


--looking at total cases vs total deaths 

--death likehood 
select  location, date, total_cases, total_deaths,((total_deaths/total_cases)*100)as Death_Percentage
from projecta..CovidDeaths
where location like 'Iraq%'
order by 1,2

--looking total cases VS Population 


select  location, date, total_cases,population,((total_cases/population)*100)as 'effected_people%'
from projecta..CovidDeaths
where location like 'Iraq%' 
order by 1,2


-- finding highest infection rate country compared to population 


select  location, population, max(total_cases) as highest_infection_count,max(((total_cases/population)*100))as percentage_population_infected
from projecta..CovidDeaths
where continent is not null 
group by location, population
order by  percentage_population_infected desc

--showing highest death count per population 

select location,max(cast (total_deaths as int)) as total_death_count --error with the data type 
from projecta..CovidDeaths
where continent is not null 
group by location
order by total_death_count desc

--showing highest death count per population by continent 

select location,max(cast (total_deaths as int)) as total_death_count --error with the data type 
from projecta..CovidDeaths
where continent is  null 
group by location
order by total_death_count desc

--global numbers 

select date,sum(new_cases) as total_cases ,sum(cast (new_deaths as int)) as tota_deaths,sum(cast (new_deaths as int))/sum(new_cases)*100  as total_death_count --error with the data type 
from projecta..CovidDeaths
where continent is not  null 
group by date
order by 1,2 

-- total cases in the world 

select sum(new_cases) as total_cases ,sum(cast (new_deaths as int)) as tota_deaths,sum(cast (new_deaths as int))/sum(new_cases)*100  as total_death_count --error with the data type 
from projecta..CovidDeaths
where continent is not  null 
--group by date
order by 1,2 


 --now it's time for the secodn table we gonna join them together to looking 
 select * from projecta..CovidDeaths dea
 join projecta..CovidVaccinations vac
 on dea.location = vac.location
	and dea.date= vac.date

	-- looking at total population vs vaccination 
	with PopvsVac  (Continent ,Location , Date ,new_vaccinations ,Population, RollingPeopleVaccinated)
	as (
	select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations , SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location,dea.date) as RollingPeopleVaccinated
	from projecta..CovidDeaths dea
 join projecta..CovidVaccinations vac
 on dea.location = vac.location
 where dea.continent is not null
	and dea.date= vac.date)
	--order by 2,3 write last  querry 
	select * from PopvsVac



	

	-- temp table 
	create table #PercentPopulationVaccinated
	(
	Continet nvarchar (255),
	Location nvarchar(255),
	Date datetime ,
	Population numeric , 
	New_vaccination numeric,
RollingPeopleVaccinated numeric)

insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations , SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location,dea.date) as RollingPeopleVaccinated
	from projecta..CovidDeaths dea
 join projecta..CovidVaccinations vac
 on dea.location = vac.location
 where dea.continent is not null
	and dea.date= vac.date
	--order by 2,3 write last  querry 
	select * , (RollingPeopleVaccinated/Population)*100
	from #PercentPopulationVaccinated


	-- create a view 

	create view PercentPopulationVaccinated as
	select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations , SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location,dea.date) as RollingPeopleVaccinated
	from projecta..CovidDeaths dea
 join projecta..CovidVaccinations vac
 on dea.location = vac.location
 where dea.continent is not null
	and dea.date= vac.date
	--order by 2,3 write last  querry
	