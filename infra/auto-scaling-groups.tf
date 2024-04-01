resource "aws_launch_template" "online-shop-launch-template" {
  name                   = "launch_template_for_online_shop"
  image_id               = data.aws_ssm_parameter.ecs_optimized_ami.value
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.online_shop_backend.id]
  key_name               = var.ssh_key_pair
  iam_instance_profile {
    arn = aws_iam_instance_profile.ecs-ec2-instance-profile.arn
  }
  user_data = base64encode(
    templatefile("./template-files/user_data_script.tftpl", {
      cluster_name = aws_ecs_cluster.online-shop-cluster.name
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
  name = "online-shop-asg"
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
  target_type = "ip"
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
