#Pass in outputs of other modules
variable "glue_script_bucket" {
  type = "string"
}
variable "glue_db_endpoint" {
  type = "string"
}
variable "glue_db_name" {
  type = "string"
}
variable "glue_db_username" {
  type = "string"
}
variable "glue_db_password" {
  type = "string"
}
variable "at_data_bucket" {
  type = "string"
}

resource "aws_glue_catalog_database" "mdas" {
  name = "mdas"
}

#Crawler populates metadata table
resource "aws_glue_crawler" "Output-For-ETL" {
  schedule = "cron(0/5 * * * ? *)"
  database_name = "${aws_glue_catalog_database.mdas.name}"
  name          = "Output-For-ETL"
  role          = "${aws_iam_role.glue.arn}"

  s3_target {
    path            = "s3://${var.at_data_bucket}/Output-For-ETL"
  }
}
resource "aws_glue_crawler" "10K" {
  schedule = "cron(0/5 * * * ? *)"
  database_name = "${aws_glue_catalog_database.mdas.name}"
  name          = "10K"
  role          = "${aws_iam_role.glue.arn}"

  s3_target {
    path            = "s3://${var.at_data_bucket}/Output-For-ETL/10K only"
  }
}
resource "aws_glue_crawler" "Web" {
  schedule = "cron(0/5 * * * ? *)"
  database_name = "${aws_glue_catalog_database.mdas.name}"
  name          = "Web"
  role          = "${aws_iam_role.glue.arn}"

  s3_target {
    path            = "s3://${var.at_data_bucket}/Output-For-ETL/WEB only"
  }
}
resource "aws_glue_crawler" "Wiki" {
  schedule = "cron(0/5 * * * ? *)"
  database_name = "${aws_glue_catalog_database.mdas.name}"
  name          = "Wiki"
  role          = "${aws_iam_role.glue.arn}"

  s3_target {
    path            = "s3://${var.at_data_bucket}/Output-For-ETL/WikiOnly"
  }
}

#Setup connection string, references db in aws_rds/main.tf
resource "aws_glue_connection" "mdas" {
  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:postgresql://${var.glue_db_endpoint}/${var.glue_db_name}"
    PASSWORD            = "${var.glue_db_password}"
    USERNAME            = "${var.glue_db_username}"
  }
  name = "MDASPostgres"
}

#Sets up role used by AWS Glue
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

#Sets up policy for AWSGlueServiceRoleDefault
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

resource "aws_glue_job" "HistoricalStockPriceDataAllExchanges" {
  name     = "HistoricalStockPriceDataAllExchanges.csv"
  role_arn = "${aws_iam_role.glue.arn}"

  command {
    script_location = "s3://${var.glue_script_bucket}/HistoricalStockPriceDataAllExchanges_csv"
  }

  default_arguments = {
    "--job-language" = "python"
    "--class" = "Spark"
    "--job-bookmark-option" = "job-bookmark-enable"
  }
}

resource "aws_glue_job" "company_sector_industry" {
  name     = "company_sector_industry.csv"
  role_arn = "${aws_iam_role.glue.arn}"

  command {
    script_location = "s3://${var.glue_script_bucket}/company_sector_industry_csv"
  }

  default_arguments = {
    "--job-language" = "python"
    "--class" = "Spark"
    "--job-bookmark-option" = "job-bookmark-enable"
  }
}

resource "aws_glue_job" "industry_name" {
  name     = "industry_name.csv"
  role_arn = "${aws_iam_role.glue.arn}"

  command {
    script_location = "s3://${var.glue_script_bucket}/industry_name_csv"
  }

  default_arguments = {
    "--job-language" = "python"
    "--class" = "Spark"
    "--job-bookmark-option" = "job-bookmark-enable"
  }
}

resource "aws_glue_job" "sector_words" {
  name     = "sector_words.csv"
  role_arn = "${aws_iam_role.glue.arn}"

  command {
    script_location = "s3://${var.glue_script_bucket}/sector_words_csv"
  }

  default_arguments = {
    "--job-language" = "python"
    "--class" = "Spark"
    "--job-bookmark-option" = "job-bookmark-enable"
  }
}

resource "aws_glue_job" "companylist" {
  name     = "companylist.csv"
  role_arn = "${aws_iam_role.glue.arn}"

  command {
    script_location = "s3://${var.glue_script_bucket}/companylist_csv"
  }

  default_arguments = {
    "--job-language" = "python"
    "--class" = "Spark"
    "--job-bookmark-option" = "job-bookmark-enable"
  }
}

resource "aws_glue_job" "industry_weights" {
  name     = "industry_weights.csv"
  role_arn = "${aws_iam_role.glue.arn}"

  command {
    script_location = "s3://${var.glue_script_bucket}/industry_weights_csv"
  }

  default_arguments = {
    "--job-language" = "python"
    "--class" = "Spark"
    "--job-bookmark-option" = "job-bookmark-enable"
  }
}

resource "aws_glue_job" "sector_name" {
  name     = "sector_name.csv"
  role_arn = "${aws_iam_role.glue.arn}"

  command {
    script_location = "s3://${var.glue_script_bucket}/sector_name_csv"
  }

  default_arguments = {
    "--job-language" = "python"
    "--class" = "Spark"
    "--job-bookmark-option" = "job-bookmark-enable"
  }
}

resource "aws_glue_job" "cleaned_data_agg" {
  name     = "cleaned_data_agg.csv"
  role_arn = "${aws_iam_role.glue.arn}"

  command {
    script_location = "s3://${var.glue_script_bucket}/cleaned_data_agg_csv"
  }

  default_arguments = {
    "--job-language" = "python"
    "--class" = "Spark"
    "--job-bookmark-option" = "job-bookmark-enable"
  }
}

resource "aws_glue_job" "competitors" {
  name     = "competitors.csv"
  role_arn = "${aws_iam_role.glue.arn}"

  command {
    script_location = "s3://${var.glue_script_bucket}/competitors_csv"
  }

  default_arguments = {
    "--job-language" = "python"
    "--class" = "Spark"
    "--job-bookmark-option" = "job-bookmark-enable"
  }
}

resource "aws_glue_job" "industry_words" {
  name     = "industry_words.csv"
  role_arn = "${aws_iam_role.glue.arn}"

  command {
    script_location = "s3://${var.glue_script_bucket}/industry_words_csv"
  }

  default_arguments = {
    "--job-language" = "python"
    "--class" = "Spark"
    "--job-bookmark-option" = "job-bookmark-enable"
  }
}

resource "aws_glue_job" "sector_weights" {
  name     = "sector_weights.csv"
  role_arn = "${aws_iam_role.glue.arn}"

  command {
    script_location = "s3://${var.glue_script_bucket}/sector_weights_csv"
  }

  default_arguments = {
    "--job-language" = "python"
    "--class" = "Spark"
    "--job-bookmark-option" = "job-bookmark-enable"
  }
}
