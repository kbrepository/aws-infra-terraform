terraform {
  backend "s3" {
    bucket = "aws-infra-terraform-state-kb"
    key    = "envs/dev/terraform.tfstate"
    region = "ap-south-1"
    # dynamodb_table = "terraform-state-lock"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../../modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
  enable_nat_gateway   = false
}

module "compute" {
  source = "../../modules/compute"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  ami_id                = "ami-0f58b397bc5c1f2e8" # Amazon Linux 2023 ap-south-1
  instance_type         = "t3.micro"
  instance_profile_name = module.iam.instance_profile_name
  ssh_allowed_cidrs     = ["10.0.0.0/8"] # Only from within VPC
  root_volume_size      = 20
  asg_min_size          = 1
  asg_max_size          = 2
  asg_desired_capacity  = 1

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y amazon-cloudwatch-agent
  EOF
}