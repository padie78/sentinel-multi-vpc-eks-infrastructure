# Cloud-Native Modular Infrastructure & Data Migration Pipeline

## 📌 Overview
This repository showcases a professional-grade infrastructure deployment using **Terraform** and **GitHub Actions**. The project focuses on a modular, scalable architecture, featuring a robust networking layer and an automated data migration strategy using **AWS Database Migration Service (DMS)** to bridge source databases with cloud-native targets.

---

## 🏗️ Architecture
The project implements a multi-tier cloud environment:
* **Management Layer**: GitHub Actions as the CI/CD orchestrator.
* **Infrastructure Layer**: Modular Terraform components (VPC, RDS, Security Groups, DMS).
* **Networking Layer**: Custom VPC with public/private segmentation and granular security rules.
* **Data Layer**: Source and Target RDS instances synchronized via DMS for high-integrity migration.

---

## 🚀 Key Features
* **Modular Terraform Design**: Clean Architecture applied to IaC for high reusability.
* **Automated CI/CD**: Full automation from `terraform plan` to `apply` via GitHub Actions.
* **DMS Implementation**: Provisioning of Replication Instances and Endpoints for seamless data transition.
* **Secure Networking**: Least-privilege Security Group policies and private subnet isolation.
* **High-Precision Data Handling**: Optimized DDL scripts for audit-ready metrics (e.g., CO2 emission tracking).

---

## 🛠️ Technology Stack
* **Cloud**: AWS (RDS, DMS, VPC, IAM)
* **IaC**: Terraform (Modular)
* **CI/CD**: GitHub Actions
* **Database**: MySQL / MariaDB
* **Tooling**: AWS CLI & Bash

---

## 🔧 Deployment Workflow
1. **Code Push**: Triggers GitHub Actions on the `main` branch.
2. **Infrastructure Validation**: Automated linting and `terraform plan`.
3. **Provisioning**: Deployment of network and database resources.
4. **Connectivity Handshake**: Automated `test-connection` via AWS CLI to validate the migration path.
5. **Migration Execution**: Triggering the DMS Replication Task for Full Load.

---

## 💡 Lessons Learned & Troubleshooting
* **Asynchronous Networking**: Managing AWS DMS connection states (`testing` -> `successful`) within automated workflows.
* **Connectivity Debugging**: Resolving Layer 4 I/O Timeouts by auditing Security Group Ingress rules and VPC routing.
* **Cost Governance**: Implementing lifecycle management for ephemeral resources to minimize cloud spend.

---

## 👤 Contact
**Diego Hernan Liascovich** *Cloud Architect | Senior Backend Engineer* [LinkedIn Profile](https://www.linkedin.com/in/liascovich/) | [GitHub](https://github.com/dliascovich)