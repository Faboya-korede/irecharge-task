terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"  
    }
  }

  backend "s3" {
    bucket         = "irecharge-bucket"         
    key            = "terraform/state/my-project.tfstate"  
    region         = "us-east-1"                          
    dynamodb_table = "irecharge-table"             
    encrypt        = true                                   
  }
}


provider "aws" {
  #region = "us-east-1"
}


module "vpc" {
  source              = "./modules/vpc"
  subnet_count = 2
  vpc_name            = "main"
  cidr_block          = "10.32.0.0/16"
}


module "sg" {
  source              = "./modules/security_group"
  vpc_id             =  module.vpc.vpc_id
  lb_sg_name = "api-lg"
  task_sg_name = "api-task-sg"
}

module "lb" {
  source              = "./modules/Load_balancer"
  vpc_id = module.vpc.vpc_id
  public_subnet_ids =  module.vpc.public_subnet_ids
  lb_name = "api-lb"
  target_group_name = "api-tg"
  lb_sg = [module.sg.lb_sg]
}

module "ecs" {
  source              = "./modules/ecs_cluster"
  lb_arn = module.lb.lb_arn
  app_count = 2
  task-definition-sg = [module.sg.task-sg]
  target_group_arn = module.lb.target_group_arn
  cpu = 256
  memory = 512
  service_name = "api-service"
  cluster_name = "api-cluster"
  private_subnet_ids = module.vpc.private_subnet_ids
  role_name = "api-task-role"
}
