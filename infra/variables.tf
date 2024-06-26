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

variable "commit-hash" {
  type    = string
  default = ""
}

variable "ecs_task" {
  type = string
  default = "online-shop-task"
}

data "template_file" "task-definition-env" {
  template = file("./template-files/task-definition-env.tftpl")

  vars = {
    postgres_user     = local.db_screts["postgres_password"]
    postgres_password = local.db_screts["postgres_password"]
    postgres_url      = aws_db_instance.online_shop_db.endpoint
    redis_url         = aws_elasticache_cluster.online-shop-elastic-cache.cache_nodes[0].address
  }
}

data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = "db_secrets"
}

locals {
  db_screts = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)
}
