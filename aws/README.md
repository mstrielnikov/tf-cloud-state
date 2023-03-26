# tf-module-aws-state

Creates AWS S3 + DynamoDB stack for managing terraform remote state. Recommended to use under AWS IAM Role or AWS IAM User which already has necessary rights to create and list S3 bucket and DynamoDB table.

# How to import 

```terraform
terraform {
  required_version = ">= 0.14.5"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.50.0"
    }
  }

  backend "s3" {
    region         = "us-east-1"
    dynamodb_table = "dynamodb-tf-state-lock-table"
    bucket         = "tf-state"
    key            = "tf.state"    
    encrypt = true
  }
}

provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}

module "terraform_state" {
  source = "github.com/mstrielnikov/tf-cloud-state//aws"
  dynamodb_table_name = "dynamodb-tf-state-lock-table"
  s3_bucket_name      = "tf-state"
  tags                = merge(var.default_tags, {Env = dev})
}

```

# Terragrunt

*(not ready)*

# Links

* [S3 backend](https://www.terraform.io/docs/language/settings/backends/s3.html)
* [AWS provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
* [Example by Terragrunt](https://blog.gruntwork.io/how-to-manage-terraform-state-28f5697e68fa)