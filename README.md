# GCP Platform Infrastructure – DevSecOps with Terraform & GitHub Actions

This repository demonstrates how to provision a **secure, production-ready GCP platform** using **Terraform** and **GitHub Actions**, with **DevSecOps controls integrated by default**.

The focus is not just infrastructure creation, but **how real platform teams design, secure, and operate cloud foundations**.

---

## What This Project Covers

- GCP project and IAM foundations
- Service accounts with least-privilege access
- Custom VPC, subnets, firewall rules (deny-by-default)
- Private Google Access and Cloud NAT
- GKE cluster (baseline production setup)
- GCS buckets for Terraform state and centralized logs
- Cloud Logging and Cloud Monitoring enabled
- Environment orchestration using Terragrunt

---

## DevSecOps Built In

Infrastructure is continuously validated using:

- **tfsec** – Terraform security scanning
- **Checkov** – Policy-as-code and compliance checks
- **GitHub Actions** – CI pipeline enforcing security gates
- **Terragrunt** – DRY, scalable environment management

No infrastructure change is applied without passing security and policy checks.

---

## Why This Matters

This project reflects how modern **Platform Engineering / DevSecOps teams** operate:

- Security is automated, not manual
- Infrastructure is reproducible and auditable
- Environments are scalable and controlled
- Cloud-native services are used responsibly

---

## Target Audience

- Cloud Engineers
- Platform Engineers
- DevSecOps Engineers
- SREs
- Cloud Architects

---

## Next Enhancements

- Multi-environment promotion (dev → stage → prod)
- GitOps integration
- Policy enforcement using OPA
- Cost governance and FinOps visibility
- Kubernetes workload onboarding

---

> Built with the mindset of production, not tutorials.
