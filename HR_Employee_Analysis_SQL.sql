-- HR EMPLOYEE DATA ANALYSIS
-- SQL Queries

USE hr;


-- 1. Gender Breakdown
SELECT gender, COUNT(*) AS count
FROM hr
WHERE age >= 18
GROUP BY gender;


-- 2. Race/Ethnicity Breakdown
SELECT race, COUNT(*) AS count
FROM hr
WHERE age >= 18
GROUP BY race
ORDER BY count DESC;


-- 3. Age Distribution
SELECT
    CASE
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS age_group,
    COUNT(*) AS count
FROM hr
WHERE age >= 18
GROUP BY age_group;


-- 4. Employee Distribution by State
SELECT location_state, COUNT(*) AS count
FROM hr
WHERE age >= 18
  AND (termdate IS NULL OR termdate > CURDATE())
GROUP BY location_state
ORDER BY count DESC;


-- 5. Employee Hiring & Termination Trend
SELECT
    year,
    hires,
    terminations,
    hires - terminations AS net_change,
    ROUND(((hires - terminations) / hires) * 100, 2)
        AS net_change_percent
FROM (
    SELECT
        YEAR(hire_date) AS year,
        COUNT(*) AS hires,
        SUM(
            CASE
                WHEN termdate IS NOT NULL
                     AND termdate <= CURDATE()
                THEN 1
                ELSE 0
            END
        ) AS terminations
    FROM hr
    WHERE age >= 18
    GROUP BY YEAR(hire_date)
) AS subquery;