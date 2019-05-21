
resource "aws_s3_bucket" "data_bucket" {
  bucket = "gh-mdas-data"
  acl    = "private"
  
  tags = {
    Name        = "MDAS Data Bucket"
    Environment = "dt"
  }
}


resource "aws_s3_bucket" "data_bucket_1" {
  bucket = "gh-mdas-data-1"
  acl    = "private"
  
  tags = {
    Name        = "MDAS Data Bucket 1"
    Environment = "dt"
  }
}

resource "aws_s3_bucket" "data_bucket_2" {
  bucket = "gh-mdas-data-2"
  acl    = "private"
  
  tags = {
    Name        = "MDAS Data Bucket 2"
    Environment = "dt"
  }
}


resource "aws_s3_bucket_public_access_block" "data_bucket" {
  bucket = "${aws_s3_bucket.data_bucket.id}"

  block_public_acls   = true
  block_public_policy = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_public_access_block" "data_bucket_1" {
  bucket = "${aws_s3_bucket.data_bucket_1.id}"

  block_public_acls   = true
  block_public_policy = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_public_access_block" "data_bucket_2" {
  bucket = "${aws_s3_bucket.data_bucket_2.id}"

  block_public_acls   = true
  block_public_policy = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "data_bucket" {
  bucket = "${aws_s3_bucket.data_bucket.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "data-bucket-policy",
  "Statement": [
    {
        "Principal": "*",
        "Sid": "ListObjectsInBucket",
        "Effect": "Allow",
        "Action": ["s3:ListBucket"],
        "Resource": ["arn:aws:s3:::${aws_s3_bucket.data_bucket.id}"]
    },
    {
        "Principal": "*",
        "Sid": "AllObjectActions",
        "Effect": "Allow",
        "Action": "s3:*Object",
        "Resource": ["arn:aws:s3:::${aws_s3_bucket.data_bucket.id}/*"]
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_policy" "data_bucket_1" {
  bucket = "${aws_s3_bucket.data_bucket_1.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "data-bucket-1-policy",
  "Statement": [
    {
        "Principal": "*",
        "Sid": "ListObjectsInBucket",
        "Effect": "Allow",
        "Action": ["s3:ListBucket"],
        "Resource": ["arn:aws:s3:::${aws_s3_bucket.data_bucket_1.id}"]
    },
    {
        "Principal": "*",
        "Sid": "AllObjectActions",
        "Effect": "Allow",
        "Action": "s3:*Object",
        "Resource": ["arn:aws:s3:::${aws_s3_bucket.data_bucket_1.id}/*"]
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_policy" "data_bucket_2" {
  bucket = "${aws_s3_bucket.data_bucket_2.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "data-bucket-2-policy",
  "Statement": [
    {
        "Principal": "*",
        "Sid": "ListObjectsInBucket",
        "Effect": "Allow",
        "Action": ["s3:ListBucket"],
        "Resource": ["arn:aws:s3:::${aws_s3_bucket.data_bucket_2.id}"]
    },
    {
        "Principal": "*",
        "Sid": "AllObjectActions",
        "Effect": "Allow",
        "Action": "s3:*Object",
        "Resource": ["arn:aws:s3:::${aws_s3_bucket.data_bucket_2.id}/*"]
    }
  ]
}
POLICY
}