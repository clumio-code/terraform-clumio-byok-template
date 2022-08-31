data aws_caller_identity current {
  provider = aws
}

data aws_region current {
  provider = aws
}

data "aws_iam_policy_document" "byok_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "kms:*"
    ]
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:GenerateDataKey*",
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:DescribeKey",
      "kms:CreateGrant",
      "kms:RetireGrant",
      "kms:ListGrants",
      "kms:ListRetirableGrants"
    ]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.clumio_control_plane_account_id}:root",
        "arn:aws:iam::${var.clumio_account_id}:root"
      ]
    }
    resources = ["*"]
  }
}

resource "aws_kms_key" "multi_region_cmk_key" {
  multi_region             = true
  description              = "The CMK for Clumio to use to encrypt backups"
  key_usage                = "ENCRYPT_DECRYPT"
  is_enabled               = true
  enable_key_rotation      = true
  deletion_window_in_days  = var.deletion_window_in_days
  policy                   = data.aws_iam_policy_document.byok_policy_document.json
}

resource "aws_kms_replica_key" "replica_uw1" {
  provider = aws.uw1
  count = contains(var.other_regions, "us-west-1") ? 1 : 0
  description             = "The CMK for Clumio to use to encrypt backups"
  deletion_window_in_days = var.deletion_window_in_days
  primary_key_arn         = aws_kms_key.multi_region_cmk_key.arn
  tags = {
    "Vendor" = "Clumio",
    "Name" = var.token
  }
  policy                  = data.aws_iam_policy_document.byok_policy_document.json
}

resource "aws_kms_replica_key" "replica_uw2" {
  provider = aws.uw2
  count = contains(var.other_regions, "us-west-2") ? 1 : 0
  description             = "The CMK for Clumio to use to encrypt backups"
  deletion_window_in_days = var.deletion_window_in_days
  primary_key_arn         = aws_kms_key.multi_region_cmk_key.arn
  tags = {
    "Vendor" = "Clumio",
    "Name" = var.token
  }
  policy                  = data.aws_iam_policy_document.byok_policy_document.json
}

resource "aws_kms_replica_key" "replica_ue1" {
  provider = aws.ue1
  count = contains(var.other_regions, "us-east-1") ? 1 : 0
  description             = "The CMK for Clumio to use to encrypt backups"
  deletion_window_in_days = var.deletion_window_in_days
  primary_key_arn         = aws_kms_key.multi_region_cmk_key.arn
  tags = {
    "Vendor" = "Clumio",
    "Name" = var.token
  }
  policy                  = data.aws_iam_policy_document.byok_policy_document.json
}

resource "aws_kms_replica_key" "replica_ue2" {
  provider = aws.ue2
  count = contains(var.other_regions, "us-east-2") ? 1 : 0
  description             = "The CMK for Clumio to use to encrypt backups"
  deletion_window_in_days = var.deletion_window_in_days
  primary_key_arn         = aws_kms_key.multi_region_cmk_key.arn
  tags = {
    "Vendor" = "Clumio",
    "Name" = var.token
  }
  policy                  = data.aws_iam_policy_document.byok_policy_document.json
}

resource "aws_kms_replica_key" "replica_cc1" {
  provider = aws.cc1
  count = contains(var.other_regions, "ca-central-1") ? 1 : 0
  description             = "The CMK for Clumio to use to encrypt backups"
  deletion_window_in_days = var.deletion_window_in_days
  primary_key_arn         = aws_kms_key.multi_region_cmk_key.arn
  tags = {
    "Vendor" = "Clumio",
    "Name" = var.token
  }
  policy                  = data.aws_iam_policy_document.byok_policy_document.json
}

resource "aws_kms_replica_key" "replica_ec1" {
  provider = aws.ec1
  count = contains(var.other_regions, "eu-central-1") ? 1 : 0
  description             = "The CMK for Clumio to use to encrypt backups"
  deletion_window_in_days = var.deletion_window_in_days
  primary_key_arn         = aws_kms_key.multi_region_cmk_key.arn
  tags = {
    "Vendor" = "Clumio",
    "Name" = var.token
  }
  policy                  = data.aws_iam_policy_document.byok_policy_document.json
}

resource "aws_kms_replica_key" "replica_ew1" {
  provider = aws.ew1
  count = contains(var.other_regions, "eu-west-1") ? 1 : 0
  description             = "The CMK for Clumio to use to encrypt backups"
  deletion_window_in_days = var.deletion_window_in_days
  primary_key_arn         = aws_kms_key.multi_region_cmk_key.arn
  tags = {
    "Vendor" = "Clumio",
    "Name" = var.token
  }
  policy                  = data.aws_iam_policy_document.byok_policy_document.json
}

resource "clumio_post_process_kms" "clumio_phone_home" {
  depends_on = [
    aws_kms_key.multi_region_cmk_key,
    aws_kms_replica_key.replica_uw1,
    aws_kms_replica_key.replica_uw2,
    aws_kms_replica_key.replica_ue1,
    aws_kms_replica_key.replica_ue2,
    aws_kms_replica_key.replica_cc1,
    aws_kms_replica_key.replica_ec1,
    aws_kms_replica_key.replica_ew1
  ]
  token = var.token
  account_id = var.account_native_id
  region = data.aws_region.current.name
  multi_region_cmk_key_id = aws_kms_key.multi_region_cmk_key.id
  other_regions = length(var.other_regions) > 0 ? join(", ", var.other_regions) : ""
}
