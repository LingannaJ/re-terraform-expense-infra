module "aws_vpc" {
    # source = "../../re-terraform-aws-vpc"
    source = "git::https://github.com/LingannaJ/re-terraform-expense-infra.git?ref=main"
    common_tags = var.common_tags
    project_name = var.project_name
    environment = var.environment
    public_subnet_cidrs = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
    database_subnet_cidrs = var.database_subnet_cidrs
    is_peering_required = var.is_peering_required
    
}