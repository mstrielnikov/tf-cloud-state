# tf-module-aws-state

Creates AWS S3 + DynamoDB stack with minimal necessary IAM for terraform remote state

# How to import 

```terraform
module aws_state_foo {
  env                           = project_foo
  force_destroy_enabled         = false
  create_before_destroy_enabled = true
  s3_versioning_enabled         = false
  s3_object_lock_enabled        = "Disabled"
  s3_acl                        = "private"
  s3_block_public_acls          = true
  s3_block_public_policy        = true
  s3_ignore_public_acls         = true
  s3_restrict_public_buckets    = true
  dynamodb_billing_mode         = PAY_PER_REQUEST
}
```

# Terragrunt

# Official docs

* [S3 backend](https://www.terraform.io/docs/language/settings/backends/s3.html)
& [AWS provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)