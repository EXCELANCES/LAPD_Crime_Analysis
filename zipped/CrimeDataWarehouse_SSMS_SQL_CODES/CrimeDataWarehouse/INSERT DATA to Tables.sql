USE [CrimeDataWarehouse];

-- 📌 1. TÜM TABLOLARI TEMİZLEME
DELETE FROM Crime_Fact_Table;
DELETE FROM Date_Dimension;
DELETE FROM Time_Dimension;
DELETE FROM Location_Dimension;
DELETE FROM CrimeType_Dimension;
DELETE FROM Status_Dimension;

-- 📌 2. Time_Dimension Tablosuna Veri Ekleme
INSERT INTO Time_Dimension (Time_ID, Date_OCC, Time_OCC, Day_Of_Week, Month, Year)
SELECT DISTINCT 
    ROW_NUMBER() OVER (ORDER BY CR.DATE_OCC) AS Time_ID,
    CR.DATE_OCC, 
    CONVERT(TIME, 
        STUFF(RIGHT('0000' + CAST(CR.TIME_OCC AS VARCHAR(4)), 4), 3, 0, ':')
    ) AS Time_OCC, -- 1230 → 12:30:00 formatına çeviriyoruz
    DATENAME(WEEKDAY, CR.DATE_OCC) AS Day_Of_Week,
    DATENAME(MONTH, CR.DATE_OCC) AS Month,
    YEAR(CR.DATE_OCC) AS Year
FROM dbo.Crime_Raw_Data AS CR;

-- 📌 3. Location_Dimension Tablosuna Veri Ekleme
INSERT INTO Location_Dimension (Location_ID, Area, Area_Name, LAT, LON, Cross_Street)
SELECT DISTINCT 
    ROW_NUMBER() OVER (ORDER BY CR.AREA) AS Location_ID,
    CR.AREA, 
    CR.AREA_NAME, 
    CR.LAT, 
    CR.LON, 
    CR.Cross_Street
FROM dbo.Crime_Raw_Data AS CR;

-- 📌 4. CrimeType_Dimension Tablosuna Veri Ekleme (Duplikasyon hatası önlendi)
INSERT INTO CrimeType_Dimension (CrimeType_ID, Crime_Code, Crime_Desc, Part_1_2)
SELECT DISTINCT 
    ROW_NUMBER() OVER (ORDER BY CR.Crm_Cd) AS CrimeType_ID,
    CR.Crm_Cd, 
    CR.Crm_Cd_Desc, 
    CR.Part_1_2
FROM dbo.Crime_Raw_Data AS CR;


-- 📌 5. Status_Dimension Tablosuna Veri Ekleme (NULL veriler için 'Unknown')
INSERT INTO Status_Dimension (Status_ID, Status_Code, Status_Desc)
SELECT DISTINCT 
    ROW_NUMBER() OVER (ORDER BY CR.Status) AS Status_ID,
    CR.Status, 
    CR.Status_Desc
FROM dbo.Crime_Raw_Data AS CR;

-- 📌 6. Victim_Dimension Tablosuna Veri Ekleme (NULL veriler için 'Unknown')
INSERT INTO Victim_Dimension (Victim_ID, Vict_Age, Vict_Sex, Vict_Descent)
SELECT DISTINCT 
    ROW_NUMBER() OVER (ORDER BY CR.Vict_Age) AS Victim_ID,
    CR.Vict_Age, 
    CR.Vict_Sex, 
    CR.Vict_Descent
FROM dbo.Crime_Raw_Data AS CR;


-- 📌 7. Crime_Fact_Table Tablosuna Veri Ekleme (NULL kontrolü ile güvenli veri aktarımı)
INSERT INTO Fact_Crime (Crime_ID, Time_ID, Location_ID, CrimeType_ID, Victim_ID, Status_ID, Date_OCC, Time_OCC, Weapon_Used)
SELECT 
    ROW_NUMBER() OVER (ORDER BY CR.DR_NO) AS Crime_ID,
    T.Time_ID,
    L.Location_ID,
    C.CrimeType_ID,
    V.Victim_ID,
    S.Status_ID,
    CR.DATE_OCC,
    CONVERT(TIME, 
        STUFF(RIGHT('0000' + CAST(CR.TIME_OCC AS VARCHAR(4)), 4), 3, 0, ':')
    ) AS Time_OCC, -- INT formatındaki saat verisini TIME formatına çeviriyoruz
    CR.Weapon_Desc
FROM dbo.Crime_Raw_Data AS CR
JOIN Time_Dimension T 
    ON CR.DATE_OCC = T.Date_OCC 
    AND CONVERT(TIME, 
        STUFF(RIGHT('0000' + CAST(CR.TIME_OCC AS VARCHAR(4)), 4), 3, 0, ':')
    ) = T.Time_OCC
JOIN Location_Dimension L 
    ON CR.AREA = L.Area 
    AND CR.AREA_NAME = L.Area_Name
JOIN CrimeType_Dimension C 
    ON CR.Crm_Cd = C.Crime_Code
JOIN Victim_Dimension V 
    ON CR.Vict_Age = V.Vict_Age 
    AND CR.Vict_Sex = V.Vict_Sex
JOIN Status_Dimension S 
    ON CR.Status = S.Status_Code;

