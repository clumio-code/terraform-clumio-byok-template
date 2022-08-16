provider clumio{
  clumio_api_token = var.clumio_api_token
  clumio_api_base_url = var.clumio_api_base_url
}

provider aws {}

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
