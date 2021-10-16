-- Menggunakan dataset yang didownload pada tanggal 16 Oktober 2021

-- 1. Total kasus vs Total kematian di Indonesia
SELECT	Location, 
		date, 
		total_cases,
		total_deaths, 
		(total_deaths/total_cases)*100 as DeathPercentage
FROM	CovidDeaths
WHERE	location ='Indonesia' and continent is not null 
ORDER BY 1,2

-- 2. Melihat total kasus vs populasi
-- Melihat persentase dari suatu populasi yang terkena COVID
SELECT	Location, 
		date, 
		Population, 
		total_cases,  
		(total_cases/population)*100 AS PercentagePopulationInfected
FROM	CovidDeaths
ORDER BY 1,2

-- 3. Negara dengan tingkat infeksi tertinggi dibandingkan dengan populasinya
SELECT	Location, 
		Population, MAX(total_cases) AS HighestInfectedCount,  
		MAX((total_cases/population))*100 AS PercentagePopulationInfected
From	CovidDeaths
GROUP BY location, Population
ORDER BY PercentagePopulationInfected DESC

-- 4. Kontinen dengan jumlah tingkat kematian tertinggi per populasi
SELECT	continent, 
		MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM	CovidDeaths
WHERE	continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

-- 5. Global Numbers
SELECT	SUM(new_cases) as TotalCases, 
		SUM(cast(new_deaths as int)) as TotalDeaths, 
		SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM	CovidDeaths
WHERE	continent is not null 
ORDER BY 1,2

-- 6. Total kasus, total kematian, dan persentase kematian COVID-19 di Indonesia
SELECT	SUM(new_cases) as TotalCases,
		SUM(CAST(new_deaths AS INT)) AS TotalDeaths,
		SUM(CAST(new_deaths AS INT))/SUM(new_cases) * 100 AS DeathPercentage
FROM	CovidDeaths
WHERE location = 'Indonesia'

-- 7. Total vaksin per tanggal dan persentase vaksin di Indonesia
SELECT	cd.location,
		cd.date,
		cd.population,
		cv.new_vaccinations,
		(new_vaccinations/population) * 100 AS VaccinationPercentage
FROM	CovidDeaths cd
JOIN	CovidVaccinations cv
ON		cd.location = cv.location
WHERE	cd.location = 'Indonesia'
GROUP BY cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations