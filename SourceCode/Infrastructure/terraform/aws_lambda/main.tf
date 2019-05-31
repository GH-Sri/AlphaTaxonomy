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
variable "at_data_arn" {
  type = "string"
}
variable "at_data_id" {
  type = "string"
}

resource "aws_iam_policy" "iam_for_lambda" {
  name = "iam_for_lambda"
  description = "Policy for logging and glue"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "glue:*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "iam_for_lambda" {
  role = "${aws_iam_role.iam_for_lambda.name}"
  policy_arn = "${aws_iam_policy.iam_for_lambda.arn}"
}

resource "aws_lambda_function" "words-by-industry" {
  filename         = "${path.module}/get-words-by-industry.zip"
  function_name    = "get-words-by-industry"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "lambda_function.lambda_handler"
  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("${path.module}/get-words-by-industry.zip")}"
  runtime          = "python3.6"

  #TODO: Make database connection variables
  environment {
    variables = {
      rds_host = "${var.glue_db_endpoint}"
      db_name = "${var.glue_db_name}"
      db_username = "${var.glue_db_username}"
      db_password = "${var.glue_db_password}"
    }
  }
}

resource "aws_lambda_function" "words-by-sector" {
  filename         = "${path.module}/get-words-by-sector.zip"
  function_name    = "get-words-by-sector"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "lambda_function.lambda_handler"
  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("${path.module}/get-words-by-sector.zip")}"
  runtime          = "python3.6"

  environment {
    variables = {
      rds_host = "${var.glue_db_endpoint}"
      db_name = "${var.glue_db_name}"
      db_username = "${var.glue_db_username}"
      db_password = "${var.glue_db_password}"
    }
  }
}

resource "aws_lambda_function" "industryweights-by-company" {
  filename         = "${path.module}/get-industryweights-by-company.zip"
  function_name    = "get-industryweights-by-company"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "lambda_function.lambda_handler"
  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("${path.module}/get-industryweights-by-company.zip")}"
  runtime          = "python3.6"

  environment {
    variables = {
      rds_host = "${var.glue_db_endpoint}"
      db_name = "${var.glue_db_name}"
      db_username = "${var.glue_db_username}"
      db_password = "${var.glue_db_password}"
    }
  }
}

resource "aws_lambda_function" "competitorinfo-by-company" {
  filename         = "${path.module}/get-competitorinfo-by-company.zip"
  function_name    = "get-competitorinfo-by-company"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "lambda_function.lambda_handler"
  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("${path.module}/get-competitorinfo-by-company.zip")}"
  runtime          = "python3.6"

  environment {
    variables = {
      rds_host = "${var.glue_db_endpoint}"
      db_name = "${var.glue_db_name}"
      db_username = "${var.glue_db_username}"
      db_password = "${var.glue_db_password}"
    }
  }
}

resource "aws_lambda_function" "sectorindustryweights" {
  filename         = "${path.module}/get-sectorindustryweights.zip"
  function_name    = "get-sectorindustryweights"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "lambda_function.lambda_handler"
  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("${path.module}/get-sectorindustryweights.zip")}"
  runtime          = "python3.6"

  environment {
    variables = {
      rds_host = "${var.glue_db_endpoint}"
      db_name = "${var.glue_db_name}"
      db_username = "${var.glue_db_username}"
      db_password = "${var.glue_db_password}"
    }
  }
}

resource "aws_lambda_function" "companyinfo" {
  filename         = "${path.module}/get-companyinfo.zip"
  function_name    = "get-companyinfo"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "lambda_function.lambda_handler"
  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("${path.module}/get-companyinfo.zip")}"
  runtime          = "python3.6"

  environment {
    variables = {
      rds_host = "${var.glue_db_endpoint}"
      db_name = "${var.glue_db_name}"
      db_username = "${var.glue_db_username}"
      db_password = "${var.glue_db_password}"
    }
  }
}

resource "aws_lambda_function" "companylist" {
  filename         = "${path.module}/get-companylist.zip"
  function_name    = "get-companylist"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "lambda_function.lambda_handler"
  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("${path.module}/get-companylist.zip")}"
  runtime          = "python3.6"

  environment {
    variables = {
      rds_host = "${var.glue_db_endpoint}"
      db_name = "${var.glue_db_name}"
      db_username = "${var.glue_db_username}"
      db_password = "${var.glue_db_password}"
    }
  }
}

resource "aws_lambda_function" "sectorweights-by-company" {
  filename         = "${path.module}/get-sectorweights-by-company.zip"
  function_name    = "get-sectorweights-by-company"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "lambda_function.lambda_handler"
  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("${path.module}/get-sectorweights-by-company.zip")}"
  runtime          = "python3.6"

  environment {
    variables = {
      rds_host = "${var.glue_db_endpoint}"
      db_name = "${var.glue_db_name}"
      db_username = "${var.glue_db_username}"
      db_password = "${var.glue_db_password}"
    }
  }
}

resource "aws_lambda_function" "detailedcompanylist" {
  filename         = "${path.module}/get-detailedcompanylist.zip"
  function_name    = "get-detailedcompanylist"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "lambda_function.lambda_handler"
  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("${path.module}/get-detailedcompanylist.zip")}"
  runtime          = "python3.6"

  environment {
    variables = {
      rds_host = "${var.glue_db_endpoint}"
      db_name = "${var.glue_db_name}"
      db_username = "${var.glue_db_username}"
      db_password = "${var.glue_db_password}"
    }
  }
}

resource "aws_lambda_function" "s3-trigger-etl-jobs" {
  filename         = "${path.module}/s3-trigger-etl-jobs.zip"
  function_name    = "s3-trigger-etl-jobs"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "lambda_function.lambda_handler"
  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("${path.module}/s3-trigger-etl-jobs.zip")}"
  runtime          = "python3.7"

  environment {
    variables = {
      rds_host = "${var.glue_db_endpoint}"
      db_name = "${var.glue_db_name}"
      db_username = "${var.glue_db_username}"
      db_password = "${var.glue_db_password}"
    }
  }
}

resource "aws_lambda_permission" "s3-trigger-etl-jobs" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.s3-trigger-etl-jobs.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${var.at_data_arn}"
}

resource "aws_s3_bucket_notification" "s3-trigger-etl-jobs" {
  bucket = "${var.at_data_id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.s3-trigger-etl-jobs.arn}"
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "Output-For-ETL/"
  }
}
