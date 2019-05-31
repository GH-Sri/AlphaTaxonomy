resource "aws_security_group" "db_glue" {
  name = "mdas_glue_sg"
  description = "Allow access to database from all on tcp"

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "aws_db_parameter_group" "db_glue" {
  name   = "postgres10"
  family = "postgres10"
}

resource "random_string" "password" {
  length = 16
  special = true
  override_special = "/@\" "
}

resource "aws_db_instance" "db_glue" {
  allocated_storage = 200
  storage_type = "gp2"
  engine = "postgres"
  engine_version = "10.6"
  instance_class = "db.t2.xlarge"
  name = "mdas"
  identifier = "mdas"
  username = "mdas"
  publicly_accessible = true
  password = "${random_string.password.result}"
  parameter_group_name = "${aws_db_parameter_group.db_glue.name}"
  vpc_security_group_ids = [
    "${aws_security_group.db_glue.id}"]
  skip_final_snapshot = true
  backup_retention_period = 3
}
