//Ec2 instance template
resource "aws_instance" "VM" {

  ami = "ami-0817d428a6fb68645"
  key_name = "<PATH TO THE AWS SSH KEY>"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.ingress-all-test.name]
}

//Backend to store the state files
terraform {
  backend "s3" {
    key    = "teraform.tfstate"
    region = "us-east-1"
  }
}

//Security group with required port configuration
resource "aws_security_group" "ingress-all-test" {

  name = "allow-all-sg"
  
  ingress {

    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"

  }

  ingress {

     cidr_blocks = ["0.0.0.0/0"]
     from_port = 80
     to_port = 80
     protocol = "tcp"

   }

   ingress {

      cidr_blocks = ["0.0.0.0/0"]
      from_port = 8080
      to_port = 8080
      protocol = "tcp"

    }

   ingress {
 
      cidr_blocks = ["0.0.0.0/0"]
      from_port = 9000
      to_port = 9000
      protocol = "tcp"
 
    }

   ingress {

      cidr_blocks = ["0.0.0.0/0"]
      from_port = 8000
      to_port = 8000
      protocol = "tcp"

    }

// Terraform removes the default rule
  egress {

    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

 }

}

