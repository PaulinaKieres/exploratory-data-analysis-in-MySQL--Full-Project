-- Exploratory Data Analysis Project (Junior)
-- This project is a continuation of the "Data Cleaning - Full Project.sql."
-- Link to data "layoffs_staging2.csv" from my google drive:
-- "https://drive.google.com/file/d/1NheK9y9lXI8gJP8pB3GCXqCY3TAhOwvs/view?usp=sharing"

SELECT*
FROM layoffs_staging2
;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2; -- This is the largest layoff and company closure in this database.

SELECT *
FROM layoffs_staging2 -- Which companies have closed completely?
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off) -- which companies had the most layoffs in total?
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)  -- What period were all these layoffs?
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off) -- Which industry had the most layoffs overall?
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off) -- which country had the most layoffs overall?
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off) -- which year had the most layoffs in total?
FROM layoffs_staging2
GROUP BY YEAR (`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off) -- in which stage were there the most layoffs in total?
FROM layoffs_staging2
GROUP BY stage
ORDER BY 1 DESC;

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) -- How many layoffs were there in a given month within the database date range?
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
;


WITH Rolling_Total AS -- How many layoffs were there in a given month? (rolling total)
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;



SELECT company, YEAR(`date`), SUM(total_laid_off) -- Top 5 companies that laid off the most people in a given year? I use CTE.
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;
;

WITH Company_Year (company, years, total_laid_off) AS
(SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT*
FROM Company_Year_Rank
Where Ranking <= 5
;
