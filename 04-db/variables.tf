variable "project_name" {
    type = string
    default = "expense"
  
}

variable "environment" {
    type = string
    default = "dev"
  
}

variable "domain_name" {
    default = "shivdev.online"
  
}



variable "common_tags" {
    type = map
  default = {
   project ="expense"
   environment = "dev"
   terraform = true
  }
}

