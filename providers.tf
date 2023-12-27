terraform {
  cloud {
    organization = "GoGreen-project"

    workspaces {
      name = "Gogreen-project"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

}
provider "aws" {
  region = "us-west-2"
}