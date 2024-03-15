#RDS Instance
resource "aws_db_instance" "online_shop_db" {
  allocated_storage      = 8
  db_name                = "onlineShopDatabase"
  instance_class         = "db.t3.micro"
  engine                 = "postgres"
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  username               = "postgres"
  password               = "postgres"
  skip_final_snapshot    = true
  identifier             = "online-shop-db"
  db_subnet_group_name = aws_db_subnet_group.rds-subnet.id
  multi_az             = false
}

resource "aws_db_subnet_group" "rds-subnet" {
  subnet_ids = [for subnet in aws_subnet.private_subnets : subnet.id]
}

#Redis cluster
resource "aws_elasticache_subnet_group" "elastic_cache_subnets" {
  name       = "redisElasticCacheSubnets"
  subnet_ids = [for subnet in aws_subnet.private_subnets : subnet.id]
}

resource "aws_elasticache_cluster" "online-shop-elastic-cache" {
  cluster_id           = "online-shop-redis-elastic-cache"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  port                 = 6379
  security_group_ids   = [aws_security_group.redis_security_group.id]
  num_cache_nodes      = 1
  engine_version       = "7.1"
  parameter_group_name = "default.redis7"
  apply_immediately    = true
  subnet_group_name    = aws_elasticache_subnet_group.elastic_cache_subnets.id
}

