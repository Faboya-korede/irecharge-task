variable "vpc_name" {
  type = string
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "cidr_block" {
    type = string
}

variable "subnet_count" {
  type = number
}