-- EXPLORATORY DATA ANALYSIS

SELECT*
FROM layoffs_staging2;

SELECT max(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT*
FROm layoffs_staging2
WHERE percentage_laid_off=1
ORDER BY funds_raised_millions DESC;

SELECT company,sum(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- which Year did the layoffs take place?

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;


-- what industry was most hit during the covid years?

SELECT industry,sum(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- which country had the most layoffs?

SELECT country,sum(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

--  what was the sum layoffs per year?

SELECT year(`date`),sum(total_laid_off)
FROM layoffs_staging2
GROUP BY year(`date`)
ORDER BY 1 DESC;

-- what stages are the companies at the time of layoffs?
SELECT stage,sum(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- what is the progression of the layoffs?

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7)  IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;


WITH Rolling_total AS 
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) as total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7)  IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_total;


SELECT company, year(`date`),sum(total_laid_off)
FROM layoffs_staging2
GROUP BY company,year(`date`)
ORDER BY company ASC;


SELECT company, year(`date`),sum(total_laid_off)
FROM layoffs_staging2
GROUP BY company,year(`date`)
ORDER BY 3 DESC;

WITH Company_year (company,years,total_laid_off) as 
(
SELECT company, year(`date`),sum(total_laid_off)
FROM layoffs_staging2
GROUP BY company,year(`date`)
)
SELECT*
FROM Company_year;

-- which company laid off most people per year?

WITH Company_year (company,years,total_laid_off) as 
(
SELECT company, year(`date`),sum(total_laid_off)
FROM layoffs_staging2
GROUP BY company,year(`date`)
), Company_year_Rank AS
(
SELECT*, DENSE_RANK() OVER( PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM company_year
WHERE years IS NOT NULL
)
SELECT*
FROM company_year_Rank
WHERE Ranking<=5;


