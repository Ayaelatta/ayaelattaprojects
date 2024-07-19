SELECT *
FROM layoffs_staging2;
SELECT max(total_laid_off)
FROM layoffs_staging2;
SELECT *
FROM layoffs_staging2
WHERE total_laid_off >= 12000;
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT company, sum(total_laid_off)
FROM layoffs_staging2
group by company
order by 2 desc;

SELECT MIN(`DATE`), MAX(`DATE`)
FROM layoffs_staging2;


select industry, sum(total_laid_off)
FROM layoffs_staging2
group by industry
order by 2 desc;


select country, sum(total_laid_off)
FROM layoffs_staging2
group by country
order by 2 desc;

select year(`date`), sum(total_laid_off)
FROM layoffs_staging2
group by YEAR(`date`)
order by 1 desc;

select stage, sum(total_laid_off)
FROM layoffs_staging2
group by stage
order by 1 desc;

select substring(`date`,1,7) as `MONTH`, sum(total_laid_off)
FROM layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
group by `MONTH`
order by 1 ASC;

WITH ROLLING_TOTAL AS 
( select substring(`date`,1,7) as `MONTH`, sum(total_laid_off) as total_off
FROM layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
group by `MONTH`
order by 1 ASC
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `month`) as rolling_total
from rolling_total;

SELECT company,YEAR(`date`), sum(total_laid_off)
FROM layoffs_staging2
group by company, YEAR(`date`)
order by 3 desc;

WITH company_year (company, years, total_laid_off) as 
(
SELECT company,YEAR(`date`), sum(total_laid_off)
FROM layoffs_staging2
group by company, YEAR(`date`)
), company_year_rank AS
(SELECT*,
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off desc) as ranking
FROM company_year
where years is not null
)
SELECT * 
from company_year_rank
where ranking <=5;

