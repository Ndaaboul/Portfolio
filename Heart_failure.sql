-- Retrieve all data from the heart_failure table
SELECT * FROM heart_failure;

-- Update boolean columns (0 and 1) to descriptive values ('No' and 'Yes') for better readability and visualization
UPDATE heart_failure
SET anaemia = CASE WHEN anaemia = 0 THEN 'No' ELSE 'Yes' END;

UPDATE heart_failure
SET diabetes = CASE WHEN diabetes = 0 THEN 'No' ELSE 'Yes' END;

UPDATE heart_failure
SET high_blood_pressure = CASE WHEN high_blood_pressure = 0 THEN 'No' ELSE 'Yes' END;

UPDATE heart_failure
SET smoking = CASE WHEN smoking = 0 THEN 'No' ELSE 'Yes' END;

UPDATE heart_failure
SET DEATH_EVENT = CASE WHEN DEATH_EVENT = 0 THEN 'No' ELSE 'Yes' END;

-- Update sex column to display 'Female' and 'Male' instead of 0 and 1
UPDATE heart_failure
SET sex = CASE WHEN sex = 0 THEN 'Female' ELSE 'Male' END;

-- Verify the updates
SELECT * FROM heart_failure;

-- Calculate summary statistics for numerical columns
SELECT 
    MIN(age) AS MinAge, MAX(age) AS MaxAge, AVG(age) AS AvgAge, STDEV(age) AS StdevAge,
    MIN(creatinine_phosphokinase) AS MinCPK, MAX(creatinine_phosphokinase) AS MaxCPK, AVG(creatinine_phosphokinase) AS AvgCPK, STDEV(creatinine_phosphokinase) AS StdevCPK,
    MIN(ejection_fraction) AS MinEjectionFraction, MAX(ejection_fraction) AS MaxEjectionFraction, AVG(ejection_fraction) AS AvgEjectionFraction, STDEV(ejection_fraction) AS StdevEjectionFraction,
    MIN(platelets) AS MinPlatelets, MAX(platelets) AS MaxPlatelets, AVG(platelets) AS AvgPlatelets, STDEV(platelets) AS StdevPlatelets,
    MIN(serum_creatinine) AS MinSerumCreatinine, MAX(serum_creatinine) AS MaxSerumCreatinine, AVG(serum_creatinine) AS AvgSerumCreatinine, STDEV(serum_creatinine) AS StdevSerumCreatinine,
    MIN(serum_sodium) AS MinSerumSodium, MAX(serum_sodium) AS MaxSerumSodium, AVG(serum_sodium) AS AvgSerumSodium, STDEV(serum_sodium) AS StdevSerumSodium
FROM heart_failure;

-- Count the number of occurrences for each categorical variable
SELECT
    SUM(CASE WHEN anaemia = 'Yes' THEN 1 ELSE 0 END) AS AnaemiaCount,
    SUM(CASE WHEN diabetes = 'Yes' THEN 1 ELSE 0 END) AS DiabetesCount,
    SUM(CASE WHEN high_blood_pressure = 'Yes' THEN 1 ELSE 0 END) AS HighBloodPressureCount,
    SUM(CASE WHEN smoking = 'Yes' THEN 1 ELSE 0 END) AS SmokingCount,
    SUM(CASE WHEN DEATH_EVENT = 'Yes' THEN 1 ELSE 0 END) AS DeathEventCount,
    SUM(CASE WHEN sex = 'Male' THEN 1 ELSE 0 END) AS MaleCount,
    SUM(CASE WHEN sex = 'Female' THEN 1 ELSE 0 END) AS FemaleCount
FROM heart_failure;

-- Calculate the average age of patients grouped by their death event outcome
SELECT DEATH_EVENT, AVG(age) AS AvgAge
FROM heart_failure
GROUP BY DEATH_EVENT;

-- Distribution of ejection fraction values across all patients
SELECT ejection_fraction, COUNT(*) AS Count
FROM heart_failure
GROUP BY ejection_fraction
ORDER BY ejection_fraction;

-- Analyze the impact of high blood pressure on death event outcome
SELECT 
    high_blood_pressure, 
    DEATH_EVENT, 
    COUNT(*) AS Count
FROM heart_failure
GROUP BY high_blood_pressure, DEATH_EVENT
ORDER BY high_blood_pressure, DEATH_EVENT;

-- Distribution of patients by gender
SELECT sex, COUNT(*) AS Count
FROM heart_failure
GROUP BY sex;

-- Count patients who have both diabetes and anaemia
SELECT 
    COUNT(*) AS DiabetesAndAnaemiaCount, 
    5000 AS Total_Count, 
    CAST((COUNT(*) / 5000.0) * 100 AS FLOAT) AS Percentage
FROM heart_failure
WHERE diabetes = 'Yes' AND anaemia = 'Yes';

-- Calculate follow-up time statistics grouped by death event outcome
SELECT 
    DEATH_EVENT, 
    MIN(Follow_up) AS MinTime, 
    MAX(Follow_up) AS MaxTime, 
    AVG(Follow_up) AS AvgTime, 
    STDEV(Follow_up) AS StdevTime
FROM heart_failure
GROUP BY DEATH_EVENT;