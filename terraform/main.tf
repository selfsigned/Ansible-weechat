provider "aws" {
  region = "${var.region}"
}

resource "aws_instance" "irc" {
  ami             = "ami-0697abcfa8916e673"
  instance_type   = "t2.micro"
  key_name        = "${aws_key_pair.ssh.id}"
  security_groups = ["${aws_security_group.irc.name}"]

  tags {
    Name = "irc"
    role = "personal"
  }

  root_block_device {
    volume_size           = "${var.drive_size}"
    delete_on_termination = true
  }

  connection {
    user        = "ubuntu"
    private_key = "${file(var.ssh_privkey_path)}"
  }

  # Setting up python for ansible
  provisioner "remote-exec" {
    inline = [
      "sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install python",
    ]
  }
}

# resource "aws_efs_file_system" "weechat" {
#   creation_token = "weechat"
#   encrypted      = true

#   tags {
#     Name = "weechat"
#     role = "personal"
#   }
# }

resource "aws_security_group" "irc" {
  name        = "sec_group_irc"
  description = "Security group for irc vps"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Weechat-Relay access from anywhere
  ingress {
    from_port   = 8001
    to_port     = 8001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "ssh" {
  key_name   = "local_admin_key"
  public_key = "${file(var.ssh_pubkey_path)}"
}
