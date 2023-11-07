provider "aws" {
  access_key = var.aws_access_key     # IAMアクセスキーをここに設定
  secret_key = var.aws_secret_key # IAMシークレットキーをここに設定
  region     = var.aws_region                # 適切なリージョンを指定
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.latest-ubuntu.id
  instance_type = "t3.micro"

  subnet_id                   = aws_subnet.example.id
  associate_public_ip_address = true

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "tf"
      host        = var.private_ip
      private_key = file("${var.ssh_key_path}/id_rsa")
    }
    inline = [
      "sudo apt clean"
    ]
  }
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
}

// インターネットゲートウェイを作成
resource "aws_internet_gateway" "my_igw" {
  // 関連付けられるVPCの識別子
  vpc_id = aws_vpc.example.id
}

// VPC内でのルートテーブルとインターネットゲートウェイの設定
resource "aws_route_table" "my_route_table" {
  // 関連付けられるVPCの識別子
  vpc_id = aws_vpc.example.id
}

// ルートテーブルにルートエントリを追加
resource "aws_route" "route_to_igw" {
  // 追加するルートテーブルの識別子
  route_table_id         = aws_route_table.my_route_table.id
  // ルートエントリの宛先CIDRブロック
  destination_cidr_block = "0.0.0.0/0"
  // トラフィックの宛先ゲートウェイの識別子
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_security_group" "my_sg" {
  name        = "my-security-group"
  description = "My Security Group for Mincraft Server"

  vpc_id = aws_vpc.example.id

  # ポートやプロトコルの設定
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 19132
    to_port     = 19132
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
