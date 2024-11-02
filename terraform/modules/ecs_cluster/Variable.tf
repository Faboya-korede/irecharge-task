variable "lb_arn" {
  type = string  
}
  
variable "app_count" {
  type = number
  default = 1
}

variable "task-definition-sg" {
  type = list(string)
}

variable "target_group_arn" {
  description = "Target Group ARN for Load Balancer"
  type        = string
}

variable "cpu" {
  type = number
}

variable "memory" {
  type = number
}

variable "service_name" {
  type = string
}

variable "cluster_name" {
  type = string
}


variable "private_subnet_ids" {
type = list(string)
}

variable "role_name" {
  type = string
}