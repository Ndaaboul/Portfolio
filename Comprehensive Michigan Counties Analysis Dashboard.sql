

--1 Create a calculation to determine the safety of each city in michigan using the crime_rate table by adding up
--  all different crimes and dividing it by the population to find the percentage.

SELECT City_ID, City_name, County_ID, County_name,Population,
ROUND((([Violant_crime]+[Murder]+[Rape]+[Robbery]+[Assult]+[Property_crime]+[Burglary]+[Theft]+[Motor_Theft]+[Arson])/[Population]) * 100 ,2) AS Crime_rate
FROM Crime_rate
ORDER BY City_id

--2 calculate the distance between all the cities seperatly, to do that cross join the table with itself to get every possible outcome in one column
-- instead of a matrix table


SELECT 
    a.city_id AS City1_ID, 
    a.city AS City1_Name, 
    a.county_id AS County1_ID, 
    a.county_name AS County1_Name, 
    a.lat AS City1_Latitude, 
    a.lng AS City1_Longitude, 
    b.city_id AS City2_ID, 
    b.city AS City2_Name, 
    b.lat AS City2_Latitude, 
    b.lng AS City2_Longitude,
	(6371 * 2 * ATN2(
        SQRT(
            SIN(RADIANS(b.lat - a.lat) / 2) * SIN(RADIANS(b.lat - a.lat) / 2) +
            COS(RADIANS(a.lat)) * COS(RADIANS(b.lat)) * 
            SIN(RADIANS(b.lng - a.lng) / 2) * SIN(RADIANS(b.lng - a.lng) / 2)
        ),
        SQRT(
            1 - (
                SIN(RADIANS(b.lat - a.lat) / 2) * SIN(RADIANS(b.lat - a.lat) / 2) +
                COS(RADIANS(a.lat)) * COS(RADIANS(b.lat)) * 
                SIN(RADIANS(b.lng - a.lng) / 2) * SIN(RADIANS(b.lng - a.lng) / 2)
            )
        )
    )) AS Distance_km
FROM 
    [uscities] a
CROSS JOIN
    [uscities] b
WHERE 
    a.city_id <> b.city_id
ORDER BY 
    a.city_id, b.city_id



--3 need to create 2 new tables with the previous information 

-- FIRST TABLE
SELECT 
    City_ID, 
    City_name, 
    County_ID, 
    County_name,
    Population,
    ROUND((
        ([Violant_crime] + [Murder] + [Rape] + [Robbery] + [Assult] + 
         [Property_crime] + [Burglary] + [Theft] + [Motor_Theft] + [Arson]) / [Population]
        ) * 100, 2) AS Crime_rate
INTO 
    Crime_per
FROM 
    Crime_rate
ORDER BY 
    City_id;

--2ND TABLE

SELECT 
    a.city_id AS City1_ID, 
    a.city AS City1_Name, 
	a.[County_id] AS county1,
    b.city_id AS City2_ID, 
    b.city AS City2_Name, 
	b.County_ID AS county2,
	b.County_name,
	b.population,
	(6371 * 2 * ATN2(
        SQRT(
            SIN(RADIANS(b.lat - a.lat) / 2) * SIN(RADIANS(b.lat - a.lat) / 2) +
            COS(RADIANS(a.lat)) * COS(RADIANS(b.lat)) * 
            SIN(RADIANS(b.lng - a.lng) / 2) * SIN(RADIANS(b.lng - a.lng) / 2)
        ),
        SQRT(
            1 - (
                SIN(RADIANS(b.lat - a.lat) / 2) * SIN(RADIANS(b.lat - a.lat) / 2) +
                COS(RADIANS(a.lat)) * COS(RADIANS(b.lat)) * 
                SIN(RADIANS(b.lng - a.lng) / 2) * SIN(RADIANS(b.lng - a.lng) / 2)
            )
        )
    )) AS Distance_km
INTO 
	City_Distance
FROM 
    [uscities] a
CROSS JOIN
    [uscities] b
WHERE 
    a.city_id <> b.city_id
ORDER BY 
    a.city_id


--4 get the average crime rate and average distance on county level. we are going to have to levels in the dashboard, county level and city level

--create a table on a County level with all the information.
SELECT ratea.[County_id], ratea.[county_name] AS County1, rateab.[county_name] AS County2,rateab.[pop2020], rateab.[fmr_0], rateab.[fmr_1], rateab.[fmr_2], rateab.[fmr_3], rateab.[fmr_4],
CAST(AVG(DIS.[Distance_km]*0.621371) AS INT) AS Distance_County_Mile,
ROUND(AVG(CRM.Crime_rate),2) AS CrimeRate_County
FROM FMR2024 AS ratea
CROSS JOIN FMR2024 AS rateab
LEFT JOIN City_Distance AS DIS ON ratea.[County_id] = DIS.county1 AND rateab.[County_id] = DIS.county2
LEFT JOIN Crime_per AS CRM ON rateab.[County_id] = CRM.County_ID
GROUP BY ratea.[County_id], ratea.[county_name], rateab.[county_name], rateab.[pop2020], rateab.[fmr_0], rateab.[fmr_1], rateab.[fmr_2], rateab.[fmr_3], rateab.[fmr_4]
ORDER BY rateab.[pop2020] DESC


--5 create a table on city level with all the information.
SELECT DIS.[City1_Name], DIS.[City2_Name], DIS.[County_name], DIS.[population] AS city_population, Cast(DIS.[Distance_km]*0.621371 AS INT) AS Distance_Mile,
[Crime_rate],
rate.[fmr_0], rate.[fmr_1], rate.[fmr_2], rate.[fmr_3], rate.[fmr_4]
FROM [dbo].[City_Distance] AS DIS
LEFT JOIN [dbo].[Crime_per] AS CRM ON DIS.[City2_ID]=CRM.[City_ID]
LEFT JOIN [dbo].[FMR2024] AS rate ON DIS.[county2] = rate.[County_id]
ORDER BY DIS.[population] DESC