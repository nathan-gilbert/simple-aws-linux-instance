output "ec2_instance_public_ip" {
  value = module.flask_ec2.ec2_instance_public_ip
}

output "ec2_instance_public_dns" {
  value = module.flask_ec2.ec2_instance_public_dns
}

output "ec2_instance_id" {
  value = module.flask_ec2.ec2_instance_id
}
