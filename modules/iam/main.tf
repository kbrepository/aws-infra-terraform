# ── IAM Role ────────────────────────────────────────────────
# The role that EC2 instances will assume
resource "aws_iam_role" "ec2_role" {
  name        = "${var.project_name}-${var.environment}-ec2-role"
  description = "IAM role for EC2 instances grants access to required AWS services"

  # Trust policy — allows EC2 service to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-${var.environment}-ec2-role"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# ── CloudWatch Agent Policy ─────────────────────────────────
# Allows EC2 to push metrics and logs to CloudWatch
resource "aws_iam_role_policy" "cloudwatch_agent" {
  name = "${var.project_name}-${var.environment}-cloudwatch-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics",
          "ec2:DescribeTags",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}

# ── S3 Read Policy ──────────────────────────────────────────
# Allows EC2 to read from the state bucket (useful for config files)
resource "aws_iam_role_policy" "s3_read" {
  name = "${var.project_name}-${var.environment}-s3-read-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.state_bucket_name}",
          "arn:aws:s3:::${var.state_bucket_name}/*"
        ]
      }
    ]
  })
}

# ── SSM Policy ──────────────────────────────────────────────
# Allows EC2 to be managed via AWS Systems Manager
# This is the modern alternative to SSH — no open port 22 needed
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ── Instance Profile ────────────────────────────────────────
# The wrapper that attaches the IAM role to an EC2 instance
# You cannot attach a role directly to EC2 — must go through instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_role.name

  tags = {
    Name        = "${var.project_name}-${var.environment}-ec2-profile"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}