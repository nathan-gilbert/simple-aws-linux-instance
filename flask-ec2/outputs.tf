output "ec2_instance_public_ip" {
  value       = aws_instance.flask_instance.public_ip
  description = "Public IP of the EC2 instance hosting Flask"
}

output "ec2_instance_public_dns" {
  value       = aws_instance.flask_instance.public_dns
  description = "Public DNS of the EC2 instance hosting Flask"
}
