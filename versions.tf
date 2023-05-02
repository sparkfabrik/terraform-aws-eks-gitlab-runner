terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.63"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.19"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.9"
    }


    random = {
      source  = "hashicorp/random"
      version = ">+ 3.5"
    }
  }
}
