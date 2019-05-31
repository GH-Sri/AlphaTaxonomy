def getData(keyId='AKIAVO5KNXW5MLTJ2JOS',\
            sKeyID='xUJmbLt+sRYTAcKJmsQE3D2r5Z2K1NbYBOit5lHX',\
            srcFileName='Output-For-ETL/AllWikipediaData.csv',destFileName='wiki.csv',\
            bucketName='at-mdas-data'):
    
    import boto
    from boto.s3.key import Key
    
    conn=boto.connect_s3(keyId,sKeyID)
    bucket=conn.get_bucket(bucketName)
    
    k=Key(bucket,srcFileName)
    
    k.get_contents_to_filename(destFileName)

#getData(srcFileName='10K-Raw-Data/company_10k_per_year_out.csv',bucketName='at-mdas-data',destFileName='2018data.csv')

getData()
