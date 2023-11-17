# 作成したEC2のパブリックIPアドレスを出力
output "ec2_global_ips" {
  value = "${aws_instance.example.public_ip}"
}

# sshコマンドを出力
output "ssh_command" {
  value = "ssh -i ${var.ssh_key_path}/ec2_keypair.pem ubuntu@${aws_instance.example.public_ip}"
}