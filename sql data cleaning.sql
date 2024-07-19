select * 
from layoffs;
CREATE table layoffs_staging
like layoffs;
select * 
from layoffs_staging;

select * 
from layoffs_staging;

INSERT layoffs_staging;
SELECT *, 
row_number () OVER (PARTITION BY COMPANY, LOCATION, INDUSTRY, TOTAL_LAID_OFF, PERCENTAGE_LAID_OFF,`DATE`) 
AS ROW_NUM
FROM layoffs_staging;
WITH duplicate_cte as 
(SELECT *, 
row_number () OVER (PARTITION BY COMPANY, LOCATION, INDUSTRY, TOTAL_LAID_OFF, 
PERCENTAGE_LAID_OFF,`DATE`, stage, country, funds_raised_millions) 
AS ROW_NUM
FROM layoffs_staging
)
delete 
from duplicate_cte
where row_num > 1;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;
INSERT INTO layoffs_staging2
SELECT *, 
row_number () OVER (PARTITION BY COMPANY, LOCATION, INDUSTRY, TOTAL_LAID_OFF, 
PERCENTAGE_LAID_OFF,`DATE`, stage, country, funds_raised_millions) 
AS ROW_NUM
FROM layoffs_staging;
delete 
from layoffs_staging2
where row_num > 1;
select *
from layoffs_staging2;

select company, trim(company)
from layoffs_staging2;

UPDATE layoffs_staging2
set company = trim(company);

select distinct industry
from layoffs_staging2;

update layoffs_staging2
set industry = 'Crypto'
where industry like 'crypto%';

SELECT distinct country, trim(trailing '.' from country)
FROM layoffs_staging2
ORDER BY 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'united states%';



select `date` from layoffs_staging2;

update layoffs_staging2
set `date`=str_to_date(`date`, '%m/%d/%Y');
ALTER TABLE layoffs_staging2
MODIFY COLUMN `DATE` DATE;

SELECT *
FROM layoffs_staging2;

delete 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_staging2
WHERE industry IS NULL
OR INDUSTRY = '' ;
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT* 
FROM layoffs_staging2
WHERE COMPANY = 'AIRBNB';

SELECT* 
FROM layoffs_staging2;

JOIN layoffs_staging2 T2
      ON T1.company = T2.company
 where (t1.industry IS NULL OR t1.industry ='')
 and t2.industry is not null;


update layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null 
and t2.industry is not null;



alter table layoffs_staging2
drop column row_num;




