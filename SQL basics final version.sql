--SELECT all the data from table
SELECT * 
FROM weatherAUS

--SELECT data from table
SELECT date, location, mintemp, maxtemp, rainfall 
FROM weatherAUS

--SELECT all the unique values from a column
SELECT DISTINCT location 
FROM weatherAUS

--Return the number of rows in one or more columns and giving the column a heading using an Alias
SELECT COUNT(distinct location) AS Locations 
FROM weatherAUS

--Filter numeric records and text results whilst also SELECTing data based on multiple conditions using AND
SELECT date, location, mintemp, maxtemp, rainfall 
FROM weatherAUS 
WHERE maxtemp > 20 
    AND location = 'Sydney'

--SELECT rows based on multiple conditions where some but not all of the conditions need to be met
SELECT date, location, mintemp, maxtemp, rainfall 
FROM weatherAUS 
WHERE location = 'Sydney' 
    OR location = 'Perth'

--Filtering values within a specified range
SELECT date, location, mintemp, maxtemp, rainfall 
FROM weatherAUS 
WHERE maxtemp BETWEEN 40 and 50

--Filter based on multiple conditions
SELECT date, location, mintemp, maxtemp, rainfall 
FROM weatherAUS 
WHERE location IN ('Sydney', 'Melbourne', 'Perth', 'Brisbane', 'Darwin')

--To figure out what data you're missing, you can check for NULL values
SELECT location, rainfall 
FROM weatherAUS 
WHERE Rainfall IS NULL
--To filter out missing values so you only get results which are not NULL
SELECT location, rainfall 
FROM weatherAUS 
WHERE Rainfall IS NOT NULL

--Use LIKE operator in  WHERE clause to search for pattern in column, also use NOT LIKE operator to find records that don't match the pattern you specify.
--Use wildcard as a placeholder such as % and _
SELECT distinct(location) 
FROM weatherAUS 
WHERE location LIKE 'B%' 
AND location NOT LIKE '_a%'

--Perform some calculations on the data using aggregate functions
SELECT SUM(rainfall) AS SUM_rainfall, AVG(windgustspeed) AS AVG_windspeed, 
MIN(humidity9am) AS MIN_humidity9am, MAX(humidity3pm) AS MAX_humidity3pm 
FROM weatherAUS

--Perform basic arithmetic with symbols
--Dividing an integer by an integer, returns an integer back. If you want more precision when dividing, add decimal places to your numbers
SELECT 5+4, 9-6, 4*3, 4/3, 4.0/3.0

--ORDER BY keyword is used to sort results in ascending or descending order according to the values of one or more columns
--By default ORDER BY will sort in ascending order. If you want to sort the results in descending order, you can use the DESC keyword
SELECT date, location, rainfall 
FROM weatherAUS 
ORDER BY location, rainfall DESC

--Group a result by one or more columns
SELECT location, MAX(windgustspeed) AS Max_Wind_Gust 
FROM weatherAUS 
GROUP BY location 
ORDER BY Max_Wind_Gust DESC

--Filter based on the result of an aggregate function using HAVING
SELECT location, windgustspeed 
FROM weatherAUS 
GROUP BY location, windgustspeed 
HAVING MAX(windgustspeed) >= 100 
ORDER BY windgustspeed DESC
