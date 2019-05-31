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
SELECT COALESCE(sname.name, 'Sector ' || sw.sector) AS Sector
      ,TO_CHAR(GREATEST(0,Similarity)*100,'FM999999999.00') AS Similarity
FROM sector_weights_csv sw
LEFT OUTER JOIN Sector_Name_CSV sname ON sname.number = sw.sector
WHERE LOWER(sw.name) = LOWER('{}')
ORDER BY Similarity::NUMERIC DESC
'''

# executes upon API event
def lambda_handler(event, context):
    company = unquote(event['path'].split('/')[2])
    logger.info("Getting sector weights for " + company)
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
