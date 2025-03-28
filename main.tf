provider "aws" {
    region  = "us-east-1"
    profile = "Nani"
}

resource "aws_security_group" "web_server_sg" {
  name        = "web-server-sg"
  description = "Allow SSH and HTTP traffic"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with your IP for better security
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web-server" {
  ami           = "ami-071226ecf16aa7d96"
  instance_type = "t2.micro"
  key_name      = "k8s"
  security_groups = [aws_security_group.web_server_sg.name]
  user_data     = <<-EOF
            #!/bin/bash
            sudo apt update -y
            sudo apt install apache2 -y
            sudo systemctl start apache2
            sudo systemctl enable apache2
            EOF

  tags = {
    Name = "web-server-instance"
  }
}

output "instance_public_ip" {
  value = aws_instance.web-server.public_ip
}

resource "local_file" "instance_ip" {
  content  = aws_instance.web-server.public_ip
  filename = "${path.module}/instance_ip.txt"
}