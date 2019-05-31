output "sagemaker_secret_arn" {
  value = "${aws_secretsmanager_secret.sagemaker-secret.arn}"
}

output "sagemaker_role_arn" {
  value = "${aws_iam_role.mdas-data-science.arn}"
}

output "sagemaker_instance_name" {
  value = "mdas-data-science-terraform"
}

output "sagemaker_github_url" {
  value = "https://github.com/gh-mdas/data-science-notebook.git"
}
