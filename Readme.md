# aws-infra-terraform 🚀

![Terraform](https://img.shields.io/badge/Terraform->=1.5.0-7B42BC?style=flat&logo=terraform)
![AWS](https://img.shields.io/badge/AWS-ap--south--1-FF9900?style=flat&logo=amazonaws)
![CI/CD](https://img.shields.io/badge/CI/CD-GitHub%20Actions-2088FF?style=flat&logo=githubactions)
![Status](https://img.shields.io/badge/Status-Week%201%20Complete-1D9E75?style=flat)
![License](https://img.shields.io/badge/License-MIT-blue?style=flat)

A **production-grade AWS infrastructure built from scratch** using Terraform modules, automated with GitHub Actions CI/CD, secured with tfsec, cost-estimated with Infracost, and monitored with CloudWatch.

Built as a portfolio project to demonstrate real-world DevOps and Cloud Infrastructure engineering — every decision documented, every module reusable.

> 📝 Follow the full build journey on Medium → [Building Production AWS Infrastructure from Scratch](#)

---

## 📐 Architecture

```
                          ┌─────────────────────────────────────┐
                          │           AWS VPC (10.0.0.0/16)     │
                          │                                     │
          Internet        │  ┌──────────────┐  ┌─────────────┐ │
        ──────────► IGW ──┼─►│Public Subnet │  │Public Subnet│ │
                          │  │ AZ-a         │  │ AZ-b        │ │
                          │  │ 10.0.1.0/24  │  │ 10.0.2.0/24 │ │
                          │  │              │  │             │ │
                          │  │  NAT Gateway │  │             │ │
                          │  └──────┬───────┘  └─────────────┘ │
                          │         │ (outbound only)           │
                          │  ┌──────▼───────┐  ┌─────────────┐ │
                          │  │Private Subnet│  │Private Subnet│ │
                          │  │ AZ-a         │  │ AZ-b        │ │
                          │  │ 10.0.10.0/24 │  │10.0.20.0/24 │ │
                          │  │              │  │             │ │
                          │  │  EC2 (ASG)   │  │  EC2 (ASG)  │ │
                          │  └──────────────┘  └─────────────┘ │
                          └─────────────────────────────────────┘
```

---

## 📌 Project Goals

- ✅ Build reusable, environment-agnostic Terraform modules
- ✅ Remote state management with S3 + DynamoDB locking
- ⏳ Automate deployments via GitHub Actions CI/CD *(Week 2)*
- ⏳ Security scanning with tfsec + cost estimation with Infracost *(Week 2)*
- ⏳ CloudWatch monitoring + SNS alerts *(Week 3)*

---

## 🗂️ Project Structure

```
aws-infra-terraform/
├── modules/                    # Reusable Terraform modules
│   ├── vpc/                    # VPC, subnets, IGW, NAT, route tables
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── compute/                # EC2, Auto Scaling Group, Security Groups
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── iam/                    # IAM roles, policies, instance profiles
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── envs/                       # Environment-specific configurations
│   ├── dev/                    # Development environment
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   └── prod/                   # Production environment
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars
├── main.tf                     # Root module
├── variables.tf                # Root input variables
├── outputs.tf                  # Root outputs
├── versions.tf                 # Terraform + provider version constraints
└── .gitignore                  # Excludes .terraform/, state files, secrets
```

### Design Decisions

**Why modular structure?**
Each module (vpc, compute, iam) is independently reusable and versioned. Changing the compute module carries zero risk to networking. Modules expose inputs and outputs — the environment wires them together.

**Why separate state per environment?**
Dev and prod use the same S3 bucket but different state keys (`envs/dev/terraform.tfstate` vs `envs/prod/terraform.tfstate`). A failed dev apply can never corrupt prod state.

**Why private subnets for EC2?**
Application servers have no business being directly reachable from the internet. NAT Gateway gives them outbound access without inbound exposure — defence in depth.

**Why Launch Template over Launch Configuration?**
Launch Configurations are legacy. Launch Templates support versioning, IMDSv2 enforcement, mixed instance types, and spot instances. Always use Launch Templates.

**Why `enable_nat_gateway` variable?**
NAT Gateway costs ~$32/month. In dev you don't need it for infrastructure testing. The boolean flag lets dev disable it while prod enables it — cost awareness built into the design.

---

## ⚙️ Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| [Terraform](https://developer.hashicorp.com/terraform/install) | >= 1.5.0 | Infrastructure as Code |
| [AWS CLI](https://aws.amazon.com/cli/) | >= 2.0 | AWS authentication |
| AWS Account | Free tier | Deployment target |

---

## 🚀 Getting Started

```bash
# 1. Clone the repository
git clone https://github.com/kbrepository/aws-infra-terraform.git
cd aws-infra-terraform

# 2. Bootstrap remote state (one-time setup)
aws s3api create-bucket \
  --bucket aws-infra-terraform-state-kb \
  --region ap-south-1 \
  --create-bucket-configuration LocationConstraint=ap-south-1

aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region ap-south-1

# 3. Deploy dev environment
cd envs/dev
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"

# 4. Destroy when done (avoid charges)
terraform destroy -var-file="terraform.tfvars"
```

---

## 📅 Build Log

| Day | Date | What Was Built | Commit |
|-----|------|----------------|--------|
| 1 | 22 Mar 2026 | Project folder structure, versions.tf, root variables | `Day 1: Set up Terraform project folder structure` |
| 2 | 23 Mar 2026 | S3 remote state + DynamoDB locking | `Day 2: Configure S3 remote state and DynamoDB locking` |
| 3 | 24 Mar 2026 | VPC module — subnets, IGW, route tables | `Day 3: Build VPC module with public/private subnets, IGW and route tables` |
| 4 | 19 Aug 2026 | NAT Gateway with conditional creation + private routing | `Day 4: Add NAT Gateway with conditional creation and private subnet routing` |
| 5 | 20 Aug 2026 | EC2 + ASG module with launch template + security groups | `Day 5: Build EC2 and ASG module with launch template and security groups` |
| 6 | 21 Aug 2026 | IAM roles + instance profiles + full module wiring | `Day 6: Add IAM roles, instance profiles and wire all modules together` |
| 7 | 21 Aug 2026 | Code cleanup, README polish, Week 1 complete | `Day 7: Week 1 complete — code cleanup and README update` |

---

## 🛠️ Tech Stack

| Tool | Purpose | Status |
|------|---------|--------|
| Terraform >= 1.5.0 | Infrastructure as Code | ✅ Active |
| AWS (ap-south-1) | Cloud provider | ✅ Active |
| S3 + DynamoDB | Remote state + locking | ✅ Active |
| GitHub Actions | CI/CD automation | ⏳ Week 2 |
| tfsec | Security scanning | ⏳ Week 2 |
| Infracost | Cost estimation | ⏳ Week 2 |
| CloudWatch + SNS | Monitoring + alerts | ⏳ Week 3 |

---

## ✍️ Author

**Kalpesh Bhangare** — 8 years in Linux administration and AWS Cloud Infrastructure

- 📝 [Medium](https://medium.com/@kalpeshbhangre96)
- 🐙 [GitHub](https://github.com/kbrepository)

---

## 📄 License

MIT — feel free to use this as a reference for your own infrastructure projects.