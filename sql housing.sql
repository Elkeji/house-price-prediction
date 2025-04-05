#Enabling_local_file
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';
SHOW VARIABLES LIKE 'secure_file_priv';
#Setting up data_base
CREATE DATABASE IF NOT EXISTS house_prices;
USE house_prices;
DROP TABLE IF EXISTS house_data;
#Data_table creation
CREATE TABLE house_data (
    Id INT,
    MSSubClass INT,
    MSZoning VARCHAR(10),
    LotFrontage INT,
    LotArea INT,
    Street VARCHAR(10),
    Alley VARCHAR(10),
    LotShape VARCHAR(10),
    LandContour VARCHAR(10),
    Utilities VARCHAR(10),
    Neighborhood VARCHAR(50),
    OverallQual INT,
    OverallCond INT,
    YearBuilt INT,
    GrLivArea INT,
    BedroomAbvGr INT,
    FullBath INT,
    HalfBath INT,
    SalePrice INT
);

DROP TABLE IF EXISTS house_staging;
#house_staging_table
CREATE TABLE house_staging (
  Id INT,
  MSSubClass VARCHAR(10),
  MSZoning VARCHAR(10),
  LotFrontage VARCHAR(10),
  LotArea VARCHAR(20),
  Street VARCHAR(10),
  Alley VARCHAR(10),
  LotShape VARCHAR(10),
  LandContour VARCHAR(10),
  Utilities VARCHAR(10),
  LotConfig VARCHAR(20),
  LandSlope VARCHAR(10),
  Neighborhood VARCHAR(50),
  Condition1 VARCHAR(20),
  Condition2 VARCHAR(20),
  BldgType VARCHAR(20),
  HouseStyle VARCHAR(20),
  OverallQual INT,
  OverallCond INT,
  YearBuilt VARCHAR(10),
  YearRemodAdd VARCHAR(10),
  RoofStyle VARCHAR(20),
  RoofMatl VARCHAR(20),
  Exterior1st VARCHAR(30),
  Exterior2nd VARCHAR(30),
  MasVnrType VARCHAR(10),
  MasVnrArea VARCHAR(20),
  ExterQual VARCHAR(10),
  ExterCond VARCHAR(10),
  Foundation VARCHAR(20),
  BsmtQual VARCHAR(10),
  BsmtCond VARCHAR(10),
  BsmtExposure VARCHAR(10),
  BsmtFinType1 VARCHAR(20),
  BsmtFinSF1 VARCHAR(20),
  BsmtFinType2 VARCHAR(20),
  BsmtFinSF2 VARCHAR(20),
  BsmtUnfSF VARCHAR(20),
  TotalBsmtSF VARCHAR(20),
  Heating VARCHAR(20),
  HeatingQC VARCHAR(10),
  CentralAir VARCHAR(10),
  Electrical VARCHAR(20),
  `1stFlrSF` VARCHAR(20),
  `2ndFlrSF` VARCHAR(20),
  LowQualFinSF VARCHAR(20),
  GrLivArea VARCHAR(20),
  BsmtFullBath VARCHAR(10),
  BsmtHalfBath VARCHAR(10),
  FullBath VARCHAR(10),
  HalfBath VARCHAR(10),
  BedroomAbvGr VARCHAR(10),
  KitchenAbvGr VARCHAR(10),
  KitchenQual VARCHAR(10),
  TotRmsAbvGrd VARCHAR(10),
  Functional VARCHAR(10),
  Fireplaces VARCHAR(10),
  FireplaceQu VARCHAR(10),
  GarageType VARCHAR(10),
  GarageYrBlt VARCHAR(10),
  GarageFinish VARCHAR(10),
  GarageCars VARCHAR(10),
  GarageArea VARCHAR(20),
  GarageQual VARCHAR(10),
  GarageCond VARCHAR(10),
  PavedDrive VARCHAR(10),
  WoodDeckSF VARCHAR(20),
  OpenPorchSF VARCHAR(20),
  EnclosedPorch VARCHAR(20),
  `3SsnPorch` VARCHAR(20),
  ScreenPorch VARCHAR(20),
  PoolArea VARCHAR(20),
  PoolQC VARCHAR(10),
  Fence VARCHAR(20),
  MiscFeature VARCHAR(20),
  MiscVal VARCHAR(20),
  MoSold VARCHAR(10),
  YrSold VARCHAR(10),
  SaleType VARCHAR(20),
  SaleCondition VARCHAR(20),
  SalePrice VARCHAR(20)
);
#Loading_Data into_staging_table 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.01/Uploads/train.csv'
INTO TABLE house_staging
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
SELECT * FROM house_staging LIMIT 5;
Refining Data_table 
DROP TABLE IF EXISTS house_data;
CREATE TABLE house_data (
    Id INT,
    LotArea INT,
    YearBuilt INT,
    Neighborhood VARCHAR(50),
    GrLivArea INT,
    BedroomAbvGr INT,
    FullBath INT,
    OverallQual INT,
    SalePrice INT
);
INSERT INTO house_data (Id, LotArea, YearBuilt, Neighborhood, GrLivArea, BedroomAbvGr, FullBath, OverallQual, SalePrice)
SELECT 
    Id, 
    LotArea, 
    YearBuilt, 
    Neighborhood, 
    GrLivArea, 
    BedroomAbvGr, 
    FullBath, 
    OverallQual, 
    SalePrice
