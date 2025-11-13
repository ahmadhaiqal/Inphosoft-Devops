resource "aws_instance" "devops_vm" {
  ami                         = var.ami
  instance_type               = "t3.micro"
  subnet_id                   = values(module.private_subnets)[0].subnet_id
  iam_instance_profile        = aws_iam_instance_profile.ssm_profile.name
  associate_public_ip_address = false

  tags = {
    Name = "${var.vpc_name}-devops-vm"
  }
}

