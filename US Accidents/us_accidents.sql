
SELECT * FROM us_accidents_march23;

-- Counting the number of accidents by the severity--
SELECT Severity, count(City) as Accident_count FROM us_accidents_march23
    GROUP BY Severity
    ORDER BY count(City) DESC

-- We are going to make the new column named year and with the year, we will find the number of accidents in those years --
SELECT YEAR(Start_Time) , count(City) as Accident_count
    FROM us_accidents_march23
    GROUP BY YEAR(Start_Time)
    ORDER BY Accident_count DESC;

-- We are now going to find the number of accidents by the months --
SELECT MONTHNAME(Start_Time), count(City) as Accident_count 
    FROM us_accidents_march23
    GROUP BY MONTHNAME(Start_Time);

-- We are going to find the top 10 cities by accidents --
SELECT City, count(City) as Accident_count 
    FROM us_accidents_march23
    GROUP BY City
    ORDER BY Accident_count DESC 
    LIMIT 10;

-- We are now finding the top 10 country by accident counts --
SELECT County, COUNT(County) as Accident_count 
    FROM us_accidents_march23
    GROUP BY County
    ORDER BY Accident_count DESC
    LIMIT 10;

-- We are going to find the number of accidents by hotter or colder region --

WITH CTE as (
SELECT *,
CASE
    WHEN `Temperature(F)` >= 32 THEN "Hotter"
    ELSE "Colder"
END AS Hotter_Colder_region
    FROM us_accidents_march23
)
SELECT Hotter_Colder_region, COUNT(City) as Accident_count
    FROM CTE
        GROUP BY Hotter_Colder_region
        ORDER BY Accident_count;

-- Finding the number of accidents in the different weather conditions --
SELECT `Weather_Condition`, count(`City`) as Accident_count
    FROM us_accidents_march23
    GROUP BY `Weather_Condition`
    ORDER BY Accident_count DESC;

-- Finding the number of accidents by astronomical twilight --
SELECT `Astronomical_Twilight`, count(`City`) as Accident_count
    FROM us_accidents_march23
        GROUP BY `Astronomical_Twilight`
        ORDER BY Accident_count

-- Finding the number of accidents by nautical twilight --
SELECT `Nautical_Twilight`, count(`City`) as Accident_count
    FROM us_accidents_march23
        GROUP BY `Nautical_Twilight`
        ORDER BY Accident_count

-- Finding the number of accidents by civil twilight --
SELECT `Civil_Twilight`, count(`City`) as Accident_count
    FROM us_accidents_march23
        GROUP BY `Civil_Twilight`
        ORDER BY Accident_count

-- FInding the number of accidents by wind direction --
SELECT `Wind_Direction`, count(`City`) as Accident_count
    FROM us_accidents_march23
        GROUP BY `Wind_Direction`
        ORDER BY Accident_count

-- Find the number of accident count in the states of US --
SELECT `State`, count(`City`) as Accident_count 
    FROM us_accidents_march23
    GROUP BY `State`
    ORDER BY Accident_count;

-- FInd the top 10 list of airports having accidents --
SELECT Airport_Code, count(City) as Accident_count
    FROM us_accidents_march23
    GROUP BY Airport_Code
    ORDER BY Accident_count DESC
    LIMIT 10;

-- Find the top 10 cities that have impacted the traffic the most during the accident handling --
SELECT `City`, AVG(TIMESTAMPDIFF(MINUTE, `Start_Time`, `End_Time`)/60) as duration 
    FROM us_accidents_march23
        GROUP BY `City`
        ORDER BY duration DESC
        LIMIT 10;

-- Finding the total number of accidents based on the humidity in the country --
SELECT `Humidity(%)`, count(`City`) as Accident_count  
    FROM us_accidents_march23
        GROUP BY `Humidity(%)`
        ORDER BY Accident_count DESC
        LIMIT 20;                       # We observed that the number of accidents increases as the humidity increases

-- We want to find the number of accidents based on the pressure in the country
SELECT `Pressure(in)`, count(`City`) as accident_count
    FROM us_accidents_march23
        GROUP BY `Pressure(in)`
            ORDER BY `Pressure(in)` DESC  # We observed that the number of accidents increses in the pressure range of (29.81, 30.19)
