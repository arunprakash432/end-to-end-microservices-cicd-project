terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "opentelemetry-state-bucket-12345"
    key            = "global/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "opentelemetry-lock-table"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}
