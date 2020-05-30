data "aws_ami" "docker_ami" {
  most_recent = true

  filter {
    name   = "image-id"
    # Amazon Linux
    values = ["ami-026dea5602e368e96"]
  }

  owners = ["amazon"]
}

resource "aws_security_group" "tcp_port_25565" {
    name        = "minecraft_tcp_forwarding"
    description = "Forward inbound tcp traffic to port 25565"

    # minecraft
    ingress {
        from_port   = 25565
        to_port     = 25565
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # ssh
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "minecraft_tcp_forwarding"
    }
}

resource "aws_instance" "minecraft" {
  ami           =  data.aws_ami.docker_ami.id
  instance_type = "t2.micro"

  tags = {
    Name = "Minecraft Server Terraform"
  }
  vpc_security_group_ids = [aws_security_group.tcp_port_25565.id]
}

resource "aws_eip" "lb" {
  instance = aws_instance.minecraft.id
  vpc      = true
}

output "public_ip" {
  value = aws_instance.minecraft.public_ip
}