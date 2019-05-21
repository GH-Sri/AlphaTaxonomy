-----------------------------------------------------------------------------------------
-- Populate the seed data, clean it and propagate to the appropriate tables in our schema
-----------------------------------------------------------------------------------------

-- Read in the raw seed data
\copy CompanyList from companylist.csv delimiter ',' csv header

UPDATE CompanyList SET Name = trim(Name);

-- Name the core of what we are calling a company so we are making it unique and adjusting everything else to match
-- There is no informed choice to make when a company has multiple Sector/Industry designations so we'll just pick one now
INSERT INTO Company (Name, LegacySector, LegacyIndustry)
SELECT DISTINCT ON (Name) Name, Sector, Industry
FROM CompanyList
ORDER BY name, sector NULLS LAST, industry NULLS LAST;

-- Create a crosswalk of companies to all associated CIK numbers; to be used when filling in data collected per CIK
INSERT INTO CIK (Company, CIK)
SELECT Name, CAST(CIK AS integer)
FROM CompanyList WHERE CompanyList.CIK <> '';

-- Create a crosswalk of companies to all ticker symbols; used when filling in data collected per ticker symbol
INSERT INTO Ticker (Company, Ticker, Exchange)
SELECT Name, Symbol, Exchange
FROM CompanyList;

-- Also give the GUI a friendly single ticker by choosing the symbol most likely assocaiated with the company itself rather than a special stock class
UPDATE Company
SET Ticker = shortest.Ticker
FROM (SELECT DISTINCT ON (Company) Company, Ticker
      FROM Ticker
      ORDER BY Company, Length(Ticker), Ticker) shortest
WHERE Company.Name = shortest.Company;

-- Create a crosswalk of companies to all associated market caps; translate Million and Billion abbreviations and leave 'n/a' values behind
CREATE TEMPORARY TABLE t_MarketCap (
    Company text NOT NULL,
    MarketCap money
) ON COMMIT DROP;

INSERT INTO t_MarketCap (Company, MarketCap)
SELECT Name
      ,CASE
           WHEN right(marketcap,1) = 'M' THEN cast(rtrim(marketcap,'M') AS money) * 1000000
           WHEN right(marketcap,1) = 'B' THEN cast(rtrim(marketcap,'B') AS money) * 1000000000
           ELSE cast(marketcap AS money)
       END
FROM CompanyList WHERE marketcap <> 'n/a';

-- Now assign each Company a MarketCap value based on the sum of the MarketCaps of all its ticker symbols
UPDATE Company
SET MarketCap = total.MarketCap
FROM (SELECT Company, sum(MarketCap) MarketCap
      FROM t_MarketCap 
      GROUP BY Company) total
WHERE Company.Name = total.Company;
