terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "online-shop-s3-bucket"
    key = "stateFile.tfstate"
    region = "us-east-1"
  }
}
