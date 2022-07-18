variable "other_regions" {
  description = "AWS regions in which the replica keys should be created"
  type = list(string)
}

variable "user_self_managed_permission_model" {
  description = "User self-managed permission model."
  type = bool
  default = false
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

variable "administration_role_arn" {
  description = "The AWS administration role arn. If user_self_managed_permission_model is true then this value needs to be populated" 
  type = string
  default = ""
}
