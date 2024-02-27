terraform {
  required_providers {
    clumio = {
      source  = "clumio-code/clumio"
      version = ">=0.5.1, <0.7.0"
    }
    aws = {}
    random = {}
  }
}
