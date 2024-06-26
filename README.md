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
    aws = aws
  }
  source = "../../"
  account_native_id = clumio_wallet.test_wallet.account_native_id
  clumio_account_id = clumio_wallet.test_wallet.clumio_account_id
  token = clumio_wallet.test_wallet.token
}
```
The resources can be created using `terraform apply`.

## Requirements

| Name | Version |
|------|---------|
 <a name="requirement_clumio"></a> [clumio](#requirement\_clumio) | >=0.8.0, <0.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_clumio"></a> [clumio](#provider\_clumio) |  >=0.8.0, <0.10.0 |
| <a name="provider_random"></a> [clumio](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kms_key.multi_region_cmk_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [clumio_post_process_kms.clumio_phone_home](https://registry.terraform.io/providers/clumio-code/clumio/latest/docs/resources/clumio_post_process_kms) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.byok_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.assume_role_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.role_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.byok_mgmt_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_native_id"></a> [account\_native\_id](#input\_account\_native\_id) | Wallet account native ID. | `string` | n/a | yes |
| <a name="input_clumio_account_id"></a> [clumio\_account\_id](#input\_clumio\_account\_id) | Clumio account ID. | `string` | n/a | yes |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | Primary and replica key deletion window in days. | `number` | `30` | no |
| <a name="input_token"></a> [token](#input\_token) | The AWS integration ID token. | `string` | n/a | yes |
| <a name="input_role_name"></a> [token](#input\_role_name) | The name with which to create the AWS IAM role to manage the CMK. | `string` | ClumioKMSRole | no |
| <a name="input_external_id"></a> [token](#input\_external_id) | The external ID to use when assuming the AWS IAM role. | `string` | random | no |
| <a name="input_existing_cmk_id"></a> [token](#input\_existing_cmk_id) | The ID of an existing CMK to use as the BYOK encryption key. | `string` | n/a | no |

## Outputs

No outputs.


<!-- END_TF_DOCS -->
