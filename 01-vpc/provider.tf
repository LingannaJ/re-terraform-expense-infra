terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.56.1"
    }
  }
backend "s3" {
    bucket = "my-practice-s3bucket"
    key    = "expense-infra-dev-vpc"
    region = "us-east-1"
    dynamodb_table = "my-practce-dynamolock"
  }

}

provider "aws" {
  # Configuration options
}