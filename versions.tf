terraform {
  required_providers {
    clumio = {
      source  = "clumio-code/clumio"
      version = ">=0.4.0, <0.6.0"
    }
    aws = {}
    random = {}
  }
}
