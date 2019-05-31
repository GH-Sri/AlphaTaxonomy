output "at_website" {
  value = "${aws_s3_bucket.at_website.bucket_domain_name}"
}
output "at_data" {
  value = "${aws_s3_bucket.at_data.bucket_domain_name}"
}
output "glue_script" {
  value = "${aws_s3_bucket.glue_script.bucket_domain_name}"
}
output "glue_script_bucket" {
  value = "${aws_s3_bucket.glue_script.bucket}"
}
output "at_website_bucket" {
  value = "${aws_s3_bucket.at_website.bucket}"
}
output "at_data_bucket" {
  value = "${aws_s3_bucket.at_data.bucket}"
}
output "at_data_arn" {
  value = "${aws_s3_bucket.at_data.arn}"
}
output "at_data_id" {
  value = "${aws_s3_bucket.at_data.id}"
}
