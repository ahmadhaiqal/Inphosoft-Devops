variable "name" {}
variable "vpc_id" {}
variable "subnet_id" {}
variable "public" { 
  type = bool
  default = false 
}
