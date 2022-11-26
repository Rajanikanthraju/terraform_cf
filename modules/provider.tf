terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider requester
provider "aws" {
  region = var.infra_region_requestor
}

provider "aws" {
  alias = "peer"
  region = var.infra_region_acceptor
}
