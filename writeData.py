import boto3

keyId = 'AKIAVO5KNXW5MLTJ2JOS'
secretId = 'xUJmbLt+sRYTAcKJmsQE3D2r5Z2K1NbYBOit5lHX' 
bucketName = 'at-mdas-data'


s3 = boto3.resource('s3',\
        aws_access_key_id=keyId,\
        aws_secret_access_key=secretId)

BUCKET = bucketName

inFile = input('Name of local file: ')
outFile = input('Name of file in s3 bucket: ')

s3.Bucket(BUCKET).upload_file(inFile, outFile)
