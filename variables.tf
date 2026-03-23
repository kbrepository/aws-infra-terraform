variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment (dev or prod)"
  type        = string
}

variable "project_name" {
  description = "Name of the project — used in resource naming"
  type        = string
  default     = "aws-infra"
}