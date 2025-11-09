terraform {
  required_providers {
    clumio = {
      source  = "clumio-code/clumio"
      version = ">=0.15.0, <0.17.0"
    }
    aws = {}
    random = {}
  }
}
