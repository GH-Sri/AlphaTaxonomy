-- Fill in all details we can with the Company_Sector_Industry analytic output

INSERT INTO sector (Number) SELECT DISTINCT Sector FROM csv_company_sector_industry_10k;

UPDATE Sector SET industrycount = ic
FROM (SELECT count(DISTINCT(industry)) ic, sector 
      FROM csv_company_sector_industry_10k 
      GROUP BY sector) x
WHERE Sector.number = x.sector;

INSERT INTO Industry (Number) SELECT DISTINCT Industry FROM csv_company_sector_industry_10k;

UPDATE Industry SET Sector = secname
FROM (SELECT industry, sector.name secname 
      FROM csv_company_sector_industry_10k csi 
      JOIN Sector ON csi.sector = sector.number
      GROUP BY industry, sector.name) x
WHERE Industry.Number = x.industry;

UPDATE company SET sector = s.name, industry = i.name
FROM csv_company_sector_industry_10k csi, sector s, industry i
WHERE csi.sector = s.number
  AND csi.industry = i.number
  AND csi.name = company.name;

UPDATE Industry SET companycount = cc, marketcap = tmc
FROM (SELECT Count(*) cc, Sum(MarketCap) tmc, industry
      FROM company
      GROUP BY Industry) x
WHERE Industry.name = x.industry;

UPDATE Sector SET companycount = cc, marketcap = tmc
FROM (SELECT Count(*) cc, Sum(MarketCap) tmc, sector
      FROM company
      GROUP BY sector) x
WHERE sector.name = x.sector;

-- Load the competitors

INSERT INTO Competitor (Company, Competitor, Closeness)
SELECT Name, "competitor name", Similarity
FROM CSV_Competitors_10k;

-- This looks a bit strange but we'll insert these again with the companies reversed.
-- Only one direction was calculated because it would be the same calculation going
-- the other way.  However, we want to be able to quckly get the complete set without
-- running two queries and tranforming the output so we'll just load them both ways.

INSERT INTO Competitor (Company, Competitor, Closeness)
SELECT "competitor name", Name, Similarity
FROM CSV_Competitors_10k;



