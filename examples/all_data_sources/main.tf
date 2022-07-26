data aws_caller_identity current {
}

data aws_region current {
}


resource "clumio_wallet" "test_wallet" {
  account_native_id = data.aws_caller_identity.current.account_id
}

################################################################################
# Clumio BYOK Module
################################################################################

module clumio_byok_module {
  providers = {
    clumio = clumio
  }
  source = "../../"
  regions = setsubtract(clumio_wallet.test_wallet.supported_regions, toset([data.aws_region.current.name]))
  account_native_id = clumio_wallet.test_wallet.account_native_id
  clumio_control_plane_account_id = clumio_wallet.test_wallet.clumio_control_plane_account_id
  clumio_account_id = clumio_wallet.test_wallet.clumio_account_id
  token = clumio_wallet.test_wallet.token
}
