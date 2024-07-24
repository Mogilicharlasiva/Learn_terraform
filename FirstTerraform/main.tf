terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "EC2_instance" {
  ami           = "ami-0862be96e41dcbf74"
  instance_type = "t2.micro"
  tags = {
    Name = "testEC2Withtf"
  }
}