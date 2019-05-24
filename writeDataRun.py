import boto3

keyId = 'AKIAVO5KNXW5MLTJ2JOS'
secretId = 'xUJmbLt+sRYTAcKJmsQE3D2r5Z2K1NbYBOit5lHX' 
bucketName = 'at-mdas-data'


s3 = boto3.resource('s3',\
        aws_access_key_id=keyId,\
        aws_secret_access_key=secretId)

BUCKET = bucketName

inFiles=['sector_industry.csv','competitor_similarity.csv','doc_cossim_industry.csv','doc_cossim_sector.csv','sector_words.csv','industry_words.csv','cleaned_data_agg.csv']
outFiles=['company_sector_industry.csv','competitors.csv','industry_weights.csv','sector_weights.csv','sector_words.csv','industry_words.csv','cleaned_data_agg.csv']

for i in range(0,len(inFiles)):
    s3.Bucket(BUCKET).upload_file(inFiles[i], 'Output-For-ETL/WikiOnly/'+outFiles[i])

