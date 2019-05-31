import os
import sys
import logging
import rds_config
import psycopg2
from urllib.parse import unquote
from psycopg2.extras import RealDictCursor
import json

# rds settings
rds_host = os.getenv('rds_host') or rds_config.rds_host
name = os.getenv('db_username') or rds_config.db_username
password = os.getenv('db_password') or rds_config.db_password
db_name = os.getenv('db_name') or rds_config.db_name

# logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# connect using creds from rds_config.py
try:
    conn = psycopg2.connect( host=rds_host,user=name,password=password,dbname=db_name)
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
WHERE LOWER(cl.Name) = LOWER('{}')
'''

# executes upon API event
def lambda_handler(event, context):
    company = unquote(event['path'].split('/')[2])
    logger.info("Getting company details for " + company)
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        query=template.format(company)
        logger.info("About to execute " + query)
        cur.execute(query)
        return {
            'statusCode': 200,
            'headers': { 'Content-Type': 'application/json',
                         'Access-Control-Allow-Origin': '*' },
            'body': json.dumps(cur.fetchall(), indent=2)
        }
