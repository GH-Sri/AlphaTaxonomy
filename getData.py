from boto.s3.key import Key

keyId = 'AKIAVO5KNXW5MLTJ2JOS'
sKeyId='xUJmbLt+sRYTAcKJmsQE3D2r5Z2K1NbYBOit5lHX'
srcFileName='BDData.csv'
destFileName='data.csv'
bucketName='gh-mdas-data-1'

conn=boto.connect_s3(keyId,sKeyID)
bucket=conn.get_bucket(bucketName)

k=Key(bucket,srcFileName)

k.get_contents_to_filename(destFileName)


