# use local backend
terraform {
  backend "local" {
    path = "./terraform.tfstate"
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

module "data" {
  source = "./data"
  myregion = "${var.default_region}"
}

module "s3" {
  source = "./aws_s3"
}

module "rds" {
  source = "./aws_rds"
}

module "glue" {
  source = "./aws_glue"
  glue_script_bucket = "${module.s3.glue_script_bucket}"  
  glue_db_endpoint = "${module.rds.glue_db_endpoint}"
  glue_db_name = "${module.rds.glue_db_name}"
  glue_db_username = "${module.rds.glue_db_username}"
  glue_db_password = "${module.rds.glue_db_password}"
  at_data_bucket = "${module.s3.at_data_bucket}"
}

module "lambda" {
  source = "./aws_lambda"
  glue_script_bucket = "${module.s3.glue_script_bucket}"
  glue_db_endpoint = "${module.rds.glue_db_endpoint}"
  glue_db_name = "${module.rds.glue_db_name}"
  glue_db_username = "${module.rds.glue_db_username}"
  glue_db_password = "${module.rds.glue_db_password}"
  at_data_arn = "${module.s3.at_data_arn}"
  at_data_id = "${module.s3.at_data_id}"
}

module "api" {
  source = "./aws_api"
  myregion = "${var.default_region}"
  accountId = "${module.data.account_id}"
    
  companyinfo_name = "${module.lambda.companyinfo_name}"
  companylist_name = "${module.lambda.companylist_name}"
  competitorinfo-by-company_name = "${module.lambda.competitorinfo-by-company_name}"
  detailedcompanylist_name = "${module.lambda.detailedcompanylist_name}"
  industryweights-by-company_name = "${module.lambda.industryweights-by-company_name}"
  sectorindustryweights_name = "${module.lambda.sectorindustryweights_name}"
  sectorweights-by-company_name = "${module.lambda.sectorweights-by-company_name}"
  words-by-industry_name = "${module.lambda.words-by-industry_name}"
  words-by-sector_name = "${module.lambda.words-by-sector_name}"
  
  companyinfo_lambda = "${module.lambda.companyinfo_lambda}"
  companylist_lambda = "${module.lambda.companylist_lambda}"
  competitorinfo-by-company_lambda = "${module.lambda.competitorinfo-by-company_lambda}"
  detailedcompanylist_lambda = "${module.lambda.detailedcompanylist_lambda}"
  industryweights-by-company_lambda = "${module.lambda.industryweights-by-company_lambda}"
  sectorindustryweights_lambda = "${module.lambda.sectorindustryweights_lambda}"
  sectorweights-by-company_lambda = "${module.lambda.sectorweights-by-company_lambda}"
  words-by-industry_lambda = "${module.lambda.words-by-industry_lambda}"
  words-by-sector_lambda = "${module.lambda.words-by-sector_lambda}"
}
  
#module "ec2" {
 # source = "./aws_ec2"
#}

module "sagemaker" {
  source = "./aws_sagemaker"
}

#module "vpc" {
 # source "./aws_vpc"
#}
