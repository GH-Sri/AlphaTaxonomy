import boto
from boto.s3.key import Key

keyId = 'AKIAVO5KNXW5MLTJ2JOS'
sKeyID = 'xUJmbLt+sRYTAcKJmsQE3D2r5Z2K1NbYBOit5lHX'
bucketName='gh-mdas-data-1'

conn=boto.connect_s3(keyId,sKeyID)
bucket=conn.get_bucket(bucketName)

for key in bucket.list():
    print(key)
