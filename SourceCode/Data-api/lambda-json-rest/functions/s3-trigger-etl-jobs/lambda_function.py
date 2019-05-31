import logging
import boto3

# logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

glue = boto3.client('glue')

def lambda_handler(event, context):

    # Check each file placed in the key our trigger is watching: Output-For-ETL
    for record in event['Records']:
        new_filename = record['s3']['object']['key'].lstrip('Output-For-ETL/')
    
        # Look through our Glue jobs to see if we have one for this file
        for job in glue.get_jobs()['Jobs']:
            jn = job['Name']
            if jn == new_filename:
                # If we do, run it
                glue.start_job_run(JobName = jn)
                logger.info('Started ETL job:' + jn)

#TODO handle what happens if the job is already running

    return

