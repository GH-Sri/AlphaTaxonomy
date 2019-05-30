import sys
import logging
import rds_config
import psycopg2
from urllib.parse import unquote
from psycopg2.extras import RealDictCursor
import json

# rds settings
rds_host  = return os.environ['rds_host'] or rds_config.rds_host
name = return os.environ['db_username'] or rds_config.db_username
password = return os.environ['db_password'] or rds_config.db_password
db_name = return os.environ['db_name'] or rds_config.db_name

# logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# connect using creds from rds_config.py
try:
    conn = psycopg2.connect(host=rds_host,user=name,password=password,dbname=db_name)
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
WHERE 1 = 1{}{}
ORDER BY {} {}
OFFSET {}
LIMIT {}
'''

# executes upon API event
def lambda_handler(event, context):
    logger.info('event is' + json.dumps(event))

    qsp = event.get('queryStringParameters',{}) or {}
    logger.info('qsp is' + json.dumps(qsp))
    # Apply filters for Sector or Industry if passed on query string
    if 'sector' in qsp: 
        swc = " AND COALESCE(sname.name, 'Sector ' || csi.sector) = '{}'".format(qsp.get('sector')) 
    else: swc = ''
    if 'industry' in qsp: 
        iwc = " AND COALESCE(iname.name, 'Industry ' || csi.industry) = '{}'".format(qsp.get('industry')) 
    else: iwc = ''
    
    # Apply sort key and direction if passed in query string
    order = qsp.get('sort',1)
    direction = qsp.get('sortdir','ASC')
    
    # Apply offset/limit retrieval window if passed in query string
    offset = qsp.get('offset',0)
    limit = qsp.get('limit','ALL')
    
    logger.info("Getting company list")
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        query=template.format(swc,iwc,order,direction,offset,limit)
        logger.info("About to execute " + query)
        conn.rollback()
        cur.execute(query)
        conn.commit()
        return {
            'statusCode': 200,
            'headers': { 'Content-Type': 'application/json',
                         'Access-Control-Allow-Origin': '*' },
            'body': json.dumps(cur.fetchall(), indent=2)
        }
