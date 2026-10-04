provider "aws" {
  region = "us-west-1"

  default_tags {
    tags = {
      Project     = "terraform-aws-portfolio"
      Environment = "dev"
      ManagedBy   = "terraform"
    }
  }
}

terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
