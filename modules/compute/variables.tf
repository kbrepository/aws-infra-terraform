variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev or prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC to deploy compute resources into"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for ASG — instances launch here"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID for EC2 instances — use Amazon Linux 2023"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "instance_profile_name" {
  description = "IAM instance profile name to attach to EC2 instances"
  type        = string
}

variable "ssh_allowed_cidrs" {
  description = "List of CIDRs allowed to SSH — restrict to your IP only"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "root_volume_size" {
  description = "Size of root EBS volume in GB"
  type        = number
  default     = 20
}

variable "user_data" {
  description = "User data bootstrap script for EC2 instances"
  type        = string
  default     = ""
}

variable "asg_min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 3
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
  default     = 1
}