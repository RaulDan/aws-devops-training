data "aws_key_pair" "online-shop-key-pair" {
  key_name = "online-shop-ssh"
}

data "aws_ami" "amazon-linux-2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

data "http" "myIp" {
  url = "http://icanhazip.com/"
}

data "aws_caller_identity" "aws_credentials" {}

data "aws_region" "used_region" {}
