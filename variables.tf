variable "account_native_id" {
  description = "Wallet account native ID."
  type = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_native_id))
    error_message = "account_native_id must be a 12-digit AWS account ID."
  }
}

variable "aws_region" {
  description = "The Wallet AWS region to deploy resources."
  type = string
  default = ""

  validation {
    condition     = var.aws_region == "" || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.aws_region))
    error_message = "aws_region must be empty or a valid AWS region (e.g. us-east-1)."
  }
}

variable "clumio_account_id" {
  description = "Clumio account ID."
  type = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.clumio_account_id))
    error_message = "clumio_account_id must be a 12-digit AWS account ID."
  }
}

variable "token" {
  description = "The AWS integration ID token."
  type = string
}

variable "role_name" {
  description = "The name to use for the role that Clumio will use to manage the key."
  type = string
  default = "ClumioKMSRole"

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]{1,64}$", var.role_name))
    error_message = "role_name must be 1-64 characters from the IAM role name set [a-zA-Z0-9+=,.@_-]."
  }
}

variable "external_id" {
  description = "The external ID to use when assuming the role."
  type = string
  default = ""
}

variable "existing_cmk_id" {
  description = "The ID of an existing multi-region CMK to use (optional)."
  type = string
  default = ""

  validation {
    condition     = var.existing_cmk_id == "" || can(regex("^mrk-[0-9a-f]{32}$", var.existing_cmk_id))
    error_message = "existing_cmk_id must be empty or a multi-region KMS key ID (mrk-<32 hex characters>)."
  }
}

variable "deletion_window_in_days" {
  description = "Primary and replica key deletion window in days."
  type = number
  default = 30

  validation {
    condition     = var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30 && var.deletion_window_in_days % 1 == 0
    error_message = "deletion_window_in_days must be an integer between 7 and 30."
  }
}

variable "key_tags" {
  description = "Tags for multi-region CMK to be created. Not used if existing_cmk_id is provided."
  type = map(string)
  default = {}
}

variable "key_alias_name" {
  description = "Alias name for multi-region CMK to be used (optional). Default value is clumio-byok."
  type = string
  default = "clumio-byok"

  validation {
    condition     = can(regex("^[a-zA-Z0-9:/_-]+$", var.key_alias_name)) && substr(var.key_alias_name, 0, 4) != "aws/"
    error_message = "key_alias_name must match [a-zA-Z0-9:/_-] and must not start with \"aws/\"."
  }
}
