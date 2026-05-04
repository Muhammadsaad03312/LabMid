provider "aws" {
  region = "eu-north-1"
}

resource "aws_security_group" "web_sg" {
  name = "web-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"

  security_groups = [aws_security_group.web_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install nginx -y
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    Name = "Terraform-Web"
  }
}