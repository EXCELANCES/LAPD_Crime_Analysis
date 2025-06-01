USE CrimeDataWarehouse;
GO

CREATE TABLE Time_Dimension (
    Time_ID INT IDENTITY(1,1) PRIMARY KEY,
    Date_OCC DATE NOT NULL,
    Time_OCC VARCHAR(10) NOT NULL,
    Day_Of_Week VARCHAR(10),
    Months VARCHAR(20),
    Years INT
);

CREATE TABLE Location_Dimension (
    Location_ID INT IDENTITY(1,1) PRIMARY KEY,
    Area VARCHAR(50),
    Area_Name VARCHAR(100) NOT NULL,
    LAT DECIMAL(10,6),
    LON DECIMAL(10,6),
    Cross_Street VARCHAR(100)
);

CREATE TABLE CrimeType_Dimension (
    CrimeType_ID INT IDENTITY(1,1) PRIMARY KEY,
    Crime_Code INT NOT NULL,
    Crime_Desc VARCHAR(255) NOT NULL,
    Part_1_2 VARCHAR(10)
);

CREATE TABLE Status_Dimension (
    Status_ID INT IDENTITY(1,1) PRIMARY KEY,
    Status_Code VARCHAR(20),
    Status_Desc VARCHAR(100) NOT NULL
);

CREATE TABLE Victim_Dimension (
    Victim_ID INT IDENTITY(1,1) PRIMARY KEY,
    Vict_Age INT,
    Vict_Sex VARCHAR(10),
    Vict_Descent VARCHAR(50)
);

CREATE TABLE Fact_Crime (
    Crime_ID INT PRIMARY KEY,
    Time_ID INT NOT NULL,
    Location_ID INT NOT NULL,
    CrimeType_ID INT NOT NULL,
    Victim_ID INT NOT NULL,
    Status_ID INT NOT NULL,
    Date_OCC DATE,
    Time_OCC TIME,
    Weapon_Used VARCHAR(50),
    FOREIGN KEY (Time_ID) REFERENCES Time_Dimension(Time_ID),
    FOREIGN KEY (Location_ID) REFERENCES Location_Dimension(Location_ID),
    FOREIGN KEY (CrimeType_ID) REFERENCES CrimeType_Dimension(CrimeType_ID),
    FOREIGN KEY (Victim_ID) REFERENCES Victim_Dimension(Victim_ID),
    FOREIGN KEY (Status_ID) REFERENCES Status_Dimension(Status_ID)
);