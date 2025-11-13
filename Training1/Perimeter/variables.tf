variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "vpc_name" {
  type    = string
  default = "perimeter-vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "100.125.100.0/24"
}

variable "azs" {
  type    = list(string)
  default = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}
