terraform {
  required_providers {
    clumio = {
      source  = "clumio-code/clumio"
      version = "~>0.3.0"
    }
    aws = {}
  }
}

provider aws {
  region = "us-east-1"
  alias = "ue1"
}

provider aws {
  region = "us-east-2"
  alias = "ue2"
}

provider aws {
  region = "us-west-1"
  alias = "uw1"
}

provider aws {
  region = "us-west-2"
  alias = "uw2"
}

provider aws {
  region = "ca-central-1"
  alias = "cc1"
}

provider aws {
  region = "eu-central-1"
  alias = "ec1"
}

provider aws {
  region = "eu-west-1"
  alias = "ew1"
}
