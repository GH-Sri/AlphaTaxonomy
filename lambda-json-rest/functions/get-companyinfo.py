import sys
import logging
import rds_config
import psycopg2
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

# executes upon API event
def handler(event, context):
#    company = event['Company']
#    with conn.cursor(cursor_factory=RealDictCursor) as cur:
#        cur.execute("SELECT * FROM Company ORDER BY RANDOM() LIMIT 10")
#        conn.commit()
#        return {
#            'statusCode': 200,
#            'headers': { 'Content-Type': 'application/json' },
#            'body': json.dumps(cur.fetchall(), indent=2)
#        }

    return {
    'statusCode': 200,
    'headers': { 'Content-Type': 'application/json' },
    'body': json.dumps(event['pathParameters'], indent=2)
}
