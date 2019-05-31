resource "aws_s3_bucket" "at_website" {
  bucket = "at-mdas-website-terraform"
  acl    = "public-read"
  
  tags = {
    Name        = "AT Website Bucket"
    Environment = "dt"
  }
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
  force_destroy = true
}

resource "aws_s3_bucket" "at_data" {
  bucket = "at-mdas-data-terraform"
  acl    = "private"
  
  tags = {
    Name        = "AT Data Bucket"
    Environment = "dt"
  }
}

resource "aws_s3_bucket" "glue_script" {
  bucket = "aws-glue-scripts-terraform"
  acl    = "private"
  
  tags = {
    Name        = "AT AWS Glue Scripts"
    Environment = "dt"
  }
}

resource "aws_s3_bucket_public_access_block" "at_website" {
  bucket = "${aws_s3_bucket.at_website.id}"

  block_public_acls   = false
  block_public_policy = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_public_access_block" "at_data" {
  bucket = "${aws_s3_bucket.at_data.id}"

  block_public_acls   = true
  block_public_policy = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "glue_script" {
  bucket = "${aws_s3_bucket.glue_script.id}"

  block_public_acls   = true
  block_public_policy = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "at_website" {
  bucket = "${aws_s3_bucket.at_website.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "${aws_s3_bucket.at_website.bucket}_policy",
  "Statement": [
    {
        "Principal": "*",
        "Sid": "ListObjectsInBucket",
        "Effect": "Allow",
        "Action": ["s3:ListBucket"],
        "Resource": ["arn:aws:s3:::${aws_s3_bucket.at_website.id}"]
    },
    {
        "Principal": "*",
        "Sid": "AllObjectActions",
        "Effect": "Allow",
        "Action": "s3:*Object",
        "Resource": ["arn:aws:s3:::${aws_s3_bucket.at_website.id}/*"]
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_policy" "at_data" {
  bucket = "${aws_s3_bucket.at_data.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "${aws_s3_bucket.at_data.bucket}_policy",
  "Statement": [
    {
        "Principal": "*",
        "Sid": "ListObjectsInBucket",
        "Effect": "Allow",
        "Action": ["s3:ListBucket"],
        "Resource": ["arn:aws:s3:::${aws_s3_bucket.at_data.id}"]
    },
    {
        "Principal": "*",
        "Sid": "AllObjectActions",
        "Effect": "Allow",
        "Action": "s3:*Object",
        "Resource": ["arn:aws:s3:::${aws_s3_bucket.at_data.id}/*"]
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_policy" "glue_script" {
  bucket = "${aws_s3_bucket.glue_script.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "${aws_s3_bucket.glue_script.bucket}_policy",
  "Statement": [
    {
        "Principal": "*",
        "Sid": "ListObjectsInBucket",
        "Effect": "Allow",
        "Action": ["s3:ListBucket"],
        "Resource": ["arn:aws:s3:::${aws_s3_bucket.glue_script.id}"]
    },
    {
        "Principal": "*",
        "Sid": "AllObjectActions",
        "Effect": "Allow",
        "Action": "s3:*Object",
        "Resource": ["arn:aws:s3:::${aws_s3_bucket.glue_script.id}/*"]
    }
  ]
}
POLICY
}
