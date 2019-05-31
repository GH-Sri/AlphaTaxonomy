variable "default_region" {
  description = "Default Region for our VPC"
  default = "us-east-1"
}

variable "aws_access_key" {
  default = ""
}

variable "aws_secret_key" {
  default = ""
}

variable "creation_key" {
  description = "SSH Creation Key 1"
  default = "/home/mdas/.ssh/id_rsa.pub"
}

variable "ec2_tags" {
  type = "map"
  default = {
    SystemOwner   = "Sri",
    Contact       = "sril@guidehouse.com"
    ResourceGroup = "mdas"
  }
}
