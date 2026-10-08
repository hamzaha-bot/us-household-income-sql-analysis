-- US Household Income Data Cleaning

-- Inspect datasets
SELECT *
FROM us_project.us_household_income;

SELECT *
FROM us_project.us_household_income_statistics;


-- Fix malformed ID column name
ALTER TABLE us_project.us_household_income_statistics
RENAME COLUMN `ï»¿id` TO `id`;


-- Check for duplicate IDs
SELECT id, COUNT(id)
FROM us_project.us_household_income
GROUP BY id
HAVING COUNT(id) > 1;


-- Identify duplicate rows
SELECT *
FROM (
    SELECT
        row_id,
        id,
        ROW_NUMBER() OVER (
            PARTITION BY id
            ORDER BY row_id
        ) AS row_num
    FROM us_project.us_household_income
) duplicates
WHERE row_num > 1;


-- Remove duplicate rows
SET SQL_SAFE_UPDATES = 0;

DELETE FROM us_project.us_household_income
WHERE row_id IN (
    SELECT row_id
    FROM (
        SELECT
            row_id,
            id,
            ROW_NUMBER() OVER (
                PARTITION BY id
                ORDER BY row_id
            ) AS row_num
        FROM us_project.us_household_income
    ) duplicates
    WHERE row_num > 1
);

SET SQL_SAFE_UPDATES = 1;


-- Standardize state names
UPDATE us_project.us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

UPDATE us_project.us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';


-- Correct place name
UPDATE us_project.us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont';


-- Standardize location type
UPDATE us_project.us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs';


-- Land and water data-quality check
SELECT
    SUM(
        CASE
            WHEN ALand = 0 OR ALand = '' OR ALand IS NULL
            THEN 1 ELSE 0
        END
    ) AS Invalid_ALand,
    SUM(
        CASE
            WHEN AWater = 0 OR AWater = '' OR AWater IS NULL
            THEN 1 ELSE 0
        END
    ) AS Invalid_AWater
FROM us_project.us_household_income;