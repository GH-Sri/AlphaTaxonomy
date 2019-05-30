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
SELECT Competitor, sym_shortest.Symbol, mc_total.MarketCap, Similarity
FROM (SELECT Name AS Company, "competitor name" AS Competitor, Similarity FROM competitors_csv UNION ALL
      SELECT "competitor name" AS Company, Name AS competitor, Similarity FROM competitors_csv) competitor
JOIN (SELECT DISTINCT ON (Name) Name, Symbol 
      FROM CompanyList_csv
      ORDER BY Name, Length(Symbol), Symbol) sym_shortest
  ON sym_shortest.name = Competitor.Competitor
JOIN (SELECT Name, sum(marketcap::NUMERIC::money) AS MarketCap
      FROM CompanyList_csv
      GROUP BY name) mc_total
  ON mc_total.name = Competitor.Competitor
WHERE LOWER(Competitor.Company) = LOWER('{}')
ORDER BY similarity DESC
LIMIT 10
'''

# executes upon API event
def lambda_handler(event, context):
    company = unquote(event['path'].split('/')[2])
    logger.info("Getting competitor details for " + company)
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
