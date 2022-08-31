variable "other_regions" {
  description = "AWS regions in which the replica keys should be created"
  type = list(string)
}

variable "account_native_id" {
  description = "Wallet account native ID."
  type = string
}

variable "clumio_account_id" {
  description = "Clumio account ID."
  type = string
}

variable "clumio_control_plane_account_id" {
  description = "Clumio control-plane account ID."
  type = string
}

variable "token" {
  description = "The AWS integration ID token."
  type = string
}

variable "deletion_window_in_days" {
  description = "Primary and replica key deletion window in days."
  type = number
  default = 30
}