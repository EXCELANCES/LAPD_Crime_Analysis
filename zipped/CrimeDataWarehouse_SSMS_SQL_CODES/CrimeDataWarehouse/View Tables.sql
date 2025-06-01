Select Count(Time_ID) From Time_Dimension


ALTER TABLE Time_Dimension
ADD Date_OCC_String AS CONVERT(VARCHAR(10), Date_OCC, 120);


ALTER TABLE Time_Dimension
ADD Time_OCC_String AS CONVERT(VARCHAR(8), Time_OCC, 108);

ALTER TABLE Time_Dimension
DROP COLUMN TIME_OCC_String;


ALTER TABLE Time_Dimension
ADD Time_OCC_String VARCHAR(10);

ALTER TABLE Time_Dimension
ADD DATE_OCC_String VARCHAR(10);


SELECT Location_ID, COUNT(*) 
FROM Location_Dimension 
GROUP BY Location_ID 
HAVING COUNT(*) > 1



SELECT AREA, AREA_NAME, COUNT(*)
FROM Location_Dimension
GROUP BY AREA, AREA_NAME
HAVING COUNT(*) > 1


SELECT AREA, AREA_NAME, COUNT(*)
FROM Location_Dimension
GROUP BY AREA, AREA_NAME
HAVING COUNT(*) > 1


SELECT COUNT(*) 
FROM Fact_Crime 



SELECT 
    LD.Area_Name,
    COUNT(*) AS Crime_Count
FROM Fact_Crime FC
JOIN Location_Dimension LD ON FC.Location_ID = LD.Location_ID
GROUP BY LD.Area_Name
ORDER BY Crime_Count DESC


SELECT @@VERSION;


USE [CrimeDataWarehouse];
GO
SELECT TOP 10 Time_OCC FROM Fact_Crime


SELECT * Time_OCC FROM Fact_Crime