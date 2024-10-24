provider "aws" {
  region = "eu-north-1"
}

terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "= 1.14.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.32.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "= 2.15.0"
    }
  }

  required_version = "~> 1.0"
}
