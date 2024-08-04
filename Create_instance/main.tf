provider "aws" {
  region = "us-east-1"
}



resource "aws_instance" "EC2ForVPC" {
  ami           = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"
  subnet_id = "subnet-05460879bb9faf8cd"
  tags = {
    Name = "EC2ForVPC"
  }
}

resource "aws_s3_bucket" "bucketForLambda" {

}