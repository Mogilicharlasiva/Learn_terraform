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

#resource "aws_subnet" "pri_subnet" {
#vpc_id = aws_vpc.custom_vpc.id
#cidr_block = "10.0.1.0/26"
#tags = {
#Name = "pri_subnet_01"
#}
#}

output "igw_output" {
  value = aws_internet_gateway.igw_for_pub.id
}

output "routetable_output" {
  value = aws_route_table.routeTable.route
}

output "subnet_output" {
  value = aws_subnet.pub_subnet.id
}

output "VPC_output" {
  value = aws_vpc.custom_vpc
}