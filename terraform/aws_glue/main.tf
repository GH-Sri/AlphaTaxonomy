resource "aws_glue_catalog_database" "mdas" {
  name = "mdas"
}

resource "aws_glue_catalog_table" "aws_glue_company_list" {
  name          = "company_list"
  database_name = "${aws_glue_catalog_database.mdas.name}"

  table_type = "EXTERNAL_TABLE"
  storage_descriptor {
    columns  {
      name = "symbol"
      type = "string"
    }
    columns  {
      name = "name"
      type = "string"
    }
    columns  {
      name = "lastsale"
      type = "string"
    }
    columns  {
      name = "marketcap"
      type = "string"
    }
    columns  {
      name = "adr_tso"
      type = "string"
    }
    columns  {
      name = "ipoyear"
      type = "string"
    }
    columns  {
      name = "sector"
      type = "string"
    }
    columns  {
      name = "industry"
      type = "string"
    }
    columns  {
      name = "summary_quote"
      type = "string"
    }
    columns  {
      name = "exchange"
      type = "string"
    }
    columns  {
      name = "clk"
      type = "string"
    }
    location = "s3://${aws_s3_bucket.data_bucket_4.bucket}/ETL-Metadata"
    input_format = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    compressed = "false"
    number_of_buckets = -1
    ser_de_info {
      name = "SerDeCsv"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
      parameters {
        "serialization.format" = "1"
      }
    }
  }
}

resource "aws_glue_catalog_table" "aws_glue_csv_allwikipediadata_csv" {
  name          = "csv_allwikipediadata_csv"
  database_name = "${aws_glue_catalog_database.mdas.name}"

  table_type = "EXTERNAL_TABLE"
  storage_descriptor {
    columns  {
      name = "x"
      type = "bigint"
    }
    columns  {
      name = "symbol"
      type = "string"
    }
    columns  {
      name = "name"
      type = "string"
    }
    columns  {
      name = "name"
      type = "string"
    }
    columns  {
      name = "wiki_2"
      type = "string"
    }
    columns  {
      name = "short_descript"
      type = "string"
    }
    columns  {
      name = "finance_site"
      type = "string"
    }
    columns  {
      name = "website"
      type = "string"
    }
    columns  {
      name = "description"
      type = "string"
    }
    columns  {
      name = "keywords"
      type = "string"
    }
    location = "s3://${aws_s3_bucket.data_bucket_4.bucket}/Output-For-ETL/AllWikipediaData.csv"
    input_format = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    compressed = "false"
    number_of_buckets = -1
    ser_de_info {
      name = ""
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
      parameters {
        "quoteChar" = "\""
        "separatorChar" = ","
      }
    }
  }
}

resource "aws_glue_catalog_table" "aws_glue_csv_companylist_full_csv" {
  name          = "csv_companylist_full_csv"
  database_name = "${aws_glue_catalog_database.mdas.name}"

  table_type = "EXTERNAL_TABLE"
  storage_descriptor {
    columns  {
      name = "symbol"
      type = "string"
    }
    columns  {
      name = "name"
      type = "string"
    }
    columns  {
      name = "lastsale"
      type = "string"
    }
    columns  {
      name = "marketcap"
      type = "string"
    }
    columns  {
      name = "adr tso"
      type = "string"
    }
    columns  {
      name = "ipoyear"
      type = "string"
    }
    columns  {
      name = "sector"
      type = "string"
    }
    columns  {
      name = "industry"
      type = "string"
    }
    columns  {
      name = "summary quote"
      type = "string"
    }
    columns  {
      name = "exchange"
      type = "string"
    }
    columns  {
      name = "bigint"
      type = "clk"
    }
    location = "s3://${aws_s3_bucket.data_bucket_4.bucket}/Output-For-ETL/companylist_full.csv"
    input_format = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    compressed = "false"
    number_of_buckets = -1
    ser_de_info {
      name = ""
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
      parameters {
        "field.delim" = ","
      }
    }
  }
}

resource "aws_glue_catalog_table" "aws_glue_csv_historicalstockpricedataallexchanges_csv" {
  name          = "csv_historicalstockpricedataallexchanges_csv"
  database_name = "${aws_glue_catalog_database.mdas.name}"

  table_type = "EXTERNAL_TABLE"
  storage_descriptor {
    columns  {
      name = "symbol"
      type = "string"
    }
    columns  {
      name = "name"
      type = "string"
    }
    columns  {
      name = "lastsale"
      type = "string"
    }
    columns  {
      name = "marketcap"
      type = "string"
    }
    columns  {
      name = "adr tso"
      type = "string"
    }
    columns  {
      name = "ipoyear"
      type = "string"
    }
    columns  {
      name = "sector"
      type = "string"
    }
    columns  {
      name = "industry"
      type = "string"
    }
    columns  {
      name = "summary quote"
      type = "string"
    }
    columns  {
      name = "exchange"
      type = "string"
    }
    columns  {
      name = "bigint"
      type = "clk"
    }
    location = "s3://${aws_s3_bucket.data_bucket_4.bucket}/Output-For-ETL/HistoricalStockPriceDataAllExchanges.csv"
    input_format = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    compressed = "false"
    number_of_buckets = -1
    ser_de_info {
      name = ""
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
      parameters {
        "quoteChar" = "\""
	"separatorChar" = ","
      }
    }
  }
}

resource "aws_glue_catalog_table" "aws_glue_csv_output_for_etl" {
  name          = "csv_output_for_etl"
  database_name = "${aws_glue_catalog_database.mdas.name}"

  table_type = "EXTERNAL_TABLE"
  storage_descriptor {
    columns  {
      name = "symbol"
      type = "string"
    }
    columns  {
      name = "name"
      type = "string"
    }
    columns  {
      name = "lastsale"
      type = "string"
    }
    columns  {
      name = "marketcap"
      type = "string"
    }
    columns  {
      name = "adr tso"
      type = "string"
    }
    columns  {
      name = "ipoyear"
      type = "string"
    }
    columns  {
      name = "sector"
      type = "string"
    }
    columns  {
      name = "industry"
      type = "string"
    }
    columns  {
      name = "summary quote"
      type = "string"
    }
    columns  {
      name = "exchange"
      type = "string"
    }
    columns  {
      name = "bigint"
      type = "clk"
    }
    location = "s3://${aws_s3_bucket.data_bucket_4.bucket}/Output-For-ETL/"
    input_format = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    compressed = "false"
    number_of_buckets = -1
    ser_de_info {
      name = ""
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
      parameters {
        "quoteChar" = "\""
	"separatorChar" = ","
      }
    }
  }
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
