variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev or prod)"
  type        = string
}

variable "state_bucket_name" {
  description = "S3 bucket name for Terraform state — EC2 gets read access"
  type        = string
}