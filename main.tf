
resource "aws_instance" "ansible" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  key_name               = "ssh-key"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  user_data              = file("ansible-script.sh")

  tags = {
    Name = "Ansible"
  }
}
resource "aws_key_pair" "keypair" {
  key_name   = "ssh-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCPLQaupjQH8kWPBDtdmbtMYJiLNRh/aGCFpjnyaUF6jOvgst9AV6q6+ZEy9Tu0ERIQKR3pSdB7Ak1x1tb/zd83l8fB/PTpGaRWzTIqJbYjvVNzUFPCW/6hh5siuk5lt5GpKQ70ZItVsbt5qd/idZ7UXx7CWM2kGe978GFJcTU66J8NEttJbUXkW/wCyHDZfYHKynPO0A0xzO3la6WBR4U0/YTz6/Q0SGVmse63TyvOEqG8N3Sc9yRsnj8KoSu6iYLiPuCvQTtSbNNwjU5Akzpoor6i48Lo7jwQp0deSDmKSsutj1q8ORlL7JUMHyZdEhX1y4ntbbozHkDr9KWYtfn9"
}
resource "aws_eip" "eip_ansible" {
  instance = aws_instance.ansible.id
  vpc      = true
}
resource "aws_eip" "eip_jenkins" {
  instance = aws_instance.jenkins.id
  vpc      = true
}
resource "aws_eip" "eip_k8s" {
  instance = aws_instance.k8s.id
  vpc      = true
}
resource "aws_instance" "jenkins" {
  ami                    = var.ami
  instance_type          = "t2.small"
  key_name               = "ssh-key"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "Jenkins"
  }
}
resource "aws_instance" "k8s" {
  ami                    = var.ami
  instance_type          = "t2.medium"
  key_name               = "ssh-key"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "Kubernetes"
  }
}