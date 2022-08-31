<!-- BEGIN_TF_DOCS -->

# Clumio BYOK Terraform Module

Terraform module to install the Clumio required AWS BYOK resources in the customer AWS account.

## Usage:
This module is to be used along with the resource clumio_wallet as some of the inputs for the module are obtained from the output of clumio_wallet  resource.
Below is an example of using the module:

```hcl
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
    aws.cc1 = aws.cc1
    aws.ec1 = aws.ec1
    aws.ew1 = aws.ew1
    aws.ue1 = aws.ue1
    aws.ue2 = aws.ue2
    aws.uw1 = aws.uw1
    aws.uw2 = aws.uw2
  }
  source = "../../"
  regions = setsubtract(clumio_wallet.test_wallet.supported_regions, toset([data.aws_region.current.name]))
  account_native_id = clumio_wallet.test_wallet.account_native_id
  clumio_control_plane_account_id = clumio_wallet.test_wallet.clumio_control_plane_account_id
  clumio_account_id = clumio_wallet.test_wallet.clumio_account_id
  token = clumio_wallet.test_wallet.token
}
```
In the above example, since the regions in which the replica keys will be installed is based on the regions returned by the clumio_wallet resource, it has to be created first: `terraform apply -target clumio_wallet.test_wallet`.
Once the wallet resource is created, the rest of the resources can be created using `terraform apply`.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_clumio"></a> [clumio](#requirement\_clumio) | ~>0.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_aws.cc1"></a> [aws.cc1](#provider\_aws.cc1) | n/a |
| <a name="provider_aws.ec1"></a> [aws.ec1](#provider\_aws.ec1) | n/a |
| <a name="provider_aws.ew1"></a> [aws.ew1](#provider\_aws.ew1) | n/a |
| <a name="provider_aws.ue1"></a> [aws.ue1](#provider\_aws.ue1) | n/a |
| <a name="provider_aws.ue2"></a> [aws.ue2](#provider\_aws.ue2) | n/a |
| <a name="provider_aws.uw1"></a> [aws.uw1](#provider\_aws.uw1) | n/a |
| <a name="provider_aws.uw2"></a> [aws.uw2](#provider\_aws.uw2) | n/a |
| <a name="provider_clumio"></a> [clumio](#provider\_clumio) | ~>0.3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kms_key.multi_region_cmk_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_replica_key.replica_cc1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_replica_key) | resource |
| [aws_kms_replica_key.replica_ec1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_replica_key) | resource |
| [aws_kms_replica_key.replica_ew1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_replica_key) | resource |
| [aws_kms_replica_key.replica_ue1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_replica_key) | resource |
| [aws_kms_replica_key.replica_ue2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_replica_key) | resource |
| [aws_kms_replica_key.replica_uw1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_replica_key) | resource |
| [aws_kms_replica_key.replica_uw2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_replica_key) | resource |
| [clumio_post_process_kms.clumio_phone_home](https://registry.terraform.io/providers/clumio-code/clumio/latest/docs/resources/clumio_post_process_kms) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.byok_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_native_id"></a> [account\_native\_id](#input\_account\_native\_id) | Wallet account native ID. | `string` | n/a | yes |
| <a name="input_clumio_account_id"></a> [clumio\_account\_id](#input\_clumio\_account\_id) | Clumio account ID. | `string` | n/a | yes |
| <a name="input_clumio_control_plane_account_id"></a> [clumio\_control\_plane\_account\_id](#input\_clumio\_control\_plane\_account\_id) | Clumio control-plane account ID. | `string` | n/a | yes |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | Primary and replica key deletion window in days. | `number` | `30` | no |
| <a name="input_other_regions"></a> [other\_regions](#input\_other\_regions) | AWS regions in which the replica keys should be created | `list(string)` | n/a | yes |
| <a name="input_token"></a> [token](#input\_token) | The AWS integration ID token. | `string` | n/a | yes |

## Outputs

No outputs.


<!-- END_TF_DOCS -->
