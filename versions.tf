terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = ">=5.8.0"
    }
    helm = {
        source = "hashicorp/helm"
        version = ">=2.10.1, <3.0.0 "
    }
    kubernetes = {
        source = "hashicorp/kubernetes"
        version = ">=2.23.0"
    }
  }
  
}

provider "aws" {
  region = "ca-central-1"
}