resource "aws_dynamodb_table" "dynamodb_table_tf_state" {
  name         = "${var.prefix_dynamodb}-${var.env}"
  read_capacity  = 5
  write_capacity = 5
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "${var.prefix_dynamodb}-${var.env}"
    Environment = var.env
  }
}

resource "aws_iam_user_policy" "iam_policy_dynamodb_tf_state" {
  #bridgecrew:skip=BC_AWS_IAM_16:Skipping `Ensure IAM policies are attached only to groups or roles` check because this module intentionally attaches IAM policy directly to a user.
  user   = aws_iam_user.iam_user_tf_state_mc.name
  name   = "${var.prefix_dynamodb}-${var.env}"
  policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [{
        "Effect": "Allow",
        "Action": [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
          ],
        "Resource": "arn:aws:dynamodb:*:*:${var.prefix_dynamodb}-${var.env}/"
      }]
    })

  lifecycle {
    create_before_destroy = true
  }
}