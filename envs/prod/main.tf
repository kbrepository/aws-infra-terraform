terraform {
  backend "s3" {
    bucket         = "aws-infra-terraform-state-kb"
    key            = "envs/prod/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}