--INNER JOIN to OneSix and match ON the HappinessScore
SELECT * 
FROM OneFive 
INNER JOIN OneSix 
	ON OneFive.HappinessScore = OneSix.HappinessScore
--INNER JOIN with multiple SELECT name fields
SELECT OneFive.country AS Country, OneFive.happinessrank AS HappinessRank2015, region 
FROM OneFive 
INNER JOIN OneSeven 
	ON OneFive.happinessrank = OneSeven.happinessrank

--Use table aliasing as a shortcut to identify which table/table alias you're referring to by using a . (fullstop)
SELECT a.country AS Country2015, a.happinessrank AS HappinessRank2015, a.region AS Region
FROM OneFive AS A 
INNER JOIN OneSeven AS B 
	ON a.happinessrank = b.happinessrank

--Combine multiple joins in a single query and alias each table
SELECT standarderror, a.country, region, a.happinessrank, c.Overallrank 
FROM OneFive AS a
INNER JOIN OneEight AS b 
	ON a.country = b.Countryorregion
INNER JOIN OneNine AS c 
	ON a.HappinessRank = c.Overallrank 
	AND b.Overallrank = c.Overallrank

-- Self-join to calculate growth percentage
SELECT p1.country_code, p1.size AS size2010, p2.size AS size2015, ((p2.size - p1.size)/p1.size * 100.0) AS growth_perc
FROM populations AS p1 
INNER JOIN populations AS p2 
	ON p1.country_code = p2.country_code 
	AND p1.year = p2.year - 5

--LEFT JOIN
SELECT a.country AS Country2015, a.happinessrank AS HappinessRank2015, a.region AS Region
FROM OneFive AS A 
LEFT JOIN OneSeven AS B 
	ON a.happinessrank = b.happinessrank
ORDER BY HappinessRank2015 DESC

--Multiple RIGHT JOINs
SELECT a.country, a.region, a.happinessrank, c.HappinessScore
FROM OneFive AS a
RIGHT JOIN OneSix AS b 
	ON a.country = b.Country
RIGHT JOIN OneSeven AS c 
	ON a.HappinessRank = c.HappinessRank AND b.HappinessScore = c.HappinessScore

--FULL JOIN
SELECT b.country, a.region, a.happinessrank, a.HappinessScore
FROM OneFive AS a
FULL JOIN OneSix AS b 
	ON a.country = b.country
WHERE a.country like 'B%' OR a.country IS NULL
ORDER BY region

--CROSS JOIN
SELECT a.region, b.Country
FROM OneFive AS a
CROSS JOIN OneSix AS b
WHERE a.region LIKE 'West%'

--UNION to remove duplicates
SELECT * 
FROM OneEight
UNION
SELECT * 
FROM OneNine
ORDER BY gdppercapita DESC
--Using UNION to determine all occurrences of a field across multiple tables
SELECT country
FROM OneFive
UNION
SELECT countryorregion
FROM OneNine
ORDER BY Country

--UNION ALL to include duplicates
SELECT * 
FROM OneEight
UNION ALL
SELECT * 
FROM OneNine
ORDER BY gdppercapita DESC

--INTERSECT returns records that both tables have in common
SELECT countryorregion, Overallrank
FROM OneEight
INTERSECT
SELECT countryorregion, Overallrank
FROM OneNine

--EXCEPT includes only the records that are in one table, but not the other
SELECT trustgovernmentcorruption
FROM OneEight
EXCEPT
SELECT generosity
FROM OneNine
ORDER BY TrustGovernmentCorruption DESC

--SEMI-JOIN with a subquery
SELECT distinct country
FROM OneFive
where HappinessRank IN
	(SELECT HappinessRank
	 FROM OneSix
	 where region = 'Western Europe')
ORDER BY country DESC
ANTI-JOIN with a subquer
SELECT distinct country
FROM OneFive
where HappinessRank NOT IN
	(SELECT HappinessRank
	 FROM OneSix
	 where region = 'Western Europe')
ORDER BY country DESC

--Subquery inside WHERE clause
SELECT name, country_code, urbanarea_pop
FROM cities
WHERE name IN
  (SELECT capital
   FROM countries)
ORDER BY urbanarea_pop DESC

--Subquery inside SELECT clause
SELECT countries.name AS country,
  (SELECT count(*)
   FROM cities
   WHERE countries.code = cities.country_code) AS cities_num
FROM countries
ORDER BY cities_num DESC, country
LIMIT 9

--Subquery inside FROM clause
SELECT local_name, subquery.lang_num
FROM countries,
	(SELECT code, COUNT(*) AS lang_num
  	 FROM languages
  	 GROUP BY code) AS subquery
WHERE countries.code = subquery.code
ORDER BY lang_num DESC