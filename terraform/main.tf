terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }

  required_version = ">= 1.1.0"

  backend "s3" {
    bucket = "terraform-state-mario"
    key    = "state/terraform_state.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region     = var.aws_region
}