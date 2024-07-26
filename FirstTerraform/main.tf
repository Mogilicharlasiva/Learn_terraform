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

data "aws_security_group" "launch_wizard_sg"{
  id = "sg-0b75ba779e5fee86a"
}

resource "aws_instance" "EC2_instance" {
  ami             = "ami-0862be96e41dcbf74"
  instance_type   = "t2.micro"
  
  #An instance can have more than one sg assigned to it, that is why this attribute expects a list.
  #vpc_security_group_ids = ["sg-0b75ba779e5fee86a"]

  vpc_security_group_ids = [data.aws_security_group.launch_wizard_sg.id]
  
  tags = {
    Name = "testEC2Withtf"
  }
}