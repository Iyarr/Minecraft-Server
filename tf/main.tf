provider "aws" {
  access_key = var.aws_access_key # IAMアクセスキーをここに設定
  secret_key = var.aws_secret_key # IAMシークレットキーをここに設定
  region     = var.aws_region     # 適切なリージョンを指定
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

// インターネットゲートウェイを作成
resource "aws_internet_gateway" "my_igw" {
  // 関連付けられるVPCの識別子
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "igw_route_table" {
  // 関連付けられるVPCの識別子
  vpc_id = aws_vpc.main.id

  route {
    // デフォルトゲートウェイの設定
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}
# ルートテーブル
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

# ルートテーブルのエントリ
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.my_igw.id
  destination_cidr_block = "0.0.0.0/0"
}

# サブネットとルートテーブルの関連付け
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "my_sg" {
  name        = "my-security-group"
  description = "My Security Group for Mincraft Server"

  vpc_id = aws_vpc.main.id

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
  
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# 公開鍵をAWSのKey pairにインポート
resource "aws_key_pair" "ec2_keypair" {
  key_name   = "ec2_keypair"
  public_key = file("${var.ssh_key_path}/ec2_keypair.pem.pub")
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.latest_amzn2.id
  instance_type = "t3.micro"

  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ec2_keypair.key_name
  security_groups          = [aws_security_group.my_sg.id]

  tags = {
    Name = "terraform-ec2"
  }

  provisioner "local-exec" {
    command = "sed -i '3s/.*/${aws_instance.example.public_ip}/' /home/ansible/hosts"
  }
}



