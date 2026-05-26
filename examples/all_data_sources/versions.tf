terraform {
  required_providers {
    clumio = {
      source  = "clumio-code/clumio"
      version = ">=0.14.0, <0.16.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
  }
}
