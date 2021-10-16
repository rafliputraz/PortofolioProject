-- 1
SELECT	SUM(new_cases) AS total_cases, 
		SUM(CAST(new_deaths AS INT)) as total_deaths, 
		SUM(CAST(new_deaths AS INT))/SUM(New_Cases)*100 AS DeathPercentage
FROM	CovidDeaths
WHERE	continent is not null 
ORDER BY 1,2

-- 2
SELECT	location, 
		SUM(CAST(new_deaths AS INT)) AS TotalDeathCount
FROM	CovidDeaths
WHERE	continent is null AND location not in ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC

-- 3
Select	Location, 
		Population, MAX(total_cases) AS HighestInfectionCount,  
		MAX((total_cases/population))*100 AS PercentPopulationInfected
From	CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC

-- 4
Select	Location, 
		Population,
		date, 
		MAX(total_cases) AS HighestInfectionCount,  
		MAX((total_cases/population))*100 AS PercentPopulationInfected
From	CovidDeaths
GROUP BY Location, Population, date
ORDER BY PercentPopulationInfected DESC