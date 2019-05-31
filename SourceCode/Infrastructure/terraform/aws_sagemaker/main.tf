resource "aws_iam_role" "mdas-data-science" {
  name = "SageMakerServiceRole"
  path = "/"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = [ "sts:AssumeRole" ]
    principals {
      type = "Service"
      identifiers = [ "sagemaker.amazonaws.com" ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "mdas-data-science" {
  role = "${aws_iam_role.mdas-data-science.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

variable "secret_json" {
  default = {
    username = "mdas-bot"
    password = "mdasbot123"
  }

  type = "map"
}

resource "aws_secretsmanager_secret" "sagemaker-secret" {
  name = "sagemaker-secret"
}

resource "aws_secretsmanager_secret_version" "sagemaker-secret" {
  secret_id     = "${aws_secretsmanager_secret.sagemaker-secret.id}"
  secret_string = "${jsonencode(var.secret_json)}"
}
