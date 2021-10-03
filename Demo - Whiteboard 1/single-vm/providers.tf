# this file will contain all the providers
# it will help with versioning and dependency control

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.61.0"
    }
  }
}

# #variable_change remember to put the region into a new var file
provider "aws" {
  region = "us-east-1"
}