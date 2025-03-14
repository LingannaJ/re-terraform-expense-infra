module "db" {
  source = "../../re-terraform-aws-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for DB Mysql instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "db"
  common_tags = var.common_tags

}

module "backend" {
  source = "../../re-terraform-aws-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for backend instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "backend"
  common_tags = var.common_tags

}
module "app_alb" {
  source = "../../re-terraform-aws-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for App-alb instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "app_alb"
  common_tags = var.common_tags

}

module "frontend" {
  source = "../../re-terraform-aws-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for frotnend instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "frontend"
  common_tags = var.common_tags
}

module "web_alb" {
  source = "../../re-terraform-aws-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for Web-alb instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "web_alb"
  common_tags = var.common_tags

}

module "bastion" {
  source = "../../re-terraform-aws-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for bastion instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "bastion"
  common_tags = var.common_tags
}

module "vpn" {
  source = "../../re-terraform-aws-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for VPN instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "vpn"
  common_tags = var.common_tags

}


###  DB is accepting connections from backend,bastion,vpn
resource "aws_security_group_rule" "db-backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id      = module.backend.sg_id
  security_group_id = module.db.sg_id
  }
  resource "aws_security_group_rule" "db-bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id      = module.bastion.sg_id
  security_group_id = module.db.sg_id
  }
  resource "aws_security_group_rule" "db-vpn" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id      = module.vpn.sg_id
  security_group_id = module.db.sg_id
  }
###  backend is accepting connections from app_alb,bastion,vpn_ssh,vpn_http
resource "aws_security_group_rule" "backend_app_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb.sg_id # source is where you are getting traffic from
  security_group_id = module.backend.sg_id
}
resource "aws_security_group_rule" "backend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.backend.sg_id
}
resource "aws_security_group_rule" "backend_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.backend.sg_id
}
resource "aws_security_group_rule" "backend_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.backend.sg_id
}
###  app_alb is accepting connections from frontend,vpn,bastion
resource "aws_security_group_rule" "app_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source is where you are getting traffic from
  security_group_id = module.app_alb.sg_id
}
resource "aws_security_group_rule" "app_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id # source is where you are getting traffic from
  security_group_id = module.app_alb.sg_id
}
resource "aws_security_group_rule" "app_alb_frontend" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id # source is where you are getting traffic from
  security_group_id = module.app_alb.sg_id
}
###  frontend is accepting connections from web_alb,bastion,vpn
resource "aws_security_group_rule" "frontend_web_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_alb.sg_id
  security_group_id = module.frontend.sg_id
}
resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.frontend.sg_id
}
resource "aws_security_group_rule" "frontend_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.frontend.sg_id
}
###  web_alb is accepting connections from public (http-80,https-443)
resource "aws_security_group_rule" "web_alb_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.web_alb.sg_id
}
resource "aws_security_group_rule" "web_alb_public_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.web_alb.sg_id
}
###  bastion is accepting connections from public
  resource "aws_security_group_rule" "bastion-public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
  }

### vpn accepting connection from below ports
  resource "aws_security_group_rule" "vpn-public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
  }

  resource "aws_security_group_rule" "vpn-port-443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
  }

    resource "aws_security_group_rule" "vpn-port-943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
  }

  resource "aws_security_group_rule" "vpn-port-1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
  }

  #added as part of Jenkins CICD
resource "aws_security_group_rule" "backend_default_vpc" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["172.31.0.0/16"]
  security_group_id = module.backend.sg_id
}

#added as part of Jenkins CICD
resource "aws_security_group_rule" "frontend_default_vpc" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["172.31.0.0/16"]
  security_group_id = module.frontend.sg_id
}