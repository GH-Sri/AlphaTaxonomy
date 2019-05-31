output "glue_db_endpoint" {
  value = "${aws_db_instance.db_glue.endpoint}"
}

output "glue_db_address" {
  value = "${aws_db_instance.db_glue.address}"
}

output "glue_db_name" {
  value = "${aws_db_instance.db_glue.name}"
}

output "glue_db_username" {
  value = "${aws_db_instance.db_glue.username}"
}

output "glue_db_password" {
  value = "${aws_db_instance.db_glue.password}"
}

