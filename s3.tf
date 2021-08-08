# The configuration provides necessary minimum options to securely setup Terraform remote state with S3 and DynamoDB
# Some usefull options are disabled to reduce AWS service usage in order to reduce billing 
resource "aws_s3_bucket" "s3_bucket_tf_state" {
  bucket        = "${var.prefix_s3}-${var.env}"
  acl           = "private"
  force_destroy = false
  tags          = {
    Name        = "${var.prefix_s3}-${var.env}"
    Environment = var.env
  }

  versioning {
      enabled = false
  }
  
  # server_side_encryption_configuration {
  #   rule {
  #     apply_server_side_encryption_by_default {
  #       sse_algorithm = "AES256"
  #     }
  #   }
  # }
  # 
  # object_lock_configuration {
  #   object_lock_enabled = "Enabled"
  # }
  # 
  # logging {
  #   target_bucket = aws_s3_bucket.log_bucket.id
  #   target_prefix = "log/"
  # }
}

# Refer to the terraform documentation on s3_bucket_public_access_block at
# https://www.terraform.io/docs/providers/aws/r/s3_bucket_public_access_block.html
# for the nuances of the blocking options
resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block_tf_state" {
  bucket = aws_s3_bucket.s3_bucket_tf_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_user_policy" "iam_policy_s3_tf_state" {
  #bridgecrew:skip=BC_AWS_IAM_16:Skipping `Ensure IAM policies are attached only to groups or roles` check because this module intentionally attaches IAM policy directly to a user.
  user   = aws_iam_user.iam_user_tf_state.name
  name   = "${var.prefix_iam_s3}-${var.env}"
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
          "Resource": "arn:aws:s3:::${var.prefix_iam_s3}-${var.env}/"
        }]
    })

  lifecycle {
    create_before_destroy = true
  }
}