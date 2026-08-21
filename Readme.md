# aws-infra-terraform 🚀

![Terraform](https://img.shields.io/badge/Terraform->=1.5.0-7B42BC?style=flat&logo=terraform)
![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?style=flat&logo=amazonaws)
![Status](https://img.shields.io/badge/Status-In%20Progress-1D9E75?style=flat)
![License](https://img.shields.io/badge/License-MIT-blue?style=flat)

A production-grade AWS infrastructure built from scratch using **Terraform modules**, automated with **GitHub Actions CI/CD**, and monitored with **CloudWatch** — built as a portfolio project to demonstrate real-world DevOps and Cloud Infrastructure engineering practices.

---

## 📌 Project Goals

- Build reusable, environment-agnostic Terraform modules for AWS infrastructure
- Implement remote state management with S3 + DynamoDB locking
- Automate deployments using GitHub Actions CI/CD pipelines
- Add security scanning (tfsec) and cost estimation (Infracost) as pipeline gates
- Monitor infrastructure with CloudWatch alarms and SNS notifications

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

### Why this structure?

**Modules over monolith** — Each module (vpc, compute, iam) is independently reusable. You can call the vpc module across multiple environments without duplicating code. Changes to one module don't risk breaking another.

**Environment isolation** — The `envs/dev` and `envs/prod` folders hold environment-specific `.tfvars`. Dev and prod never share the same state, so a mistake in dev can never affect production.

**Root vs modules** — The root `main.tf` acts as the orchestrator — it calls each module and wires outputs to inputs. Modules themselves contain no environment-specific values; those are always passed in via variables.

---

## ⚙️ Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- An AWS account (free tier is sufficient for dev environment)

---

## 🚀 Getting Started

```bash
# 1. Clone the repository
git clone https://github.com/kbrepository/aws-infra-terraform.git
cd aws-infra-terraform

# 2. Navigate to the environment you want to deploy
cd envs/dev

# 3. Initialise Terraform
terraform init

# 4. Review the plan
terraform plan -var-file="terraform.tfvars"

# 5. Apply
terraform apply -var-file="terraform.tfvars"
```

---

## 📅 Build Log

This project is built day by day. Each commit corresponds to one day of work.

| Day | Date | What was built | Commit |
|-----|------|----------------|--------|
| 1 | 22 Mar 2026 | Project folder structure, versions.tf, root variables | `Day 1: Set up Terraform project folder structure` |
| 2 | 23 Mar 2026 | S3 remote state + DynamoDB locking | `Day 2: Configure S3 remote state and DynamoDB locking` |
| 3 | 24 Mar 2026 | VPC module — subnets, IGW, route tables |  `Day 3: Build VPC module with public/private subnets, IGW and route tables` |
| 4 | 19 Mar 2026 | NAT Gateway + private subnet routing | `Day 4: Add NAT Gateway with conditional creation and private subnet routing` |
| 5 | 20 Mar 2026 | EC2 + ASG module with security groups | `Day 5: Build EC2 and ASG module with launch template and security groups` |
| 6 | 21 Aug 2026 | IAM roles + instance profiles + full module wiring | `Day 6: Add IAM roles, instance profiles and wire all modules together` |
| 7 | 28 Mar 2026 | Code cleanup + README polish | _coming soon_ |

> Full build log continues through Week 2 (CI/CD) and Week 3 (Monitoring + Interview Prep)

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| Terraform >= 1.5.0 | Infrastructure as Code |
| AWS | Cloud provider |
| S3 + DynamoDB | Remote state + locking _(Day 2)_ |
| GitHub Actions | CI/CD automation _(Week 2)_ |
| tfsec | Security scanning _(Week 2)_ |
| Infracost | Cost estimation _(Week 2)_ |
| CloudWatch + SNS | Monitoring + alerts _(Week 3)_ |

---

## ✍️ Author

**Kalpesh Bhangare** — Cloud Consultant | 7 years in Linux, AWS, and Infrastructure as Code

- 📝 [Medium](https://medium.com/@kalpeshbhangre96) — I write about AWS, Terraform, and DevOps
- 💼 [LinkedIn](https://www.linkedin.com/in/kb2005)
- 🐙 [GitHub](https://github.com/kbrepository)

---

## 📄 License

MIT — feel free to use this as a reference for your own infrastructure projects.