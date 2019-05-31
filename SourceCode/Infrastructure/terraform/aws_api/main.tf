#Sets up variables for use from other modules
variable "myregion" {type="string"}
variable "accountId" {type="string"}
variable "companyinfo_name" {type="string"}
variable "companylist_name" {type="string"}
variable "competitorinfo-by-company_name" {type="string"}
variable "detailedcompanylist_name" {type="string"}
variable "industryweights-by-company_name" {type="string"}
variable "sectorindustryweights_name" {type="string"}
variable "sectorweights-by-company_name" {type="string"}
variable "words-by-industry_name" {type="string"}
variable "words-by-sector_name" {type="string"}
variable "companyinfo_lambda" {type="string"}
variable "companylist_lambda" {type="string"}
variable "competitorinfo-by-company_lambda" {type="string"}
variable "detailedcompanylist_lambda" {type="string"}
variable "industryweights-by-company_lambda" {type="string"}
variable "sectorindustryweights_lambda" {type="string"}
variable "sectorweights-by-company_lambda" {type="string"}
variable "words-by-industry_lambda" {type="string"}
variable "words-by-sector_lambda" {type="string"}

#Sets up api gateway
resource "aws_api_gateway_rest_api" "at_website" {
  name = "AlphaTaxomomy-data-API"
  description = "API gateway for the AT S3 app"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

#Sets up stage
resource "aws_api_gateway_stage" "dev" {
  stage_name = "DEV"
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  deployment_id = "${aws_api_gateway_deployment.at_website.id}"
}

#Sets up deployment for stage
resource "aws_api_gateway_deployment" "at_website" {
  depends_on = [
    "aws_api_gateway_integration.words-by-sector",
    "aws_api_gateway_integration.companyinfo",
    "aws_api_gateway_integration.companylist",
    "aws_api_gateway_integration.competitorinfo-by-company",
    "aws_api_gateway_integration.detailedcompanylist",
    "aws_api_gateway_integration.industryweights-by-company",
    "aws_api_gateway_integration.sectorindustryweights",
    "aws_api_gateway_integration.sectorweights-by-company",
    "aws_api_gateway_integration.words-by-industry"
  ]
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  stage_name = "DEV"
}

#Sets up routing resources
resource "aws_api_gateway_resource" "companyinfo" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  parent_id = "${aws_api_gateway_rest_api.at_website.root_resource_id}"
  path_part = "companyinfo"
}

#Nested inside companyinfo
resource "aws_api_gateway_resource" "companyinfo-arg" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  parent_id = "${aws_api_gateway_resource.companyinfo.id}"
  path_part = "{companyname}"
}

resource "aws_api_gateway_resource" "companylist" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  parent_id = "${aws_api_gateway_rest_api.at_website.root_resource_id}"
  path_part = "companylist"
}

resource "aws_api_gateway_resource" "competitorinfo-by-company" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  parent_id = "${aws_api_gateway_rest_api.at_website.root_resource_id}"
  path_part = "competitorinfo-by-company"
}

#Nested inside competitorinfo-by-company
resource "aws_api_gateway_resource" "competitorinfo-by-company-arg" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  parent_id = "${aws_api_gateway_resource.competitorinfo-by-company.id}"
  path_part = "{companyname}"
}

resource "aws_api_gateway_resource" "detailedcompanylist" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  parent_id = "${aws_api_gateway_rest_api.at_website.root_resource_id}"
  path_part = "detailedcompanylist"
}

resource "aws_api_gateway_resource" "industryweights-by-company" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  parent_id = "${aws_api_gateway_rest_api.at_website.root_resource_id}"
  path_part = "industryweights-by-company"
}

#Nested inside industryweights-by-company
resource "aws_api_gateway_resource" "industryweights-by-company-arg" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  parent_id = "${aws_api_gateway_resource.industryweights-by-company.id}"
  path_part = "{companyname}"
}

resource "aws_api_gateway_resource" "sectorindustryweights" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  parent_id = "${aws_api_gateway_rest_api.at_website.root_resource_id}"
  path_part = "sectorindustryweights"
}

resource "aws_api_gateway_resource" "sectorweights-by-company" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  parent_id = "${aws_api_gateway_rest_api.at_website.root_resource_id}"
  path_part = "sectorweights-by-company"
}

#Nested inside sectorweights-by-company
resource "aws_api_gateway_resource" "sectorweights-by-company-arg" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  parent_id = "${aws_api_gateway_resource.sectorweights-by-company.id}"
  path_part = "{companyname}"
}

resource "aws_api_gateway_resource" "words-by-industry" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  parent_id = "${aws_api_gateway_rest_api.at_website.root_resource_id}"
  path_part = "words-by-industry"
}

#Nested inside words-by-industry
resource "aws_api_gateway_resource" "words-by-industry-arg" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  parent_id = "${aws_api_gateway_resource.words-by-industry.id}"
  path_part = "{industry}"
}

