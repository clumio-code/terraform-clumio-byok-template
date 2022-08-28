variable "account_native_id" {
  description = "Wallet account native ID."
  type = string
}

variable "clumio_account_id" {
  description = "Clumio account ID."
  type = string
}

variable "token" {
  description = "The AWS integration ID token."
  type = string
}

variable "role_name" {
  description = "The name to use for the role that Clumio will use to manage the key."
  type = string
  default = ""
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
}

variable "deletion_window_in_days" {
  description = "Primary and replica key deletion window in days."
  type = number
  default = 30
}
