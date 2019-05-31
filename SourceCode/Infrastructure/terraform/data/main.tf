#Sets up metadata to be used in other modules
data "aws_caller_identity" "current" {}
variable myregion {type="string"}
output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

output "caller_arn" {
  value = "${data.aws_caller_identity.current.arn}"
}

output "caller_user" {
  value = "${data.aws_caller_identity.current.user_id}"
}

output "default_region" {
  value = "${var.myregion}"
}

output "deploy_token" {
  value = "116d9c9e32fcd769970e3bae9b83d98fdb"
}

output "backup_notebook" {
  value = "https://mdas-data-science.notebook.us-east-1.sagemaker.aws/notebooks/data-science-notebook/NLP%20Pipeline%20Notebook.ipynb"
}
output "backup_user" {
  value = "GH-MDAS-Demo"
}
output "backup_pass" {
  value = "kkRz3^E]eT=E"
}
output "backup_login" {
  value = "https://375630183866.signin.aws.amazon.com/console"
}
output "data_viz" {
  value = "http://at-mdas-web.s3-website-us-east-1.amazonaws.com/home"
}
