# The configuration provides necessary minimum options to securely setup Terraform remote state with S3 and DynamoDB
# Some usefull options are disabled to reduce AWS service usage in order to reduce billing 
resource "aws_s3_bucket" "s3_bucket_tf_state" {
  bucket        = "${var.prefix_s3}-${var.env}-tf-state"
  acl           = var.s3_acl
  force_destroy = var.force_destroy_enabled
  tags          = {
    Name        = "${var.prefix_s3}-${var.env}"
    Environment = var.env
  }

  versioning {
      enabled = var.s3_versioning_enabled
  }
  
  # server_side_encryption_configuration {
  #   rule {
  #     apply_server_side_encryption_by_default {
  #       sse_algorithm = "AES256"
  #     }
  #   }
  # }
  # 
  object_lock_configuration {
    object_lock_enabled = var.s3_object_lock_enabled
  }
   
  # logging {
  #   target_bucket = aws_s3_bucket.s3_bucket_logging.id
  #   target_prefix = "log/"
  # }
}

# Refer to the terraform documentation on s3_bucket_public_access_block at
# https://www.terraform.io/docs/providers/aws/r/s3_bucket_public_access_block.html
# for the nuances of the blocking options
resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block_tf_state" {
  bucket = aws_s3_bucket.s3_bucket_tf_state.id
  block_public_acls       = var.s3_block_public_acls
  block_public_policy     = var.s3_block_public_policy
  ignore_public_acls      = var.s3_ignore_public_acls
  restrict_public_buckets = var.s3_restrict_public_buckets
}

resource "aws_iam_user_policy" "iam_policy_s3_tf_state" {
  #bridgecrew:skip=BC_AWS_IAM_16:Skipping `Ensure IAM policies are attached only to groups or roles` check because this module intentionally attaches IAM policy directly to a user.
  user   = aws_iam_user.iam_user_tf_state.name
  name   = "${var.prefix_s3}-${var.env}"
  policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [{
          "Effect": "Allow",
          "Action": "s3:ListBucket",
          "Resource": "arn:aws:s3:::mybucket"
        },
        {
          "Effect": "Allow",
          "Action": ["s3:GetObject", "s3:PutObject"],
          "Resource": "arn:aws:s3:::${var.prefix_s3}-${var.env}/"
        }]
    })
}