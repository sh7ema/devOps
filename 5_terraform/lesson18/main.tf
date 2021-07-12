provider "aws" {
  region = var.region
}

data "aws_ami" "latest_ubuntu_linux" {
  owners = ["099720109477"]
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_server.id
  tags = merge(var.common_tags, {Name = "${var.common_tags["Environment"]} Server IP"})
}

resource "aws_instance" "my_server" {
  ami = data.aws_ami.latest_ubuntu_linux.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.my_server.id]
  monitoring = var.enable_detailed_monitoring

  tags = merge(var.common_tags, {Name = "${var.common_tags["Environment"]} Server IP"})
 }

resource "aws_security_group" "my_server" {
  name = "WebServer Security Group"
  description = "My First SecurityGroup"

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {Name = "${var.common_tags["Environment"]} Server SecurityGroup"})
}
