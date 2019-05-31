def getData(keyId='AKIAVO5KNXW5MLTJ2JOS',\
            sKeyID='xUJmbLt+sRYTAcKJmsQE3D2r5Z2K1NbYBOit5lHX',\
            srcFileName='BDData.csv',\
            destFileName='C:\\Users\\dmoore002\\r-libraries\\analysisData.csv',\
            bucketName='gh-mdas-data-1'):
    
    import boto
    from boto.s3.key import Key
    
    conn=boto.connect_s3(keyId,sKeyID)
    bucket=conn.get_bucket(bucketName)
    
    k=Key(bucket,srcFileName)
    
    k.get_contents_to_filename(destFileName)



getData()






