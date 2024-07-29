provider "aws" {
  region = "us-east-1"
}



resource "aws_instance" "EC2ForVPC" {
  ami = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.pub_subnet.id
  security_groups = aws_security_group.aws_sg_for_pub.id
  tags = {
    Name = EC2ForVPC
  }
}