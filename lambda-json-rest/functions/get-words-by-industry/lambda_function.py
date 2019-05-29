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
    conn = psycopg2.connect( host=rds_host,user=name,password=password,dbname=db_name)
except:
    logger.error("ERROR: Unexpected error: Could not connect to PostgreSQL instance.")
    sys.exit()
logger.info("SUCCESS: Connection to RDS PostgreSQL instance succeeded")

# SQL to get what this function is responsible for returning
template = '''
SELECT iw.word, iw.similarity
FROM industry_words_csv iw
LEFT OUTER JOIN Industry_Name_CSV iname ON iname.number = iw.industry
WHERE LOWER(COALESCE(iname.name, 'industry ' || iw.industry)) = LOWER('{}')
ORDER BY iw.similarity DESC;
'''

# executes upon API event
def lambda_handler(event, context):
    industry = unquote(event['path'].split('/')[2])
    logger.info("Getting words for " + industry)
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        query=template.format(industry)
        logger.info("About to execute " + query)
        cur.execute(query)
        conn.commit()
        return {
            'statusCode': 200,
            'headers': { 'Content-Type': 'application/json',
                         'Access-Control-Allow-Origin': '*' },
            'body': json.dumps(cur.fetchall(), indent=2)
        }
