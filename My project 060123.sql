use project
select * from COVIDDEATH

SELECT * FROM COVIDDEATH
ORDER BY 3,4

---Select Data that we are going to be using.

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM COVIDDEATH
ORDER BY 1,2

---looking at total Cases Vs total Deaths 
---in percentage
--- adding conditon 

SELECT location,date,total_cases,total_deaths,
(total_deaths/total_cases)*100 as "Death Percentage"
FROM COVIDDEATH
where location like '%india%' and total_deaths is not null
ORDER BY 1,2


---Looking at Total cases Vs Populations
---with percentage 
---with another conditions 

SELECT location,date,total_cases,population,
(total_cases/population)*100 as "Death Percentage"
FROM COVIDDEATH
---where location like '%india%' and total_cases>1000000
ORDER BY 1,2


---looking at the country rate with the highst infaction rate


SELECT location,population,max(total_cases)as Highest_Infaction_Count,
max(total_cases/population)*100 as Percent_population_Infacted
FROM COVIDDEATH
where population is not null
group by location,population,date
ORDER BY Percent_population_Infacted desc


---showing countries with highest death count per population
---(remove null contnents )

select location, count(location) as Count_loc,max(cast(total_deaths as int)) as Death_Count from COVIDDEATH
where continent is not null
group by location
order by Death_Count desc


---lets break things down by continent


select location,max(cast(total_deaths as int)) as Death_Count from COVIDDEATH
where continent is null
group by location
order by Death_Count desc


---Showing continents with the highest death count per populations

select continent,max(cast(total_deaths as int)) as Death_Count from COVIDDEATH
where continent is not null
group by continent
order by Death_Count desc


--- global 

select date,sum(new_cases)as Total_Cases,sum(cast(new_deaths as int))as Total_Deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as In_Percentage
from COVIDDEATH
where continent is not null
group by date
order by 1,2

---Global counts

select sum(new_cases)as Total_Cases,sum(cast(new_deaths as int))as Total_Deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as In_Percentage
from COVIDDEATH
where continent is not null
order by 1,2


-------------Join----------
---Looking total population vs vaccination 


select dea.continent,dea.location,dea.date,dea.population,vcc.new_vaccinations,
sum(convert(int,vcc.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.Date)as  Rolling_Peoples_Vcc
---,(Rolling_Peopoles_Vcc/dea.population)*100
from COVIDDEATH as dea join COVIDVACCINATION as vcc
	on dea.location = vcc.location
	and dea.date = vcc.date
	where dea.continent is not null
order by 2,3


with popvsvcc(continent,location,date,population,new_vaccinations,Rolling_Peoples_Vcc) as
(
select dea.continent,dea.location,dea.date,dea.population,vcc.new_vaccinations,
sum(convert(int,vcc.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.Date)as  Rolling_Peoples_Vcc
---,(Rolling_Peopoles_Vcc/dea.population)*100
from COVIDDEATH as dea join COVIDVACCINATION as vcc
	on dea.location = vcc.location
	and dea.date = vcc.date
	where dea.continent is not null
---order by 2,3
)

select * from popvsvcc



--- temp table
drop table if exists #percentpopulationvccinated
create table #percentpopulationvccinated
(continent nvarchar(255),
location nvarchar(255),
Date Datetime,
Population numeric,
New_vaccinated numeric,
Rolling_Peoples_Vcc numeric
)

insert into #percentpopulationvccinated
select dea.continent,dea.location,dea.date,dea.population,vcc.new_vaccinations,
sum(convert(int,vcc.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.Date)as  Rolling_Peoples_Vcc
---,(Rolling_Peopoles_Vcc/dea.population)*100
from COVIDDEATH as dea join COVIDVACCINATION as vcc
	on dea.location = vcc.location
	and dea.date = vcc.date
---where dea.continent is not null
---order by 2,3


select * from #percentpopulationvccinated

---creating view to sotre data for visualizations 

create view percentpopulationvccinated as
select dea.continent,dea.location,dea.date,dea.population,vcc.new_vaccinations,
sum(convert(int,vcc.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.Date)as  Rolling_Peoples_Vcc
---,(Rolling_Peopoles_Vcc/dea.population)*100
from COVIDDEATH as dea join COVIDVACCINATION as vcc
	on dea.location = vcc.location
	and dea.date = vcc.date
where dea.continent is not null
---order by 2,3


select * from percentpopulationvccinated


select location, sum(cast(new_deaths as int)) as Total_Death_Count
from COVIDDEATH 
where continent is null and location not in ('world','Europen Union','International')
group by location 
order by Total_Death_Count desc



SELECT location,population,date,max(total_cases)as Highest_Infaction_Count,
max(total_cases/population)*100 as Percent_population_Infacted
FROM COVIDDEATH
---where population is not null
group by location,population,date
ORDER BY Percent_population_Infacted desc