resource "aws_api_gateway_resource" "words-by-sector" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  parent_id = "${aws_api_gateway_rest_api.at_website.root_resource_id}"
  path_part = "words-by-sector"
}

#Nested inside words-by-sector
resource "aws_api_gateway_resource" "words-by-sector-arg" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  parent_id = "${aws_api_gateway_resource.words-by-sector.id}"
  path_part = "{sector}"
}

#Sets up methods for resources
resource  "aws_api_gateway_method" "companyinfo" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.companyinfo-arg.id}"
  http_method = "GET"
  authorization = "NONE"
}

resource  "aws_api_gateway_method" "companylist" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.companylist.id}"
  http_method = "GET"
  authorization = "NONE"
}

resource  "aws_api_gateway_method" "competitorinfo-by-company" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.competitorinfo-by-company-arg.id}"
  http_method = "GET"
  authorization = "NONE"
}

resource  "aws_api_gateway_method" "detailedcompanylist" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.detailedcompanylist.id}"
  http_method = "GET"
  authorization = "NONE"
}

resource  "aws_api_gateway_method" "industryweights-by-company" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.industryweights-by-company-arg.id}"
  http_method = "GET"
  authorization = "NONE"
}

resource  "aws_api_gateway_method" "sectorindustryweights" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.sectorindustryweights.id}"
  http_method = "GET"
  authorization = "NONE"
}

resource  "aws_api_gateway_method" "sectorweights-by-company" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.sectorweights-by-company-arg.id}"
  http_method = "GET"
  authorization = "NONE"
}

resource  "aws_api_gateway_method" "words-by-industry" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.words-by-industry-arg.id}"
  http_method = "GET"
  authorization = "NONE"
}

resource  "aws_api_gateway_method" "words-by-sector" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.words-by-sector-arg.id}"
  http_method = "GET"
  authorization = "NONE"
}

#Sets up lambda integration for methods
resource "aws_api_gateway_integration" "companyinfo" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.companyinfo-arg.id}"
  http_method = "${aws_api_gateway_method.companyinfo.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.myregion}:lambda:path/2015-03-31/functions/${var.companyinfo_lambda}/invocations"
}

resource "aws_api_gateway_integration" "companylist" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.companylist.id}"
  http_method = "${aws_api_gateway_method.companylist.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.myregion}:lambda:path/2015-03-31/functions/${var.companylist_lambda}/invocations"
}

resource "aws_api_gateway_integration" "competitorinfo-by-company" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.competitorinfo-by-company-arg.id}"
  http_method = "${aws_api_gateway_method.companyinfo.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.myregion}:lambda:path/2015-03-31/functions/${var.competitorinfo-by-company_lambda}/invocations"
}

resource "aws_api_gateway_integration" "detailedcompanylist" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.detailedcompanylist.id}"
  http_method = "${aws_api_gateway_method.detailedcompanylist.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.myregion}:lambda:path/2015-03-31/functions/${var.detailedcompanylist_lambda}/invocations"
}

resource "aws_api_gateway_integration" "industryweights-by-company" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.industryweights-by-company-arg.id}"
  http_method = "${aws_api_gateway_method.industryweights-by-company.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.myregion}:lambda:path/2015-03-31/functions/${var.industryweights-by-company_lambda}/invocations"
}

resource "aws_api_gateway_integration" "sectorindustryweights" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.sectorindustryweights.id}"
  http_method = "${aws_api_gateway_method.sectorindustryweights.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.myregion}:lambda:path/2015-03-31/functions/${var.sectorindustryweights_lambda}/invocations"
}

resource "aws_api_gateway_integration" "sectorweights-by-company" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.sectorweights-by-company-arg.id}"
  http_method = "${aws_api_gateway_method.sectorweights-by-company.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.myregion}:lambda:path/2015-03-31/functions/${var.sectorweights-by-company_lambda}/invocations"
}

resource "aws_api_gateway_integration" "words-by-industry" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.words-by-industry-arg.id}"
  http_method = "${aws_api_gateway_method.words-by-industry.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.myregion}:lambda:path/2015-03-31/functions/${var.words-by-industry_lambda}/invocations"
}

resource "aws_api_gateway_integration" "words-by-sector" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.words-by-sector-arg.id}"
  http_method = "${aws_api_gateway_method.words-by-sector.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.myregion}:lambda:path/2015-03-31/functions/${var.words-by-sector_lambda}/invocations"
}

#Sets up invocation permission from API Gateway
resource "aws_lambda_permission" "companyinfo" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = "${var.companyinfo_name}"
  principal = "apigateway.amazonaws.com"
  
  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.at_website.id}/*/${aws_api_gateway_method.companyinfo.http_method}${aws_api_gateway_resource.companyinfo-arg.path}"
}

resource "aws_lambda_permission" "companylist" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = "${var.companylist_name}"
  principal = "apigateway.amazonaws.com"
  
  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.at_website.id}/*/${aws_api_gateway_method.companylist.http_method}${aws_api_gateway_resource.companylist.path}"
}

