#VPC variables
variable "public_subnets_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "CIDR block for Public Subnet"
}

variable "private_subnets_cidr" {
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
  description = "CIDR block for Private Subnets"
}

variable "egress_rule" {
  default = {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "instance_type" {
  type = string
}

variable "rds_type" {
  type = string
}

variable "redis_type" {
  type = string
}

variable "app_version" {}

variable "ssh_key_pair" {}

variable "commit-hash" {type= string}
