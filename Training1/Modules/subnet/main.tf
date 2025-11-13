resource "aws_subnet" "this" {
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name = var.name
  }
}

# Nested Module: create route table for this subnet 
module "route_table" {
  source = "../route_table"
  name   = "${var.name}-rt"
  vpc_id = var.vpc_id
  subnet_id = aws_subnet.this.id
  public = var.public
}

# Nested module: create NACL for this subnet
module "nacl" {
  source    = "../nacl"
  name      = "${var.name}-nacl"
  vpc_id    = var.vpc_id
  subnet_id = aws_subnet.this.id
}
