data aws_caller_identity current {
}

data aws_region current {
}

resource "clumio_wallet" "test_wallet" {
  account_native_id = data.aws_caller_identity.current.account_id
  aws_region = data.aws_region.current.name
}

################################################################################
# Clumio BYOK Module
################################################################################

module clumio_byok_module {
  providers = {
    clumio = clumio
    aws = aws
  }
  source = "../../"
  account_native_id = clumio_wallet.test_wallet.account_native_id
  clumio_account_id = clumio_wallet.test_wallet.clumio_account_id
  aws_region = clumio_wallet.test_wallet.aws_region
  token = clumio_wallet.test_wallet.token
}
