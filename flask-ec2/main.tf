# SSH Key Configuration
resource "tls_private_key" "ec2_instance_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Generate a Private Key and encode it as PEM.
resource "aws_key_pair" "ec2_instance_key_pair" {
  key_name   = "${replace(lower(var.instance_name), " ", "-")}_key"
  public_key = tls_private_key.ec2_instance_key.public_key_openssh

  provisioner "local-exec" {
    command     = "echo '${tls_private_key.ec2_instance_key.private_key_pem}' > ./ec2_instance_key.pem"
    interpreter = ["pwsh", "-Command"]
  }
}

# Security group for Flask instance
resource "aws_security_group" "flask_sg" {
  name        = "flask-app-sg"
  description = "Allow inbound HTTP traffic and SSH"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "flask-app-sg"
  }
}

# EC2 instance
resource "aws_instance" "flask_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.flask_sg.id]
  key_name                    = aws_key_pair.ec2_instance_key_pair.id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name

  user_data = data.template_cloudinit_config.setup-script.rendered

  tags = {
    Name = var.instance_name
  }

  monitoring = true
}
