terraform {
  required_providers {
    clumio = {
      source  = "clumio-code/clumio"
      version = "~>0.3.0"
    }
    aws = {
      configuration_aliases = [ aws.uw1, aws.uw2, aws.ue1, aws.ue2, aws.cc1, aws.ew1, aws.ec1 ]
    }
  }
}
