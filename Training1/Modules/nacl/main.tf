resource "aws_network_acl" "this" {
  vpc_id = var.vpc_id
  tags = { Name = var.name }
}

resource "aws_network_acl_association" "this" {
  subnet_id     = var.subnet_id
  network_acl_id = aws_network_acl.this.id
}

# default rules - allow established connections (we will tighten later)
resource "aws_network_acl_rule" "inbound_allow" {
  network_acl_id = aws_network_acl.this.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "outbound_allow" {
  network_acl_id = aws_network_acl.this.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}
