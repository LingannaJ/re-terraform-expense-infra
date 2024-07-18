variable "common_tags" {
    type = map
  default = {
    Project = "expense"
    Environment = "dev"
    Terraform = "true"
  }
}

variable "project_name" {
    type = string
default = "expense"
}

variable "environment" {
    type = string
  default = "dev"

}

## public subnet variables

variable "public_subnet_cidrs" {
    type = list
  default = ["10.0.1.0/24","10.0.2.0/24"]
}


## private subnet variables

variable "private_subnet_cidrs" {
    type = list
  default = ["10.0.11.0/24","10.0.12.0/24"]
}

## database subnet variables

variable "database_subnet_cidrs" {
    type = list
  default = ["10.0.22.0/24","10.0.25.0/24"]
}

# internet gateway variables

variable "nat_gateway_tags" {
    type = map
  default = {}
}

## peering variables

variable "is_peering_required" {
  default = true
  
}



