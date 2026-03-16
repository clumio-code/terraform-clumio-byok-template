terraform {
  required_providers {
    clumio = {
      source  = "clumio-code/clumio"
      version = ">=0.17.0, <0.19.0"
    }
    aws = {}
    random = {}
  }
}
