################# Project variables ###########################
variable env {
    type = string
    description = "Current project environment name"
}

################## Common config variables ###################

variable force_destroy_enabled {
    type = bool
    default = false
}

variable create_before_destroy_enabled {
    type = bool
    default = true
}

################# S3 config variables #########################
variable s3_versioning_enabled {
    type    = bool
    default = false
}

variable s3_object_lock_enabled {
    type = string 
    default = "Disabled"
}

variable s3_acl {
    type = string
    default = "private"
}

variable s3_block_public_acls {
    type = bool
    default = true
}

variable s3_block_public_policy {
    type = bool
    default = true
}

variable s3_ignore_public_acls {
    type = bool
    default = true
}

variable s3_restrict_public_buckets {
    type = bool
    default = true
}

################# DynamoDB config variables ###################

variable dynamodb_billing_mode {
    type = string
    default = "PAY_PER_REQUEST"
}




################# Name prefixes ###############################
variable prefix_dynamodb {
    type = string
    default = "dynamodb-tf-state-locktable"
}

variable prefix_s3 {
    type = string
    default = "s3-bucket"
}

variable prefix_iam_user {
    type = string
    default = "iam-user"
}
