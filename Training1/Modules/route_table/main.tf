resource "aws_route_table" "this" {
  vpc_id = var.vpc_id
  tags = { Name = var.name }
}

resource "aws_route_table_association" "this" {
  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.this.id
}
