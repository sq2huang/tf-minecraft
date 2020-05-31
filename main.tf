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
        from_port        = 25565
        to_port          = 25565
        protocol         = "tcp"
        ipv6_cidr_blocks = ["::/0"]
        cidr_blocks      = ["0.0.0.0/0"]
    }

    # ssh
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "minecraft_tcp_forwarding"
    }
}

resource "aws_key_pair" "ssh_key" {
    key_name   = "minecraft-tf"
    public_key = file("~/.ssh/minecraft-tf.pub")
}

resource "aws_instance" "minecraft" {
    key_name      = aws_key_pair.ssh_key.key_name
    ami           =  data.aws_ami.docker_ami.id
    instance_type = "t2.small"

    tags = {
        Name = "Minecraft Server Terraform"
    }
    vpc_security_group_ids = [aws_security_group.tcp_port_25565.id]

    connection {
        type        ="ssh"
        host        = self.public_ip
        user        = "ec2-user"
        private_key = file("~/.ssh/minecraft-tf")
    }

    provisioner "remote-exec" {
        script = "start-server.sh"
    }
}

resource "aws_eip" "elastic_ip" {
    instance = aws_instance.minecraft.id
    vpc      = true
}

output "public_ip" {
    value = aws_eip.elastic_ip.public_ip
}
