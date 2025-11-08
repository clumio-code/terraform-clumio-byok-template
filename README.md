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
```
In the above example, since the regions in which the replica keys will be installed is based on the regions returned by the clumio_wallet resource, it has to be created first: `terraform apply -target clumio_wallet.test_wallet`.
Once the wallet resource is created, the rest of the resources can be created using `terraform apply`.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_clumio"></a> [clumio](#requirement\_clumio) | >=0.15.0, <0.17.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_clumio"></a> [clumio](#provider\_clumio) | >=0.15.0, <0.17.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.byok_mgmt_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_kms_alias.key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.multi_region_cmk_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [clumio_post_process_kms.clumio_phone_home](https://registry.terraform.io/providers/clumio-code/clumio/latest/docs/resources/post_process_kms) | resource |
| [random_uuid.external_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [time_sleep.wait_30_seconds_for_iam_propagation](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.byok_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.role_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_native_id"></a> [account\_native\_id](#input\_account\_native\_id) | Wallet account native ID. | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The Wallet AWS region to deploy resources. | `string` | `""` | no |
| <a name="input_clumio_account_id"></a> [clumio\_account\_id](#input\_clumio\_account\_id) | Clumio account ID. | `string` | n/a | yes |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | Primary and replica key deletion window in days. | `number` | `30` | no |
| <a name="input_existing_cmk_id"></a> [existing\_cmk\_id](#input\_existing\_cmk\_id) | The ID of an existing multi-region CMK to use (optional). | `string` | `""` | no |
| <a name="input_external_id"></a> [external\_id](#input\_external\_id) | The external ID to use when assuming the role. | `string` | `""` | no |
| <a name="input_key_alias_name"></a> [key\_alias\_name](#input\_key\_alias\_name) | Alias name for multi-region CMK to be used (optional). Default value is clumio-byok. | `string` | `"clumio-byok"` | no |
| <a name="input_key_tags"></a> [key\_tags](#input\_key\_tags) | Tags for mutli-region CMK to be created. Not used if existing\_cmk\_id is provided. | `map(string)` | `{}` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | The name to use for the role that Clumio will use to manage the key. | `string` | `"ClumioKMSRole"` | no |
| <a name="input_token"></a> [token](#input\_token) | The AWS integration ID token. | `string` | n/a | yes |

## Outputs

No outputs.

<!-- END_TF_DOCS -->
