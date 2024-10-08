data aws_caller_identity current {
  provider = aws
}

data aws_region current {
  provider = aws
}

data "aws_iam_policy_document" "byok_policy_document" {
  statement {
    effect  = "Allow"
    actions = [ "kms:*" ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "role_policy_document" {
  statement {
    sid = "ReplicationManagement"
    effect  = "Allow"
    actions = [
      "kms:PutKeyPolicy",
      "kms:ReplicateKey",
      "kms:TagResource",
    ]
    resources = [
      join("", [
          "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/",
          var.existing_cmk_id != "" ? var.existing_cmk_id : aws_kms_key.multi_region_cmk_key[0].id
      ])
    ]
  }
  statement {
      sid = "GrantManagement"
      effect  = "Allow"
      actions = [
        "kms:DescribeKey",
        "kms:CreateGrant",
        "kms:RetireGrant",
        "kms:RevokeGrant",
        "kms:ListGrants",
        "kms:ListRetirableGrants"
      ]
      resources = [
        join("", [
            "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/",
            var.existing_cmk_id != "" ? var.existing_cmk_id : aws_kms_key.multi_region_cmk_key[0].id
        ])
      ]
    }
  statement {
    sid = "ReplicaKeyCreation"
    effect  = "Allow"
    actions = [
      "kms:CreateKey"
    ]
    resources = ["*"]
  }
}

resource "random_uuid" "external_id" {
}

# Assume role policy that allows arenas to assume the control plane role.
data "aws_iam_policy_document" "assume_role_policy_document" {
  version = "2012-10-17"
  statement {
    sid     = "AllowClumioToAssumeRole"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["arn:aws:iam::${var.clumio_account_id}:role/ClumioCustomerProtectRole"]
      type        = "AWS"
    }
    effect = "Allow"
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "sts:ExternalId"
      values   = [var.external_id != "" ? var.external_id : random_uuid.external_id.id]
    }
  }
}

resource "aws_kms_key" "multi_region_cmk_key" {
  count                    = var.existing_cmk_id != "" ? 0 : 1
  multi_region             = true
  description              = "The CMK for Clumio to use to encrypt backups"
  key_usage                = "ENCRYPT_DECRYPT"
  is_enabled               = true
  enable_key_rotation      = true
  deletion_window_in_days  = var.deletion_window_in_days
  policy                   = data.aws_iam_policy_document.byok_policy_document.json
  tags                     = var.key_tags
}

resource "aws_kms_alias" "key_alias" {
  name = "alias/${var.key_alias_name}"
  target_key_id = var.existing_cmk_id != "" ? var.existing_cmk_id : aws_kms_key.multi_region_cmk_key[0].id
}

resource "aws_iam_role" "byok_mgmt_role" {
  name = var.role_name
  path = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_document.json
  inline_policy {
    name = "ReplicaAndGrantManagement"
    policy = data.aws_iam_policy_document.role_policy_document.json
  }
}

resource "clumio_post_process_kms" "clumio_phone_home" {
  depends_on = [
    aws_kms_key.multi_region_cmk_key,
    time_sleep.wait_30_seconds_for_iam_propagation,
  ]
  token = var.token
  account_id = var.account_native_id
  region = data.aws_region.current.name
  role_id = aws_iam_role.byok_mgmt_role.id
  role_arn = aws_iam_role.byok_mgmt_role.arn
  role_external_id = var.external_id != "" ? var.external_id : random_uuid.external_id.id
  multi_region_cmk_key_id = var.existing_cmk_id != "" ? var.existing_cmk_id : aws_kms_key.multi_region_cmk_key[0].id
  created_multi_region_cmk = var.existing_cmk_id == ""
  template_version = 13
  clumio_iam_role_principal = "arn:aws:iam::${var.clumio_account_id}:role/ClumioCustomerProtectRole"
}

resource "time_sleep" "wait_30_seconds_for_iam_propagation" {
  depends_on = [
    aws_iam_role.byok_mgmt_role,
  ]
  create_duration = "30s"
}
