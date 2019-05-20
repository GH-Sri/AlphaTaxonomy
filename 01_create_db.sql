-- Create the database
CREATE DATABASE mdas;

-- Connect to the new DB (rather than Public)
\c mdas

-- Create the schema and make it the default
CREATE SCHEMA mdas AUTHORIZATION mdas;
SET search_path TO mdas;

CREATE TABLE Sector (
        SectorID SERIAL PRIMARY KEY,
        Name text,
        NumberOfIndustries integer,
        NumberOfCompanies integer,
        MarketCap money,
        "10YrPerformance" integer,
        SectorWeight integer
);

CREATE TABLE Industry (
        IndustryID SERIAL PRIMARY KEY,
        SectorID integer REFERENCES Sector,
        Name text,
        NumberOfCompanies integer,
        MarketCap money,
        "10YrPerformance" integer,
        IndustryWeight integer
);

CREATE TABLE mdas.Company (
        CompanyID SERIAL PRIMARY KEY,
        SectorID integer REFERENCES Sector,
        IndustryID integer REFERENCES Industry,
        NasdaqSector text,
        NasdaqIndustry text,
        Name text NOT NULL,
        Ticker text,
        "10YrMarketCap" money,
        "10YrEPS" money,
        "10YrPerformance" integer,
        "10YrPerformanceVsSector" integer,
        "10YrPerformanceVsIndustry" integer,
        "10YrNasdaqPerformanceVsSector" integer,
        "10YrNasdaqPerformanceVsIndustry" integer
);
COMMENT ON COLUMN Company.Ticker IS 'The single ticker symbol most likely recognizable as referring to the company as a whole';
COMMENT ON COLUMN Company."10YrMarketCap" IS 'Initially the sum of current MarketCaps of all ticker symbols this company has on the NASDAQ.  To be replaced with average MarketCap over the past 10 years if the data is available';

CREATE TABLE Ticker (
        CompanyID integer REFERENCES Company,
        Ticker TEXT NOT NULL
);

CREATE TABLE CIK (
        CompanyID integer REFERENCES Company,
        CIK integer NOT NULL
);

CREATE TABLE Competitors (
        CompanyID integer REFERENCES Company,
        CompetitorID integer REFERENCES Company (CompanyID),
        Closeness integer NOT NULL
);

DROP TABLE Performance;
CREATE TABLE Performance (
        CompanyID integer REFERENCES Company,
        year integer,
        MarketCap money,
        EPS money,
        Performance integer,
        PerformanceVsSector integer,
        PerformanceVsIndustry integer,
        NasdaqPerformanceVsSector integer,
        NasdaqPerformanceVsIndustry integer
);

CREATE TABLE Weight (
        CompanyID integer REFERENCES Company,
        SOURCE text,
        SECTOR text, --Presumably the Name of the Sector, should this be SectorID?  a FK?
        INDUSTRY text, --Presumably the Name of the Industry, should this be SectorID?  a FK?
        Weight integer,
        DATA text
);

