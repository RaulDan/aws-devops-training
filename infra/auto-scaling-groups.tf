resource "aws_launch_template" "online-shop-launch-template" {
  name                   = "launch_template_for_online_shop"
  image_id               = data.aws_ami.amazon-linux-2.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.online_shop_backend.id]
  key_name = var.ssh_key_pair
  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_profile.arn
  }
    user_data = base64encode(
      templatefile("./user-data-script/user_data_script.tftpl", {
        postgres_user     = "postgres",
        postgres_password = "postgres",
        postgres_url      = aws_db_instance.online_shop_db.endpoint,
        redis_url         = aws_elasticache_cluster.online-shop-elastic-cache.cache_nodes[0].address,
        commit-hash = "7a883829c1c6ba42c481976aa382bec53f532a80",
        repo_url = aws_ecr_repository.online-shop-repo.repository_url
        account_id = data.aws_caller_identity.aws_credentials.account_id
        region = data.aws_region.used_region.name
      })
    )
  tags = {
    Version = var.app_version
  }
}

resource "aws_autoscaling_group" "online-shop-asg" {
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 1
  vpc_zone_identifier       = [for subnet in aws_subnet.public_subnets : subnet.id]
  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.online_shop_target_group.arn]
  launch_template {
    id      = aws_launch_template.online-shop-launch-template.id
    version = "$Latest"
  }
}

resource "aws_lb" "online-shop-elb" {
  name               = "online-shop-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_security_group.id]
  subnets            = [for subnet in aws_subnet.public_subnets : subnet.id]
  depends_on         = [aws_internet_gateway.igw]
}

resource "aws_lb_target_group" "online_shop_target_group" {
  name        = "online-shop-target-group"
  port        = 8080
  target_type = "instance"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.online-shop-vpc.id
}

resource "aws_lb_listener" "elb-listener" {
  load_balancer_arn = aws_lb.online-shop-elb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.online_shop_target_group.arn
  }
}
