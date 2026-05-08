terraform {
  required_providers {
    clumio = {
      source  = "clumio-code/clumio"
      version = ">=0.19.0, <0.21.0"
    }
    aws    = {}
    random = {}
  }
}
