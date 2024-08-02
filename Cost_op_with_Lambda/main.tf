provider "aws" {
  region = "us-east-1"
}

# Create the VPC with a predefined CIDR block
resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "Custom_vpc_01"
  }
}

#Now create the components in VPC like
# Internet gateway - To allow the subnet to send traffic to internet
resource "aws_internet_gateway" "igw_for_pub" {
  vpc_id = aws_vpc.custom_vpc.id
}


# Create a route table with a route allowing the traffic from a particular subnet ip range to connect to internet gateway making it public.
resource "aws_route_table" "routeTable" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_for_pub.id
  }
  tags = {
    Name = "route_to_internet"
  }
}

#Then create a public subnet with specific ip range
resource "aws_subnet" "pub_subnet" {
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "pub_subnet_01"
  }
}

# And then finally associate the subnet to route table
resource "aws_route_table_association" "route_subnet_link" {
  route_table_id = aws_route_table.routeTable.id
  subnet_id      = aws_subnet.pub_subnet.id
}

resource "aws_security_group" "aws_sg_for_pub" {
  #vpc_id = data.terraform_remote_state.custom_vpc.outputs.VPC_output
  vpc_id = aws_vpc.custom_vpc.id
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


resource "aws_instance" "EC2ForLambda" {
  ami             = "ami-04a81a99f5ec58529"
  instance_type   = "t2.micro"
  availability_zone = "us-east-1f"
  subnet_id       = aws_subnet.pub_subnet.id
  security_groups = [aws_security_group.aws_sg_for_pub.id]
  tags = {
    Name = "EC2ForLambda"
  }
}

resource "aws_ebs_volume" "vol_for_EC2" {
  availability_zone = "us-east-1f"
  size = 4
  tags = {
    Name = "vol_for_EC2"
  }
}

resource "aws_volume_attachment" "attach_vol" {
  instance_id = aws_instance.EC2ForLambda.id
  volume_id = aws_ebs_volume.vol_for_EC2.id
  device_name = "/dev/sdx"
}

resource "aws_ebs_snapshot" "vol_snap" {
  volume_id = aws_ebs_volume.vol_for_EC2.id
  tags = {
    Name = "vol_snap"
  }
}

output "sg_id" {
  value = aws_security_group.aws_sg_for_pub.id
}

output "igw_output" {
  value = aws_internet_gateway.igw_for_pub.id
}

output "routetable_output" {
  value = aws_route_table.routeTable.id
}

output "subnet_output" {
  value = aws_subnet.pub_subnet.id
}

output "VPC_output" {
  value = aws_vpc.custom_vpc.id
}

output "out_EC2_name" {
  value = aws_instance.EC2ForLambda.id
}

output "volume_id" {
  value = aws_ebs_volume.vol_for_EC2.id
}

output "snap_id" {
  value = aws_ebs_snapshot.vol_snap.id
}