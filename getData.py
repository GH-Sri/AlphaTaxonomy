import boto
from boto.s3.key import Key

keyId = 'AKIAVO5KNXW5MLTJ2JOS'
sKeyID='xUJmbLt+sRYTAcKJmsQE3D2r5Z2K1NbYBOit5lHX'
srcFileName='10K-Raw-Data/BDData.csv'
destFileName='data.csv'
bucketName='at-mdas-data'

conn=boto.connect_s3(keyId,sKeyID)
#conn.get_all_buckets()
bucket=conn.get_bucket(bucketName)
k=Key(bucket,srcFileName)
k.get_contents_to_filename(destFileName)
