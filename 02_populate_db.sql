-----------------------------------------------------------------------------------------
-- Populate the seed data, clean it and propagate to the appropriate tables in our schema
-----------------------------------------------------------------------------------------

-- First, the DLL for the temporary tables we will use to stage and clean the raw seed data
CREATE TEMPORARY TABLE t_Companylist (
    symbol text NULL,
    "name" text NULL,
    lastsale text NULL,
    marketcap text NULL,
    ipoyear text NULL,
    sector text NULL,
    industry text NULL,
    summary_quote text NULL,
    cik text NULL
) ON COMMIT DROP;

CREATE TEMPORARY TABLE t_MarketCap (
    CompanyID integer NOT NULL,
    MarketCap money
) ON COMMIT DROP;

-- Read in the raw seed data
\copy t_CompanyList from companylist.csv delimiter ',' csv header

-- Name the core of what we are calling a company so we are making it unique and adjusting everything else to match
-- There is no informed choice to make when a company has multiple Sector/Industry designations so we'll just pick one now
INSERT INTO Company (Name, NasdaqSector, NasdaqIndustry)
SELECT DISTINCT ON (Name) Name, Sector, Industry
FROM t_CompanyList
ORDER BY name, sector NULLS LAST, industry NULLS LAST;

-- Create a crosswalk of companies to all associated CIK numbers; to be used when filling in data collected per CIK
INSERT INTO CIK (CompanyID, CIK)
SELECT Company.CompanyID, CAST(t_CompanyList.CIK AS integer)
FROM Company INNER JOIN t_CompanyList ON Company.Name = t_CompanyList.Name WHERE t_CompanyList.CIK <> '';

-- Create a crosswalk of companies to all ticker symbols; used when filling in data collected per ticker symbol
INSERT INTO Ticker (CompanyID, Ticker)
SELECT Company.CompanyID, t_CompanyList.Symbol
FROM Company INNER JOIN t_CompanyList ON Company.Name = t_CompanyList.Name;

-- Also give the GUI a friendly single ticker by choosing the symbol most likely assocaiated with the company itself rather than a special stock class
UPDATE Company
SET Ticker = shortest.Ticker
FROM (SELECT DISTINCT ON (CompanyID) CompanyID, Ticker
      FROM Ticker
      ORDER BY CompanyID, Length(Ticker), Ticker) shortest
WHERE Company.CompanyID = shortest.CompanyID;

-- Create a crosswalk of companies to all associated market caps; translate Million and Billion abbreviations and leave 'n/a' values behind
INSERT INTO t_MarketCap (CompanyID, MarketCap)
SELECT Company.CompanyID
      ,CASE
           WHEN right(marketcap,1) = 'M' THEN cast(rtrim(marketcap,'M') AS money) * 1000000
           WHEN right(marketcap,1) = 'B' THEN cast(rtrim(marketcap,'B') AS money) * 1000000000
           ELSE cast(marketcap AS money)
       END
FROM Company INNER JOIN t_CompanyList ON Company.Name = t_CompanyList.Name WHERE marketcap <> 'n/a';

-- Now assign each Company an initial 10YrMarketCap value based on the sum of the MarketCaps of all its ticker symbols
UPDATE Company
SET "10YrMarketCap" = total.MarketCap
FROM (SELECT CompanyID, sum(marketcap) MarketCap
      FROM t_MarketCap 
      GROUP BY CompanyID) total
WHERE Company.CompanyID = total.CompanyID;
