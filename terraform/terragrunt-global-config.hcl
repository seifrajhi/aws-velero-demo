locals {
  aws_profile = "sre-dev-1"
}

inputs = {
  aws_profile = local.aws_profile
 }

remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket         = "aws-eks-irsa-tf-states-backup"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-west-3"
    encrypt        = true
    dynamodb_table = "aws-eks-irsa-tf-states"
    profile        = local.aws_profile
  }
}
