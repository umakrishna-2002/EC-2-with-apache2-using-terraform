provider "aws" {
    region  = "us-east-1"
    profile = "Nani"
}

resource "aws_instance" "web-server" {
  ami           = "ami-071226ecf16aa7d96"
  instance_type = "t2.micro"
  key_name      = "k8s"
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