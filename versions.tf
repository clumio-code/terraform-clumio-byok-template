terraform {
  required_providers {
    clumio = {
      source  = "clumio-code/clumio"
      version = ">=0.21.0, <0.23.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
    random = {}
  }
}
