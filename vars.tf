################# Provider config #############################
variable region {
    type = string
}

variable credentials {
    type = string
}

variable profile {
    type = string
}

################# Project variables ###########################
variable env {
    type = string
    description = "Current project environment name"
}

################# Name prefixes ###############################
variable prefix_dynamodb {
    type = string
}

variable prefix_s3 {
    type = string
}

variable prefix_iam_s3 {
    type = string
}

variable prefix_iam_user {
    type = string
}