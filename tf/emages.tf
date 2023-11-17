data "aws_ami" "latest_amzn2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    //values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}