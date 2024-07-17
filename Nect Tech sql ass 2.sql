-- Create the database named 'llin_analysis'
CREATE DATABASE llin_analysis;

-- Select the 'llin_analysis' database for use
USE llin_analysis;

-- Create the table 'llin_distribution' with columns for each data field
CREATE TABLE llin_distribution (
    ID INT PRIMARY KEY,                     -- Unique identifier for each distribution record
    Number_distributed INT NOT NULL,        -- Number of LLINs distributed in this record
    Location VARCHAR(255) NOT NULL,         -- Specific location of distribution
    Country VARCHAR(255) NOT NULL,          -- Country where distribution took place
    When DATE NOT NULL,                     -- Date of distribution
    By_whom VARCHAR(255) NOT NULL,          -- Organization responsible for distribution
    Country_code CHAR(3) NOT NULL           -- ISO code of the country
);



-- Calculate the total number of LLINs distributed in each country
SELECT Country, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY Country;  -- Group the results by country to aggregate the total number of LLINs distributed per country

-- Calculate the average number of LLINs distributed per distribution event
SELECT AVG(Number_distributed) AS Average_LLINS_Distributed
FROM llin_distribution;  -- Use the AVG function to find the average number of LLINs distributed

-- Determine the earliest and latest distribution dates in the dataset
SELECT MIN(When) AS Earliest_Distribution, MAX(When) AS Latest_Distribution
FROM llin_distribution;  -- Use the MIN and MAX functions to find the earliest and latest dates respectively




-- Identify the total number of LLINs distributed by each organization
SELECT By_whom, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY By_whom;  -- Group by organization to sum the total number of LLINs distributed by each

-- Calculate the total number of LLINs distributed in each year
SELECT YEAR(When) AS Distribution_Year, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY YEAR(When);  -- Group by year to aggregate the total number of LLINs distributed each year





-- Find the location with the highest number of LLINs distributed
SELECT Location, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY Location  -- Group by location to sum the total number of LLINs distributed per location
ORDER BY Total_LLINS_Distributed DESC  -- Order by the total number of LLINs distributed in descending order
LIMIT 1;  -- Limit the result to the top location with the highest distribution

-- Find the location with the lowest number of LLINs distributed
SELECT Location, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY Location  -- Group by location to sum the total number of LLINs distributed per location
ORDER BY Total_LLINS_Distributed ASC  -- Order by the total number of LLINs distributed in ascending order
LIMIT 1;  -- Limit the result to the location with the lowest distribution

-- Determine if there's a significant difference in the number of LLINs distributed by different organizations
SELECT By_whom, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY By_whom  -- Group by organization to sum the total number of LLINs distributed by each
HAVING COUNT(ID) > 1;  -- Include only organizations with more than one distribution event




-- Identify outliers or significant spikes in the number of LLINs distributed
SELECT Location, When, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY Location, When  -- Group by location and date to sum the total number of LLINs distributed
HAVING Total_LLINS_Distributed > (SELECT AVG(Number_distributed) + 2 * STDDEV(Number_distributed) FROM llin_distribution);  -- Use a threshold to identify outliers, e.g., values more than 2 standard deviations above the average
