resource "aws_ecs_cluster" "online-shop-cluster" {
  name = "Online-Shop-Cluster"
}

resource "aws_ecs_task_definition" "online-shop-task-definition" {
  family                = var.ecs_task
  container_definitions = <<TASK_DEFINITION
      [
        {
          "name" :"${var.ecs_task}",
          "image" :"${aws_ecr_repository.online-shop-repo.repository_url}:${var.commit-hash}",
          "essential" :true,
          "logConfiguration": {
                  "logDriver": "awslogs",
                  "options": {
                    "awslogs-group": "${aws_cloudwatch_log_group.ecs-logs.name}",
                    "awslogs-region": "${data.aws_region.used_region.name}",
                    "awslogs-stream-prefix": "ecs"
                  }
                },
          "environment": ${data.template_file.task-definition-env.rendered},
          "memory" :768,
          "cpu" : 512,
          "portMappings" :[
            {
              "containerPort":8080,
              "hostPort":8080
            }
          ]
        }
      ]
    TASK_DEFINITION

  requires_compatibilities = ["EC2"]
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn
  network_mode             = "awsvpc"
  memory                   = 768
  cpu                      = 512
}

resource "aws_ecs_service" "ecs_service" {
  name            = "online-shop-service"
  cluster         = aws_ecs_cluster.online-shop-cluster.id
  task_definition = aws_ecs_task_definition.online-shop-task-definition.arn
  desired_count   = 1

  network_configuration {
    subnets = [for subnet in aws_subnet.public_subnets : subnet.id]
    security_groups = [aws_security_group.online_shop_backend.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.online_shop_target_group.arn
    container_name   = var.ecs_task
    container_port   = 8080
  }

    capacity_provider_strategy {
      capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
      weight = 100
    }

  depends_on = [aws_lb_listener.elb-listener]

}

resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name = "online_shop_ecs_capacity_provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.online-shop-asg.arn

    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 2
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_capacity_providers" {
  cluster_name = aws_ecs_cluster.online-shop-cluster.name

  capacity_providers = [aws_ecs_capacity_provider.ecs_capacity_provider.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
  }
}
