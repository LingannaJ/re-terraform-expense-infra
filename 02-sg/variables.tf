variable "project_name" {
    type = string
    default = "expense"
  
}

variable "environment" {
    type = string
    default = "dev"
  
}



variable "common_tags" {
    type = map
  default = {
   project ="expense"
   environment = "dev"
   terraform = true
  }
}

variable "vpn_sg_rules" {
    default = [
    {
      from_port = 943
      to_port = 943
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
        {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port = 1194
      to_port = 1194
      protocol = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  ]
  
}