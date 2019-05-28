-- Create the database
--CREATE DATABASE mdas;

-- Connect to the new DB (rather than Public)
\c mdas

-- Create the schema and make it the default
CREATE SCHEMA mdas AUTHORIZATION mdas;
SET search_path TO mdas;

-- Table for raw seed data, no constraints
CREATE TABLE Companylist (
    symbol text,
    "name" text,
    lastsale text,
    marketcap text,
    adrtso text,
    ipoyear text,
    sector text,
    industry text,
    summary_quote text,
    exchange text,
    cik text
);


CREATE TABLE Sector (
        Number integer not null,
        Name text PRIMARY KEY,
        IndustryCount integer,
        CompanyCount integer,
        MarketCap money,
        Perf10Yr integer,
        SectorWeight integer
);

CREATE FUNCTION default_sector_name() RETURNS TRIGGER AS $$
BEGIN
	IF NEW.Name IS NULL THEN New.Name := 'Sector ' || New.Number;
        END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER default_sector_name_trg BEFORE INSERT ON Sector FOR EACH ROW EXECUTE PROCEDURE default_sector_name();

CREATE TABLE Industry (
        Number integer not null,
        Name text PRIMARY KEY,
        Sector text REFERENCES Sector(Name),
	CompanyCount integer,
        MarketCap money,
        Perf10Yr integer,
        IndustryWeight integer
);

CREATE FUNCTION default_industry_name() RETURNS TRIGGER AS $$
BEGIN
        IF NEW.Name IS NULL THEN New.Name := 'Industry ' || New.Number;
        END IF;
        RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER default_industry_name_trg BEFORE INSERT ON Industry FOR EACH ROW EXECUTE PROCEDURE default_industry_name();

CREATE TABLE Company (
        Sector text REFERENCES Sector(Name),
        Industry text REFERENCES Industry(Name),
        LegacySector text,
        LegacyIndustry text,
        Name text PRIMARY KEY,
        Ticker text,
        Logo bytea,
	MarketCap money,
        EPS10Yr money,
        Perf10Yr integer,
        PerfVsSector10Yr integer,
        PerfVsIndustry10Yr integer,
        PerfVsLegacySector10Yr integer,
        PerfVsLegacyIndustry10Yr integer
);
COMMENT ON COLUMN Company.Ticker IS 'The single ticker symbol most likely recognizable as referring to the company as a whole';
COMMENT ON COLUMN Company.MarketCap IS 'The sum of MarketCaps of all ticker symbols this company has.';

CREATE TABLE Ticker (
        Company text REFERENCES Company(Name),
        Ticker text NOT NULL,
	Exchange text
);

CREATE TABLE CIK (
        Company text REFERENCES Company(Name),
        CIK integer NOT NULL
);

CREATE TABLE Competitor (
        Company text REFERENCES Company(Name),
        Competitor text REFERENCES Company(Name),
        Closeness integer NOT NULL
);

CREATE TABLE Performance (
        Company text REFERENCES Company(Name),
        year integer,
        MarketCap money,
        EPS money,
        Perf integer,
        PerfVsSector integer,
        PerfVsIndustry integer,
        PerfVsLegacySector integer,
        PerfVsLegacyIndustry integer
);

CREATE TABLE Weight (
        Company text REFERENCES Company(Name),
        Source text,
        Sector text REFERENCES Sector(Name),
        Industry text REFERENCES Industry(Name),
        Weight integer,
        Data text
);
