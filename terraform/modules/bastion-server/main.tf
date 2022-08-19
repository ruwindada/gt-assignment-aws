# Creating Security Group for bastion host #
resource "aws_security_group" "instance" {
  name   = "govtech-bastion-instance"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creating bastion host #
resource "aws_instance" "bastion" {
  ami                         = lookup(var.amis, var.region)
  count                       = 1
  key_name                    = var.key_name
  vpc_security_group_ids      = ["${aws_security_group.instance.id}"]
  subnet_id                   = var.subnet_id
  source_dest_check           = false
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  tags = {
    Name = "bastion-server"
  }
}