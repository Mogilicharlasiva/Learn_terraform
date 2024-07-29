provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "name" {
  backend = "local"
  config = {
    path = "../CreateVPC/terraform.tfstate"
  }
}
resource "aws_security_group" "aws_sg_for_pub" {
  vpc_id = data.terraform_remote_state.custom_vpc.outputs.VPC_output
  #vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "aws_sg_for_pub"
  }
}

resource "aws_vpc_security_group_ingress_rule" "inbound_http" {
  security_group_id = aws_security_group.aws_sg_for_pub.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = aws_vpc.custom_vpc.cidr_block
}

resource "aws_vpc_security_group_ingress_rule" "inbound_ssh" {
  security_group_id = aws_security_group.aws_sg_for_pub.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = aws_vpc.custom_vpc.cidr_block
}

resource "aws_vpc_security_group_egress_rule" "outboubd_all" {
  security_group_id = aws_security_group.aws_sg_for_pub.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

output "sg_id" {
  value = aws_security_group.aws_sg_for_pub.id
}