--Basic CASE statements
SELECT 
	CASE WHEN TotalPoints = 2251 THEN 'LeBron James'
	WHEN TotalPoints = 2191 THEN 'James Harden'
	ELSE 'Other' END AS Players,
	PlayerName,
	TotalPoints
FROM NBAPlayerStatistics
GROUP BY Players
ORDER BY TotalPoints DESC

--CASE statements comparing column values
SELECT
	CASE WHEN Height_cm > 210 THEN 'Tallest Players'
	WHEN Height_cm > 200 THEN 'SmallBall Players'
	ELSE 'Other' END AS Height,
	p.PlayerName,
	ps.Position
FROM NBAPlayers AS p
INNER JOIN NBAPlayerStatistics as ps
ON p.PlayerName = ps.PlayerName
WHERE Position = 'C'

--Filtering your CASE statement
SELECT 
	PlayerName, Age, Country, College
FROM NBAPlayers
	WHERE CASE WHEN Country = 'USA' AND College = 'UCLA' THEN 'Native Bruins'
	WHEN Country = 'France' AND College = 'None' THEN 'Foreign Alum'
	END IS NOT NULL

--CASE statement with multiple conditions and aggregate function
SELECT
	COUNT(CASE WHEN Position = 'PG' THEN 'Point Guard' END) AS TotalPGs,
	COUNT(CASE WHEN Position = 'SG' THEN 'Shooting Guard' END) AS TotalSGs,
	COUNT(CASE WHEN Position = 'SF' THEN 'Small Forward' END) AS TotalSFs,
	COUNT(CASE WHEN Position = 'PF' THEN 'Power Forward' END) AS TotalPFs,
	COUNT(CASE WHEN Position = 'C' THEN 'Center' END) AS TotalCs
FROM NBAPlayerStatistics

--Filtering using scalar subquery to find players who have point 3x more the average TotalPoints
SELECT PlayerName, Team, Position, TotalPoints
FROM NBAPlayerStatistics
WHERE TotalPoints > (SELECT 3 * AVG(TotalPoints)
FROM NBAPlayerStatistics)
ORDER BY PlayerName

--Filtering using a subquery with a list
SELECT PlayerName
FROM NBAPlayers
WHERE PlayerName NOT IN
	(SELECT PlayerName FROM NBAPlayerStatistics)

--Filtering with more complex subquery conditions
SELECT PlayerName, Position, TotalPoints, Team
FROM NBAPlayerStatistics
WHERE TEAM IN
	(SELECT teamcode
	FROM NBATeams
	WHERE ArenaCapacity >= 21000)
ORDER BY TotalPoints DESC

--Joining Subqueries in FROM
SELECT p.PlayerName, Age, Height_cm, Weight_kg
FROM NBAPlayers as p
INNER JOIN
	(SELECT PlayerName
	FROM NBAPlayerStatistics
	WHERE (OffRebound + DefRebound) >= 1000) as TReb
ON p.PlayerName = TReb.PlayerName
GROUP BY p.PlayerName, Age, Height_cm, Weight_kg

--Building on Subqueries in FROM
SELECT COUNTRY, PlayerName, Team, Position, OffRebound, DefRebound
FROM 
	(SELECT 
	p.Country AS COUNTRY, ps.PlayerName, ps.Team, ps.Position, ps.OffRebound, 
	ps.DefRebound, (ps.OffRebound + ps.DefRebound) AS TotalRebounds
	FROM NBAPlayerStatistics AS ps
	LEFT JOIN NBAPlayers AS p
	ON ps.PlayerName = p.PlayerName) AS subquery
WHERE TotalRebounds >= 800

--Add a subquery to the SELECT clause
/*This query returns the average total rebounds for each distinct height in the
PF position and compares it to the average total rebounds of the Center position*/
SELECT 
	p.Height_cm as PF_Heights, ROUND(AVG(OffRebound + DefRebound),2) AS AVG_Reb,
	(SELECT ROUND(AVG(OffRebound + DefRebound),2)
	FROM NBAPlayerStatistics
	WHERE Position = 'C') AS AVG_C_Reb
FROM NBAPlayers as p
LEFT JOIN NBAPlayerStatistics AS ps
ON p.PlayerName = ps.PlayerName
WHERE Position = 'PF'
GROUP BY p.Height_cm
ORDER BY Height_cm DESC

--Basic Correlated subquery
/*This query returns results of players who have 
total points that is more than 3 times the average*/
SELECT PlayerName, Team, Position, TotalPoints
FROM NBAPlayerStatistics AS main
WHERE
	TotalPoints > (SELECT AVG((totalpoints)*3)
	FROM NBAPlayerStatistics AS sub
	WHERE main.Position = sub.Position)
ORDER BY TotalPoints DESC

--CTE
WITH TotalRebounds AS (
	SELECT
		PlayerName
	FROM NBAPlayerStatistics
	WHERE (OffRebound + DefRebound) >= 175)
SELECT
	Country,
	COUNT(TotalRebounds.PlayerName) AS Rebounds
FROM NBAPlayers AS p
LEFT JOIN TotalRebounds ON p.PlayerName = TotalRebounds.PlayerName
GROUP BY Country
ORDER BY Rebounds DESC

--OVER() clause
SELECT
	p.PlayerName,
	p.Country,
	ps.Position,
	ps.OffRebound,
	ps.DefRebound,
	AVG(ps.OffRebound + ps.DefRebound) OVER () AS Overall_AVG
FROM NBAPlayers AS p
LEFT JOIN NBAPlayerStatistics AS ps
	ON p.PlayerName = ps.PlayerName

--RANK() the OVER() clause
SELECT
	p.PlayerName
	Position,
	AVG(OffRebound + DefRebound) as TotalRebs,
	RANK() OVER(ORDER BY (OffRebound + DefRebound)DESC) AS League_Rank
FROM NBAPlayers AS p
LEFT JOIN NBAPlayerStatistics AS ps
	ON p.PlayerName = ps.PlayerName
WHERE Position = 'C'
GROUP BY p.PlayerName, Position, OffRebound, DefRebound
ORDER BY League_Rank

--PARTITION BY a column
SELECT
	PlayerName,
	Position,
	TotalPoints,
	CASE WHEN TotalPoints > 1000 THEN 'HighScoring'
	ELSE 'LowScoring' END AS Scoring,
	AVG(TotalPoints) OVER(PARTITION BY Position) as AVG_PtsPerPosition
FROM NBAPlayerStatistics
ORDER BY Position

--Sliding Windows
/*Sliding to the left*/
SELECT
	PlayerName,
	Position,
	TotalPoints,
	SUM(TotalPoints) OVER(ORDER BY Position
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal,
	AVG(TotalPoints) OVER(ORDER BY Position
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningAVG
FROM NBAPlayerStatistics
/*Sliding to the right*/
SELECT
	PlayerName,
	Position,
	TotalPoints,
	SUM(TotalPoints) OVER(ORDER BY Position DESC
		ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS RunningTotal,
	AVG(TotalPoints) OVER(ORDER BY Position DESC
		ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS RunningAVG
FROM NBAPlayerStatistics