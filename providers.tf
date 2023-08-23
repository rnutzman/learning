terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
  
#  shared_config_files      = ["/Users/Ron/.aws/config"]
#  shared_credentials_files = ["/Users/Ron/.aws/credentials"]
#  profile                  = "default"

}
