provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 1.3"

  backend "s3" {
    bucket  = "terragrunt-state-hugo-532582682531"
    key     = "infra.tfstate"
    region  = "us-east-1"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