FROM house_staging;
#Data_summary_and_validation 
SELECT COUNT(*) AS total_rows FROM house_data;
SELECT * FROM house_data LIMIT 10;
SELECT 
    MIN(SalePrice) AS min_price,
    MAX(SalePrice) AS max_price,
    AVG(SalePrice) AS avg_price,
    STDDEV(SalePrice) AS std_dev_price
FROM house_data;

SELECT 
    MIN(GrLivArea) AS min_GrLiv,
    MAX(GrLivArea) AS max_GrLiv,
    AVG(GrLivArea) AS avg_GrLiv,
    STDDEV(GrLivArea) AS std_dev_GrLiv
FROM house_data;

SELECT 
    MIN(LotArea) AS min_LotArea,
    MAX(LotArea) AS max_LotArea,
    AVG(LotArea) AS avg_LotArea,
    STDDEV(LotArea) AS std_dev_LotArea
FROM house_data;
#Statistical_Summaries
SELECT 
    Neighborhood, 
    COUNT(*) AS num_houses,
    AVG(SalePrice) AS avg_sale_price,
    MIN(SalePrice) AS min_sale_price,
    MAX(SalePrice) AS max_sale_price
FROM house_data
GROUP BY Neighborhood
ORDER BY avg_sale_price DESC;

#Area_Binning
SELECT 
    GrLivArea, 
    SalePrice
FROM house_data
ORDER BY GrLivArea;
SELECT 
  CASE 
    WHEN GrLivArea < 1000 THEN 'Small'
    WHEN GrLivArea BETWEEN 1000 AND 2000 THEN 'Medium'
    ELSE 'Large'
  END AS Area_Bin,
  COUNT(*) AS num_houses,
  AVG(SalePrice) AS avg_sale_price
FROM house_data
GROUP BY Area_Bin;

#Neighborhood_based analysis
SELECT Neighborhood, 
  COUNT(*) AS num_houses,
  AVG(SalePrice) AS avg_sale_price,
  MIN(SalePrice) AS min_sale_price,
  MAX(SalePrice) AS max_sale_price
FROM house_data
GROUP BY Neighborhood
ORDER BY avg_sale_price DESC;
#Checking for_missing_values
SELECT
  SUM(CASE WHEN SalePrice IS NULL OR SalePrice = '' THEN 1 ELSE 0 END) AS missing_saleprice,
  SUM(CASE WHEN GrLivArea IS NULL OR GrLivArea = '' THEN 1 ELSE 0 END) AS missing_grlivarea,
  SUM(CASE WHEN LotArea IS NULL OR LotArea = '' THEN 1 ELSE 0 END) AS missing_lotarea,
  SUM(CASE WHEN Neighborhood IS NULL OR Neighborhood = '' THEN 1 ELSE 0 END) AS missing_neighborhood
FROM house_data;

