terraform {
  required_providers {
    clumio = {
      source  = "clumio-code/clumio"
      version = ">=0.7.0, <0.9.0"
    }
    aws = {}
    random = {}
  }
}
