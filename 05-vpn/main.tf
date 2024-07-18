resource "aws_key_pair" "vpn" {
  key_name   = "openvpn"
  # you can paste the public key directly like this
  # public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII1GOLgxX0XYtGNz1DqOG/MCH8fJK2VVy0ovSX39wvkA Dell@DESKTOP-P9SRT12"
  public_key = file("~/.ssh/openvpn2.pub")
  # ~ means windows home directory
}

module "vpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  key_name = aws_key_pair.vpn.key_name
  name = "${var.project_name}-${var.environment}-vpn"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  # convert StringList to list and get first element
  subnet_id = local.public_subnet_id
  ami = data.aws_ami.ami_info.id
  
  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-vpn"
    }
  )
}

