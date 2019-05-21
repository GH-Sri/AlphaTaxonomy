# use S3 backend
terraform {
  backend "s3" {
    bucket  = "gh-mdas-infra"
    key     = "terraform/nonprod"
    region  = "us-east-1"
  }

}

provider "aws" {
  version = "~> 1.60.0"
  region = "${var.default_region}"
  profile = "mdas"
  #assume_role {
  #    role_arn  =   "arn:aws:iam:[account]:[instance-profile]/[instance-role]"
  #    session_name  = "automation"
  #}
}

module "s3" {
  source = "./s3_buckets"

  
}