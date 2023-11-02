provider "aws" {
  access_key = var.aws_access_key_id  # IAMアクセスキーをここに設定
  secret_key = var.aws_secret_access_key  # IAMシークレットキーをここに設定
  region     = var.region  # 適切なリージョンを指定
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.latest-ubuntu.id
  instance_type = "t3.micro"

  subnet_id = aws_subnet.example.id
  associate_public_ip_address = true

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "tf"
      host        = var.private_ip
      private_key = file("${var.SSH_KEY_PATH}/id_rsa")
    }
  }
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
}
