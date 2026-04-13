terraform {
  required_providers {
    clumio = {
      source  = "clumio-code/clumio"
      version = ">=0.18.0, <0.20.0"
    }
    aws = {}
    random = {}
  }
}
