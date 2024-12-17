# Get Availability Zones
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "default" {
  default = true
}

locals {
  setup_script = templatefile("${path.module}/scripts/setup.sh", {
    aws_region = var.region
  })
}

data "cloudinit_config" "setup-script" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = local.setup_script
  }
}
