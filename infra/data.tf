data "aws_key_pair" "online-shop-key-pair" {
  key_name = "online-shop-ssh"
}

data "http" "myIp" {
  url = "http://icanhazip.com/"
}

data "aws_caller_identity" "aws_credentials" {}

data "aws_region" "used_region" {}

data "aws_ssm_parameter" "ecs_optimized_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}
