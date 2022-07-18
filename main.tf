data aws_caller_identity current {}

data aws_region current {}

resource "aws_kms_key" "multi_region_cmk_key" {
  multi_region             = true
  description              = "The CMK for Clumio to use to encrypt backups"
  key_usage                = "ENCRYPT_DECRYPT"
  is_enabled               = true
  enable_key_rotation      = true
  deletion_window_in_days  = 30
  policy                   = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${var.clumio_control_plane_account_id}:root",
                    "arn:aws:iam::${var.clumio_account_id}:root"
                ]
            },
            "Action": [
                "kms:GenerateDataKey",
                "kms:GenerateDataKeyWithoutPlaintext",
                "kms:Decrypt",
                "kms:Encrypt",
                "kms:ReEncrypt",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_cloudformation_stack_set" "replica_keys" {
  count = var.other_regions != "" ? 1 : 0
  name = "ClumioKMS-Replica"
  description = "Replicate multi-region CMK in your AWS account for CLumio to use to encrypt backups in other regions"
  permission_model = var.user_self_managed_permission_model ? "SELF_MANAGED" : "SERVICE_MANAGED"
  administration_role_arn = var.administration_role_arn
  template_body = <<TEMPLATE
AWSTemplateFormatVersion: '2010-09-09'
Description: 'Replicate multi-region CMK in your AWS account for Clumio to use to encrypt backups in other regions'
Resources:
 ReplicaKey:
   Type: AWS::KMS::ReplicaKey
   Properties:
     Description: 'The CMK for Clumio to use to encrypt backups'
     Enabled: True
     KeyPolicy:
       Version: '2012-10-17'
       Statement:
         - Effect: 'Allow'
           Principal:
             AWS: 'arn:aws:iam::${data.aws_caller_identity.current.account_id}:root'
           Action:
             - 'kms:*'
           Resource: '*'
         - Effect: 'Allow'
           Principal:
             AWS:
               - 'arn:aws:iam::${var.clumio_control_plane_account_id}:root'
               - 'arn:aws:iam::${var.clumio_account_id}:root'
           Action:
             - 'kms:GenerateDataKey'
             - 'kms:GenerateDataKeyWithoutPlaintext'
             - 'kms:Decrypt'
             - 'kms:Encrypt'
             - 'kms:ReEncrypt'
             - 'kms:DescribeKey'
           Resource: '*'
     PendingWindowInDays: 30
     PrimaryKeyArn: '${aws_kms_key.multi_region_cmk_key.arn}'
     Tags:
       - Key: 'Vendor'
         Value: 'Clumio'
       - Key: 'Name'
         Value: '${var.token}'
TEMPLATE
}

resource "aws_cloudformation_stack_set_instance" "replicas" {
  for_each = toset(var.other_regions)
  account_id     = data.aws_caller_identity.current.account_id
  region         = each.key
  stack_set_name = aws_cloudformation_stack_set.replica_keys[0].name
}

resource "clumio_post_process_kms" "clumio_phone_home" {
  token = var.token
  account_id = var.account_native_id
  region = data.aws_region.current.name
  multi_region_cmk_key_id = aws_kms_key.multi_region_cmk_key.id
  stack_set_id = aws_cloudformation_stack_set.replica_keys[0].id
  other_regions = length(var.other_regions) > 0 ? join(", ", var.other_regions) : ""
}