resource "aws_lambda_permission" "competitorinfo-by-company" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = "${var.competitorinfo-by-company_name}"
  principal = "apigateway.amazonaws.com"
  
  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.at_website.id}/*/${aws_api_gateway_method.competitorinfo-by-company.http_method}${aws_api_gateway_resource.competitorinfo-by-company-arg.path}"
}

resource "aws_lambda_permission" "detailedcompanylist" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = "${var.detailedcompanylist_name}"
  principal = "apigateway.amazonaws.com"
  
  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.at_website.id}/*/${aws_api_gateway_method.detailedcompanylist.http_method}${aws_api_gateway_resource.detailedcompanylist.path}"
}

resource "aws_lambda_permission" "industryweights-by-company" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = "${var.industryweights-by-company_name}"
  principal = "apigateway.amazonaws.com"
  
  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.at_website.id}/*/${aws_api_gateway_method.industryweights-by-company.http_method}${aws_api_gateway_resource.industryweights-by-company-arg.path}"
}

resource "aws_lambda_permission" "sectorindustryweights" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = "${var.sectorindustryweights_name}"
  principal = "apigateway.amazonaws.com"
  
  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.at_website.id}/*/${aws_api_gateway_method.sectorindustryweights.http_method}${aws_api_gateway_resource.sectorindustryweights.path}"
}

resource "aws_lambda_permission" "sectorweights-by-company" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = "${var.sectorweights-by-company_name}"
  principal = "apigateway.amazonaws.com"
  
  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.at_website.id}/*/${aws_api_gateway_method.sectorweights-by-company.http_method}${aws_api_gateway_resource.sectorweights-by-company-arg.path}"
}

resource "aws_lambda_permission" "words-by-industry" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = "${var.words-by-industry_name}"
  principal = "apigateway.amazonaws.com"
  
  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.at_website.id}/*/${aws_api_gateway_method.words-by-industry.http_method}${aws_api_gateway_resource.words-by-industry-arg.path}"
}

resource "aws_lambda_permission" "words-by-sector" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = "${var.words-by-sector_name}"
  principal = "apigateway.amazonaws.com"
  
  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.at_website.id}/*/${aws_api_gateway_method.words-by-sector.http_method}${aws_api_gateway_resource.words-by-sector-arg.path}"
}

#Sets up stage settings
resource "aws_api_gateway_method_settings" "words-by-sector" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  stage_name  = "${aws_api_gateway_stage.dev.stage_name}"
  method_path = "${aws_api_gateway_resource.words-by-sector-arg.path_part}/${aws_api_gateway_method.words-by-sector.http_method}"

  settings {
    metrics_enabled = true
    logging_level   = "OFF"
  }
}

#Sets up method response
resource "aws_api_gateway_method_response" "words-by-sector" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.words-by-sector-arg.id}"
  http_method = "${aws_api_gateway_method.words-by-sector.http_method}"
  status_code = "200"
}
resource "aws_api_gateway_method_response" "companyinfo" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.companyinfo-arg.id}"
  http_method = "${aws_api_gateway_method.companyinfo.http_method}"
  status_code = "200"
}
resource "aws_api_gateway_method_response" "companylist" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.companylist.id}"
  http_method = "${aws_api_gateway_method.companylist.http_method}"
  status_code = "200"
}
resource "aws_api_gateway_method_response" "competitorinfo-by-company" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.competitorinfo-by-company-arg.id}"
  http_method = "${aws_api_gateway_method.competitorinfo-by-company.http_method}"
  status_code = "200"
}
resource "aws_api_gateway_method_response" "detailedcompanylist" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.detailedcompanylist.id}"
  http_method = "${aws_api_gateway_method.detailedcompanylist.http_method}"
  status_code = "200"
}
resource "aws_api_gateway_method_response" "industryweights-by-company" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.industryweights-by-company-arg.id}"
  http_method = "${aws_api_gateway_method.industryweights-by-company.http_method}"
  status_code = "200"
}
resource "aws_api_gateway_method_response" "sectorindustryweights" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.sectorindustryweights.id}"
  http_method = "${aws_api_gateway_method.sectorindustryweights.http_method}"
  status_code = "200"
}
resource "aws_api_gateway_method_response" "sectorweights-by-company" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.sectorweights-by-company-arg.id}"
  http_method = "${aws_api_gateway_method.sectorweights-by-company.http_method}"
  status_code = "200"
}
resource "aws_api_gateway_method_response" "words-by-industry" {
  rest_api_id = "${aws_api_gateway_rest_api.at_website.id}"
  resource_id = "${aws_api_gateway_resource.words-by-industry-arg.id}"
  http_method = "${aws_api_gateway_method.words-by-industry.http_method}"
  status_code = "200"
}
