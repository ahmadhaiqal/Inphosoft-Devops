variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "vpc_name" {
  type    = string
  default = "devops-vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "100.126.100.0/24"
}

variable "azs" {
  type    = list(string)
  default = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["100.126.100.0/27", "100.126.100.240/28"]
}

variable "perimeter_vpc_id" {
  type = string
}

variable "perimeter_cidr" {
  type = string
}

variable "ami" {
  type        = string
  description = "EC2 AMI for DevOps VM"
  default     = "ami-0fa377108253bf620" # Amazon Linux 2023 (ap-southeast-1)
}

