import boto
import boto.s3
import sys
from boto.s3.key import Key

AWS_ACCESS_KEY_ID = 'AKIAVO5KNXW5MLTJ2JOS' 
AWS_SECRET_ACCESS_KEY = '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'

bucket_name = 'gh-mdas-data-1' 

conn = boto.connect_s3(AWS_ACCESS_KEY_ID,
        AWS_SECRET_ACCESS_KEY)

bucket = conn.create_bucket(bucket_name,
    location=boto.s3.connection.Location.DEFAULT)

testfile = 'cikVectorsExample1.csv'

print ('Uploading %s to Amazon S3 bucket %s' % \
   (testfile, bucket_name))

def percent_cb(complete, total):
    sys.stdout.write('.')
    sys.stdout.flush()


k = Key(bucket,srcFileName)
k.key = 'Vectors from Doc2Vec'
k.set_contents_from_filename(testfile,
    cb=percent_cb, num_cb=10)




