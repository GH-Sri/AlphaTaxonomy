INSERT INTO sector (Number, industrycount)
SELECT sector, count(DISTINCT(industry)) 
FROM csv_company_sector_industry
GROUP BY Sector;

INSERT INTO Industry (Number, sector)
SELECT csi.industry, sector.name
FROM (SELECT industry, sector FROM csv_company_sector_industry GROUP BY industry, sector) csi
JOIN Sector ON csi.sector = sector.number;

UPDATE company SET sector = s.name, industry = i.name
FROM csv_company_sector_industry csi, sector s, industry i
WHERE csi.sector = s.number
  AND csi.industry = i.number
  AND csi.name = company.name
  AND csi.SOURCE = 'WIKI';
 
UPDATE company SET sector = s.name, industry = i.name
FROM csv_company_sector_industry csi, sector s, industry i
WHERE csi.sector = s.number
  AND csi.industry = i.number
  AND csi.name = company.name
  AND csi.SOURCE = 'WEB';
 
UPDATE company SET sector = s.name, industry = i.name
FROM csv_company_sector_industry csi, sector s, industry i
WHERE csi.sector = s.number
  AND csi.industry = i.number
  AND csi.name = company.name
  AND csi.SOURCE = '10K';

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


