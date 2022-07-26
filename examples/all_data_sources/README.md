## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_clumio"></a> [clumio](#requirement\_clumio) | ~>0.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_clumio"></a> [clumio](#provider\_clumio) | ~>0.3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_clumio_byok_module"></a> [clumio\_byok\_module](#module\_clumio\_byok\_module) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [clumio_wallet.test_wallet](https://registry.terraform.io/providers/clumio-code/clumio/latest/docs/resources/wallet) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_clumio_api_base_url"></a> [clumio\_api\_base\_url](#input\_clumio\_api\_base\_url) | Base URL for Clumio APIs. | `string` | n/a | yes |
| <a name="input_clumio_api_token"></a> [clumio\_api\_token](#input\_clumio\_api\_token) | API Token required to invoke Clumio APIs. | `string` | n/a | yes |

## Outputs

No outputs.
