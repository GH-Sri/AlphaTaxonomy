resource "aws_instance" "docker_instance" {
  ami = "ami-0c6b1d09930fac512"
  instance_type = "t2.2xlarge"
  
  tags = {
    Name = "docker-worker"
  }
}
