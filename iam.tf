resource "aws_iam_user" "iam_user_tf_state" {
  name          = "${var.prefix_iam_user}-${var.env}"
  path          = "/"
  force_destroy = var.force_destroy_enabled
  tags          = {
    Name        = "${var.prefix_iam_user}-${var.env}"
    Environment = var.env
  }
}

# Generate API credentials
resource "aws_iam_access_key" "iam_access_key_tf_state" {
  user  = aws_iam_user.iam_user_tf_state.name
}

