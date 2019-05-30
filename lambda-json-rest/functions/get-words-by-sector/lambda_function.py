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
    conn = psycopg2.connect( host=rds_host,user=name,password=password,dbname=db_name)
except:
    logger.error("ERROR: Unexpected error: Could not connect to PostgreSQL instance.")
    sys.exit()
logger.info("SUCCESS: Connection to RDS PostgreSQL instance succeeded")

# SQL to get what this function is responsible for returning
template = '''
SELECT sw.word, sw.similarity
FROM sector_words_csv sw
LEFT OUTER JOIN Sector_Name_CSV sname ON sname.number = sw.Sector
WHERE LOWER(COALESCE(sname.name, 'sector ' || sw.sector)) = LOWER('{}')
ORDER BY sw.similarity DESC
'''

# executes upon API event
def lambda_handler(event, context):
    sector = unquote(event['path'].split('/')[2])
    logger.info("Getting words for " + sector)
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        query=template.format(sector)
        logger.info("About to execute " + query)
        cur.execute(query)
        conn.commit()
        return {
            'statusCode': 200,
            'headers': { 'Content-Type': 'application/json',
                         'Access-Control-Allow-Origin': '*' },
            'body': json.dumps(cur.fetchall(), indent=2)
        }
