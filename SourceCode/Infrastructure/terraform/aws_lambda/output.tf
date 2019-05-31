#Lambda function name
output "companyinfo_name" {
  value = "${aws_lambda_function.companyinfo.function_name}"
}
output "companylist_name" {
  value = "${aws_lambda_function.companylist.function_name}"
}
output "competitorinfo-by-company_name" {
  value = "${aws_lambda_function.competitorinfo-by-company.function_name}"
}
output "detailedcompanylist_name" {
  value = "${aws_lambda_function.detailedcompanylist.function_name}"
}
output "industryweights-by-company_name" {
  value = "${aws_lambda_function.industryweights-by-company.function_name}"
}
output "sectorindustryweights_name" {
  value = "${aws_lambda_function.sectorindustryweights.function_name}"
}
output "sectorweights-by-company_name" {
  value = "${aws_lambda_function.sectorweights-by-company.function_name}"
}
output "words-by-industry_name" {
  value = "${aws_lambda_function.words-by-industry.function_name}"
}
output "words-by-sector_name" {
  value = "${aws_lambda_function.words-by-sector.function_name}"
}

#Lambda arn
output "companyinfo_lambda" {
  value = "${aws_lambda_function.companyinfo.arn}"
}
output "companylist_lambda" {
  value = "${aws_lambda_function.companylist.arn}"
}
output "competitorinfo-by-company_lambda" {
  value = "${aws_lambda_function.competitorinfo-by-company.arn}"
}
output "detailedcompanylist_lambda" {
  value = "${aws_lambda_function.detailedcompanylist.arn}"
}
output "industryweights-by-company_lambda" {
  value = "${aws_lambda_function.industryweights-by-company.arn}"
}
output "sectorindustryweights_lambda" {
  value = "${aws_lambda_function.sectorindustryweights.arn}"
}
output "sectorweights-by-company_lambda" {
  value = "${aws_lambda_function.sectorweights-by-company.arn}"
}
output "words-by-industry_lambda" {
  value = "${aws_lambda_function.words-by-industry.arn}"
}
output "words-by-sector_lambda" {
  value = "${aws_lambda_function.words-by-sector.arn}"
}
