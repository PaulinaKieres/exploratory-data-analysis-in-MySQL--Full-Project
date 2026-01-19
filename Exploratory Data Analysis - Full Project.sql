-- Exploratory Data Analysis

SELECT*
FROM layoffs_staging2
;

-- zaczniemy od łatwych rzeczy do eksploracji. Nie mamy żadnych wytycznych w tym temacie.

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2; -- w pewnym dniu jakaś firma zwolniła 12000 pracowników i było to 100% firmy. Jest to największe zwolnienie i zamknięcie firmy w tej bazie

SELECT *
FROM layoffs_staging2 -- które firmy/placówki zamknęły się całkowicie?
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off) -- które firmy miały najwięcej zwolnień w sumie?
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC; -- zamiast 2 możemy dać SUM(total_laid_off)

SELECT MIN(`date`), MAX(`date`)  -- w jakim okresie były te wszystkie zwolnienia?
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off) -- który przemysł miał w sumie najwięcej zwolnień?
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off) -- który kraj miał w sumie najwięcej zwolnień?
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off) -- którego roku w sumie było najwięcej zwolnień?
FROM layoffs_staging2
GROUP BY YEAR (`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off) -- w którym etapie w sumie było najwięcej zwolnień?
FROM layoffs_staging2
GROUP BY stage
ORDER BY 1 DESC;

-- troche trudniejsze dane

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) -- Ile było zwolnień w danym miesiącu w zakresie daty bazy danych?
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
;


WITH Rolling_Total AS -- Ile było zwolnień w danym miesiącu oraz suma krocząca?
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

-- Trudne
-- Top 5 firm które w danym roku zwolniła najwięcej ludzi?

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;
;

WITH Company_Year (company, years, total_laid_off) AS -- stworzyliśmy CTE
(SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS -- kolejne CTE z Rank
(SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT*
FROM Company_Year_Rank
Where Ranking <= 5
;

















