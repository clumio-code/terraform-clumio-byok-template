terraform {
  required_providers {
    clumio = {
      source  = "clumio-code/clumio"
      version = ">=0.20.0, <0.22.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
    random = {}
  }
}
