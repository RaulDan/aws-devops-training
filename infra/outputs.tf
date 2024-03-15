output "rds_host_name" {
  value = aws_db_instance.online_shop_db.endpoint
}

output "rds_port" {
  value       = aws_db_instance.online_shop_db.port
  description = "This is the port number of my rds"
}

output "elastic_cache_url" {
  value = aws_elasticache_cluster.online-shop-elastic-cache.cache_nodes[0].address
}

output "my-key-pair" {
  value = data.aws_key_pair.online-shop-key-pair.key_name
}

output "ami-linux-image" {
  value = data.aws_ami.amazon-linux-2.name
}

output "application-base-protocol" {
  value = aws_lb_listener.elb-listener.protocol
}

output "application-base-port" {
  value = aws_lb_listener.elb-listener.port
}

