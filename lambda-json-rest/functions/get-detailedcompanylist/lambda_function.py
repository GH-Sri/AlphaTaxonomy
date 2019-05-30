import sys
import logging
import rds_config
import psycopg2
from urllib.parse import unquote
from psycopg2.extras import RealDictCursor
import json

# rds settings
rds_host  = "mdas.c33zx3vjrof0.us-east-1.rds.amazonaws.com"
name = rds_config.db_username
password = rds_config.db_password
db_name = rds_config.db_name

# logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# connect using creds from rds_config.py
try:
    conn = psycopg2.connect(host=rds_host,user=name,password=password,dbname=db_name)
    conn.autocommit = True
except:
    logger.error("ERROR: Unexpected error: Could not connect to PostgreSQL instance.")
    sys.exit()
logger.info("SUCCESS: Connection to RDS PostgreSQL instance succeeded")

# SQL to get what this function is responsible for returning
template = '''
SELECT cl.Name
      ,sym_shortest.Symbol
      ,mc_total.MarketCap AS MarketCap
      ,COALESCE(sname.name, 'Sector ' || csi.sector) AS ATSector
      ,COALESCE(iname.name, 'Industry ' || csi.industry) AS ATIndustry
      ,cl.Sector AS LegacySector
      ,cl.Industry AS LegacyIndustry
      ,(array_agg(ARRAY[COALESCE(sname2.name, 'Sector ' || sw.sector), TO_CHAR(GREATEST(0,sw.Similarity)*100,'FM999999999.00%')] ORDER BY sw.Similarity DESC))[1:5] AS closestSectors
      ,(array_agg(ARRAY[COALESCE(iname2.name, 'Industry ' || iw.industry),TO_CHAR(GREATEST(0,iw.Similarity)*100,'FM999999999.00%')] ORDER BY iw.Similarity DESC))[1:5] AS closestIndustries
--      ,(array_agg(ARRAY[competitor.competitor,competitor.Similarity::text] ORDER BY competitor.Similarity DESC))[1:5] AS closestCompetitors
FROM (SELECT DISTINCT ON (Name) Name, Sector, Industry
      FROM companylist_csv
      GROUP BY Name, Sector, Industry) cl
JOIN (SELECT DISTINCT ON (Name) Name, Symbol
      FROM CompanyList_csv
      ORDER BY Name, Length(Symbol), Symbol) sym_shortest
  ON sym_shortest.name = cl.name
JOIN (SELECT Name, sum(marketcap::NUMERIC::money) AS MarketCap
      FROM CompanyList_csv
      GROUP BY name) mc_total
  ON mc_total.name = cl.name
LEFT OUTER JOIN (SELECT DISTINCT ON (name) name, sector, industry
      FROM company_sector_industry_csv) csi
  ON csi.name = cl.name
LEFT OUTER JOIN Sector_Name_CSV sname ON sname.number = csi.sector
LEFT OUTER JOIN Industry_Name_CSV iname ON iname.number = csi.industry
JOIN sector_weights_csv sw
  ON sw.name = cl.name
LEFT OUTER JOIN Sector_Name_CSV sname2 ON sname2.number = sw.sector
JOIN industry_weights_csv iw
  ON iw.name = cl.name
LEFT OUTER JOIN Industry_Name_CSV iname2 ON iname2.number = iw.industry
--JOIN (SELECT Name AS Company, "competitor name" AS Competitor, Similarity FROM competitors_csv UNION ALL
--      SELECT "competitor name" AS Company, Name AS competitor, Similarity FROM competitors_csv) competitor
--  ON Competitor.Company = cl.name
WHERE 1 = 1{}{}{}
GROUP BY cl.Name, sym_shortest.Symbol, mc_total.MarketCap
        ,COALESCE(sname.name, 'Sector ' || csi.sector)
        ,COALESCE(iname.name, 'Industry ' || csi.industry)
        ,cl.Sector, cl.Industry
ORDER BY {} {}
OFFSET {}
LIMIT {}
'''

# executes upon API event
def lambda_handler(event, context):

    # First blank dict is default if event does not contain 'queryStringParameters'
    # Second blank dict is default if event has 'queryStringParameters' but value is null
    qsp = event.get('queryStringParameters',{}) or {}

    # Apply filters for Sector or Industry if passed on query string
    if 'sector' in qsp: 
        swc = " AND COALESCE(sname.name, 'Sector ' || csi.sector) = '{}'".format(qsp.get('sector')) 
    else: swc = ''
    if 'industry' in qsp: 
        iwc = " AND COALESCE(iname.name, 'Industry ' || csi.industry) = '{}'".format(qsp.get('industry')) 
    else: iwc = ''
    if 'company' in qsp: 
        cwc = " AND cl.name = '{}'".format(qsp.get('company')) 
    else: cwc = ''
    
    # Apply sort key and direction if passed in query string
    order = qsp.get('sort',1)
    direction = qsp.get('sortdir','ASC')
    
    # Apply offset/limit retrieval window if passed in query string
    offset = qsp.get('offset',0)
    limit = qsp.get('limit','ALL')
    
    logger.info("Getting company list")
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        query=template.format(swc,iwc,cwc,order,direction,offset,limit)
        logger.info("About to execute " + query)
        cur.execute(query)
        return {
            'statusCode': 200,
            'headers': { 'Content-Type': 'application/json',
                         'Access-Control-Allow-Origin': '*' },
            'body': json.dumps(cur.fetchall(), indent=2)
        }

