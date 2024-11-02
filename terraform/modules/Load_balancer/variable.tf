variable "vpc_id" {
    type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "lb_name" {
  type = string
}

variable "target_group_name" {
  type = string
}

variable "lb_sg" {
  type = list(string)
}