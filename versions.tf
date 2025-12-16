terraform {
  required_providers {
    clumio = {
      source  = "clumio-code/clumio"
      version = ">=0.16.0, <0.18.0"
    }
    aws = {}
    random = {}
  }
}
