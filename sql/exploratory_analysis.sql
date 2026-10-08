-- US Household Income Exploratory Data Analysis


-- Top 10 states by total land area
SELECT
    State_Name,
    SUM(ALand) AS Total_Land,
    SUM(AWater) AS Total_Water
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY Total_Land DESC
LIMIT 10;


-- Top 10 states by total water area
SELECT
    State_Name,
    SUM(ALand) AS Total_Land,
    SUM(AWater) AS Total_Water
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY Total_Water DESC
LIMIT 10;


-- Top states by average household income
SELECT
    u.State_Name,
    ROUND(AVG(us.Mean), 1) AS Avg_Mean_Income,
    ROUND(AVG(us.Median), 1) AS Avg_Median_Income
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
    ON u.id = us.id
WHERE us.Mean <> 0
GROUP BY u.State_Name
ORDER BY Avg_Median_Income DESC
LIMIT 10;


-- Income by location type
SELECT
    u.Type,
    COUNT(u.Type) AS Location_Count,
    ROUND(AVG(us.Mean), 1) AS Avg_Mean_Income,
    ROUND(AVG(us.Median), 1) AS Avg_Median_Income
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
    ON u.id = us.id
WHERE us.Mean <> 0
GROUP BY u.Type
ORDER BY Location_Count DESC
LIMIT 10;


-- Income comparison for common location types
SELECT
    u.Type,
    COUNT(u.Type) AS Location_Count,
    ROUND(AVG(us.Mean), 1) AS Avg_Mean_Income,
    ROUND(AVG(us.Median), 1) AS Avg_Median_Income
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
    ON u.id = us.id
WHERE us.Mean <> 0
GROUP BY u.Type
HAVING COUNT(u.Type) > 100
ORDER BY Avg_Median_Income DESC
LIMIT 20;


-- Highest-income cities
SELECT
    u.State_Name,
    u.City,
    ROUND(AVG(us.Mean), 1) AS Avg_Mean_Income,
    ROUND(AVG(us.Median), 1) AS Avg_Median_Income
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
    ON u.id = us.id
GROUP BY u.State_Name, u.City
ORDER BY Avg_Mean_Income DESC;