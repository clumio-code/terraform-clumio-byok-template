<!-- BEGIN_TF_DOCS -->

# Clumio BYOK Terraform Module

Terraform module to install the Clumio required AWS BYOK resources in the customer AWS account.

## Usage:
This module is to be used along with the resource clumio_wallet as some of the inputs for the module are obtained from the output of clumio_wallet  resource.
Below is an example of using the module:

```hcl
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
    aws = aws
    clumio = clumio
  }
  source = "../../"
  regions = ["us-east-1", "us-east-2"]
  user_self_managed_permission_model = true
  account_native_id = clumio_wallet.test_wallet.account_native_id
  clumio_control_plane_account_id = clumio_wallet.test_wallet.clumio_control_plane_account_id
  clumio_arena_account_id = clumio_wallet.test_wallet.clumio_arena_account_id
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_clumio"></a> [clumio](#requirement\_clumio) | =0.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_clumio"></a> [clumio](#provider\_clumio) | =0.3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudformation_stack_set.replica_keys](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_set) | resource |
| [aws_cloudformation_stack_set_instance.replicas](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_set_instance) | resource |
| [aws_kms_key.multi_region_cmk_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| clumio_post_process_kms.clumio_phone_home | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_native_id"></a> [account\_native\_id](#input\_account\_native\_id) | Wallet account native ID. | `string` | n/a | yes |
| <a name="input_administration_role_arn"></a> [administration\_role\_arn](#input\_administration\_role\_arn) | The AWS administration role arn. If user\_self\_managed\_permission\_model is true then this value needs to be populated | `string` | `""` | no |
| <a name="input_clumio_arena_account_id"></a> [clumio\_arena\_account\_id](#input\_clumio\_arena\_account\_id) | Clumio arena account ID. | `string` | n/a | yes |
| <a name="input_clumio_control_plane_account_id"></a> [clumio\_control\_plane\_account\_id](#input\_clumio\_control\_plane\_account\_id) | Clumio control-plane account ID. | `string` | n/a | yes |
| <a name="input_regions"></a> [regions](#input\_regions) | AWS regions in which the replica keys should be created | `list(string)` | n/a | yes |
| <a name="input_token"></a> [token](#input\_token) | The AWS integration ID token. | `string` | n/a | yes |
| <a name="input_user_self_managed_permission_model"></a> [user\_self\_managed\_permission\_model](#input\_user\_self\_managed\_permission\_model) | User self-managed permission model. | `bool` | `false` | no |

## Outputs

No outputs.


<!-- END_TF_DOCS -->
