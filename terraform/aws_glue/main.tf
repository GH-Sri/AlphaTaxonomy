resource "aws_glue_catalog_database" "mdas" {
  name = "mdas"
}

resource "aws_glue_crawler" "MDASCompany" {
  database_name = "${aws_glue_catalog_database.mdas.name}"
  name          = "MDASCompany"
  role          = "${aws_iam_role.glue.arn}"

  jdbc_target {
    connection_name = "${aws_glue_connection.mdas.name}"
    path            = "database-name/%"
  }
}

resource "aws_glue_connection" "mdas" {
  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:mysql://${aws_db_instance.glue_db.address}/${aws_db_instance.glue_db.name}"
    PASSWORD            = "${aws_db_instance.glue_db.username}"
    USERNAME            = "${aws_db_instance.glue_db.password}"
  }
  name = "mdas"
}

data "template_file" "glue_script" {
  //TODO: figure out how to best add scripts from other git repos
  template = "${file("${path.module}/glue-scripts/script.scala.tmpl")}"
  vars = {
    bucket = "${aws_s3_bucket.data_bucket_4.bucket}"
    source_table_name = "${aws_glue_catalog_table.aws_glue_item_raw.name}"
    database_name = "${aws_glue_catalog_database.glue_db.name}"
  }
}

resource "local_file" "glue_script" {
  content = "${data.template_file.glue_script.rendered}"
  filename = "${path.module}/glue-scripts/script.scala"
}

resource "aws_s3_bucket_object" "glue_script" {
  depends_on = ["local_file.glue_script"]
  bucket = "${aws_s3_bucket.data_bucket.bucket}"
  key = "glue-script.scala"
  source = "${local_file.glue_script.filename}"
  etag = "${md5(local_file.glue_script.content)}"
}

resource "aws_iam_role" "glue" {
  name = "AWSGlueServiceRoleDefault"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "admin_policy" {
  name = "GlueServiceRolePolicy"
  role = "${aws_iam_role.glue.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "glue:*",
                "s3:GetBucketLocation",
                "s3:ListBucket",
                "s3:ListAllMyBuckets",
                "s3:GetBucketAcl",
                "ec2:DescribeVpcEndpoints",
                "ec2:DescribeRouteTables",
                "ec2:CreateNetworkInterface",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcAttribute",
                "iam:ListRolePolicies",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "cloudwatch:PutMetricData"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:CreateBucket"
            ],
            "Resource": [
                "arn:aws:s3:::aws-glue-*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::aws-glue-*/*",
                "arn:aws:s3:::*/*aws-glue-*/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::crawler-public*",
                "arn:aws:s3:::aws-glue-*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:AssociateKmsKey"
            ],
            "Resource": [
                "arn:aws:logs:*:*:/aws-glue/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags",
                "ec2:DeleteTags"
            ],
            "Condition": {
                "ForAllValues:StringEquals": {
                    "aws:TagKeys": [
                        "aws-glue-service-resource"
                    ]
                }
            },
            "Resource": [
                "arn:aws:ec2:*:*:network-interface/*",
                "arn:aws:ec2:*:*:security-group/*",
                "arn:aws:ec2:*:*:instance/*"
            ]
        }
    ]
}
EOF
}

resource "aws_glue_job" "example" {
  name     = "dms-sample"
  role_arn = "${aws_iam_role.glue.arn}"

  command {
    script_location = "s3://${aws_s3_bucket_object.glue_script.bucket}/${aws_s3_bucket_object.glue_script.key}"
  }

  default_arguments = {
    "--job-language" = "scala"
    "--class" = "GlueApp"
    "--job-bookmark-option" = "job-bookmark-enable"
  }
}
