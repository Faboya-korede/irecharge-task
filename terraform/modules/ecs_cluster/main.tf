#Iam role fo ecs
resource "aws_iam_role" "ecs_task_execution_role" {
  name = var.role_name
 
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-s3-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Attach CloudWatch Logs Full Access policy
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_cloudwatch_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}


# Create an ECS task fonu api
resource "aws_ecs_task_definition" "api-td" {
  family = "api"
  
  container_definitions = jsonencode([
    {
      "name" = "api",
      "image" = "730335329790.dkr.ecr.us-east-1.amazonaws.com/irecharge:latest",
      "cpu" = 0,
      "essential" = true,
      "portMappings" = [
        {
          "containerPort" = 3000,
          "hostPort" = 3000
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-create-group": "true",
          "awslogs-group": "/api",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ])
  
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_execution_role.arn

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
}

# Create ecs cluster and service 
resource "aws_ecs_cluster" "api-cluster" {
  name = var.cluster_name
}

resource "aws_ecs_service" "api-svc" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.api-cluster.id
  task_definition = aws_ecs_task_definition.api-td.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = var.task-definition-sg
    subnets         = var.private_subnet_ids
    assign_public_ip = true  
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "api"
    container_port   = 3000
  }

  #depends_on = [aws_lb_listener.http_listener]
}