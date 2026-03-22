<div align="center">

# 🔭 End-to-End Microservices CI/CD Pipeline
### OpenTelemetry Demo — Production-Grade Deployment on AWS EKS

[![AWS](https://img.shields.io/badge/AWS-EKS-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/eks/)
[![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-Orchestration-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Docker](https://img.shields.io/badge/Docker-Containerization-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-CI/CD-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)](https://github.com/features/actions)
[![ArgoCD](https://img.shields.io/badge/ArgoCD-GitOps-EF7B4D?style=for-the-badge&logo=argo&logoColor=white)](https://argo-cd.readthedocs.io/)

*A fully instrumented, cloud-native microservices application demonstrating distributed tracing, metrics, and logs with a complete CI/CD pipeline from local Docker to production EKS.*

</div>

---

## 📑 Table of Contents

- [Project Overview](#-project-overview)
- [Architecture](#-architecture)
  - [Service Diagram](#service-diagram)
  - [Telemetry Data Flow](#telemetry-data-flow)
  - [Services & Languages](#services--languages)
- [Tech Stack](#-tech-stack)
- [Prerequisites & Installation](#-prerequisites--installation)
- [Part 1 — Local Deployment with Docker Compose](#-part-1--local-deployment-with-docker-compose)
- [Part 2 — Production Deployment on AWS EKS](#-part-2--production-deployment-on-aws-eks)
  - [AWS Infrastructure Setup](#aws-infrastructure-setup)
  - [Terraform — State Backend](#terraform--state-backend)
  - [Terraform — VPC & EKS Cluster](#terraform--vpc--eks-cluster)
  - [Kubernetes Deployment](#kubernetes-deployment)
  - [Exposing with LoadBalancer](#exposing-with-loadbalancer)
  - [ALB Ingress Controller](#alb-ingress-controller)
  - [Route 53 & Custom Domain](#route-53--custom-domain)
- [Part 3 — CI/CD Pipeline](#-part-3--cicd-pipeline)
  - [GitHub Actions](#github-actions)
  - [ArgoCD — GitOps Continuous Delivery](#argocd--gitops-continuous-delivery)
- [Project Screenshots](#-project-screenshots)

---

## 🌐 Project Overview

This project is an end-to-end implementation of the **[OpenTelemetry Demo Application](https://opentelemetry.io/docs/demo/)** — a real-world, polyglot microservices e-commerce platform — deployed on **AWS EKS** with a fully automated CI/CD pipeline.

The project demonstrates:

- **Distributed Observability** — Traces, metrics, and logs across 20+ microservices using OpenTelemetry
- **Infrastructure as Code** — All AWS resources provisioned with Terraform (remote state in S3 + DynamoDB locking)
- **Container Orchestration** — Kubernetes on Amazon EKS with VPC, IAM roles, node groups, and ALB Ingress
- **GitOps CI/CD** — GitHub Actions for CI (build & push images on PR merge) + ArgoCD for CD (self-healing deployments)
- **Production Networking** — Route 53 hosted zones mapped to a custom domain via ALB Ingress Controller

---

## 🏗 Architecture

### Service Diagram

> *The OpenTelemetry Demo is composed of 20+ microservices written in different programming languages, communicating over gRPC and HTTP, with a Locust-based load generator for simulated traffic.*

<!-- INSERT: architecture-diagram-screenshot -->
![Architecture Diagram](INSERT_SCREENSHOT_URL_HERE)

> **Reference:** [opentelemetry.io/docs/demo/architecture](https://opentelemetry.io/docs/demo/architecture/)

The services interact as follows:

```
Internet / Load Generator / React Native App
        │
        ▼
  Frontend Proxy (Envoy)
        │
        ├──▶ Frontend (TypeScript)
        │         ├──▶ Ad Service (Java)
        │         ├──▶ Cart Service (.NET)  ──▶ Cache (Valkey)
        │         ├──▶ Currency Service (C++)
        │         ├──▶ Product Catalog (Go)
        │         ├──▶ Recommendation (Python)
        │         ├──▶ Checkout (Go)
        │         │       ├──▶ Payment (JavaScript)
        │         │       ├──▶ Email (Ruby)
        │         │       ├──▶ Shipping (Rust)  ──▶ Quote (PHP)
        │         │       └──▶ Kafka Queue
        │         │               ├──▶ Accounting (.NET)  ──▶ PostgreSQL
        │         │               └──▶ Fraud Detection (Kotlin)
        │         └──▶ Product Reviews (Python)  ──▶ LLM Service (Python)
        │
        ├──▶ Flagd UI (Elixir) — Feature flags management
        └──▶ Image Provider (nginx)

All services ──▶ Flagd (Go) — Feature flag evaluation
```

### Telemetry Data Flow

```
Microservices
    │
    ├──(OTLP gRPC)──▶ OTel Collector (:4317)
    └──(OTLP HTTP)──▶ OTel Collector (:4318)
                              │
              ┌───────────────┼────────────────┐
              ▼               ▼                ▼
         Prometheus      Jaeger           OpenSearch
         (metrics)       (traces)         (logs)
              │               │                │
              └───────────────┴────────────────┘
                              │
                           Grafana
                       (unified dashboards)
```

### Services & Languages

| Service | Language | Protocol | Description |
|---|---|---|---|
| Frontend Proxy | C++ (Envoy) | HTTP | Entry point for all external traffic |
| Frontend | TypeScript | gRPC/HTTP | Main web UI |
| Ad Service | Java | gRPC | Serves targeted advertisements |
| Cart Service | .NET | gRPC | Shopping cart with Valkey cache |
| Checkout | Go | gRPC | Orchestrates the order flow |
| Currency | C++ | gRPC | Currency conversion |
| Email | Ruby | HTTP | Order confirmation emails |
| Payment | JavaScript | gRPC | Payment processing |
| Product Catalog | Go | gRPC | Product listings |
| Product Reviews | Python | gRPC | Reviews + LLM integration |
| Recommendation | Python | gRPC | Product recommendations |
| Shipping | Rust | HTTP | Shipping cost estimation |
| Quote | PHP | HTTP | Shipping quotes |
| Accounting | .NET | TCP (Kafka) | Order accounting |
| Fraud Detection | Kotlin | TCP (Kafka) | Fraud analysis |
| LLM Service | Python | gRPC | AI-powered product reviews |
| Flagd | Go | gRPC | Feature flag service |
| Flagd UI | Elixir | HTTP | Feature flag management UI |
| Image Provider | nginx | HTTP | Product image hosting |
| Load Generator | Python (Locust) | HTTP | Simulated user traffic |

---

## 🛠 Tech Stack

| Category | Technology |
|---|---|
| **Cloud** | Amazon Web Services (AWS) |
| **Compute** | EC2 (t3.large), EKS (Managed Kubernetes) |
| **Networking** | VPC, ALB, Route 53 |
| **Storage** | S3 (Terraform state), DynamoDB (state lock) |
| **IaC** | Terraform (modules for VPC & EKS) |
| **Containers** | Docker, Docker Compose |
| **Orchestration** | Kubernetes (EKS), Helm |
| **CI** | GitHub Actions |
| **CD** | ArgoCD (GitOps) |
| **Ingress** | AWS ALB Ingress Controller |
| **DNS** | Route 53 + Hostinger (custom domain) |
| **Observability** | OpenTelemetry Collector, Jaeger, Prometheus, Grafana, OpenSearch |

---

## ⚙️ Prerequisites & Installation

### 1. AWS Account & IAM User

Create a dedicated IAM user with the required permissions:

```
IAM → Users → Create User → Attach Permissions
```

Required permissions: `AmazonEC2FullAccess`, `AmazonEKSFullAccess`, `IAMFullAccess`, `AmazonS3FullAccess`, `AmazonDynamoDBFullAccess`, `AmazonVPCFullAccess`

Then generate **Access Key** and **Secret Access Key** from Security Credentials.

<!-- INSERT: IAM user creation screenshot -->
![IAM User](INSERT_SCREENSHOT_URL_HERE)

### 2. Launch EC2 Instance

| Setting | Value |
|---|---|
| Name | `opentelemetry` |
| AMI | Ubuntu |
| Instance Type | `t3.large` |
| Key Pair | Assign existing or create new |

<!-- INSERT: EC2 instance screenshot -->
![EC2 Instance](INSERT_SCREENSHOT_URL_HERE)

Connect to the instance:

```bash
ssh -i your-key.pem ubuntu@<EC2-PUBLIC-IP>
```

### 3. Install Required Tools

**Docker:**
```bash
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable docker
sudo usermod -aG docker $USER
```

**kubectl:**
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
```

**Terraform:**
```bash
sudo apt install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform
```

**AWS CLI:**
```bash
sudo snap install aws-cli --classic
```

---

## 🐳 Part 1 — Local Deployment with Docker Compose

Run the entire OpenTelemetry demo stack locally in minutes.

### Clone the Repository

```bash
git clone <your-repo-url>
cd <repo-name>
```

### Start All Services

```bash
docker compose up -d
```

<!-- INSERT: docker compose up screenshot -->
![Docker Compose](INSERT_SCREENSHOT_URL_HERE)

### Update EC2 Security Group

Open port `8080` in your EC2 security group — this is the Frontend Proxy port for the application UI.

```
EC2 → Security Groups → Inbound Rules → Add Rule
Type: Custom TCP | Port: 8080 | Source: 0.0.0.0/0
```

Access the application at: `http://<EC2-PUBLIC-IP>:8080`

<!-- INSERT: application web screenshot and docker ps screenshot -->
![Application Running](INSERT_SCREENSHOT_URL_HERE)

### Tear Down

```bash
docker compose down --remove-orphans
```

---

## ☁️ Part 2 — Production Deployment on AWS EKS

### AWS Infrastructure Setup

Configure AWS CLI with your IAM credentials:

```bash
aws configure
# Enter: Access Key ID, Secret Access Key, Region (ap-south-1), Output format (json)
```

### Terraform — State Backend

Create remote state storage (S3 bucket + DynamoDB table for state locking):

```bash
cd backend/
terraform init
terraform plan
terraform apply
```

<!-- INSERT: Terraform S3 and DynamoDB creation screenshot -->
![Terraform Backend](INSERT_SCREENSHOT_URL_HERE)

This provisions:
- **S3 Bucket** — Stores Terraform state file remotely
- **DynamoDB Table** — Provides state locking to prevent concurrent modifications

### Terraform — VPC & EKS Cluster

Provision the VPC and EKS cluster using modular Terraform configurations:

```bash
cd terraform/
terraform init
terraform plan
terraform apply
```

<!-- INSERT: Terraform plan/apply terminal screenshot -->
![Terraform Apply](INSERT_SCREENSHOT_URL_HERE)

This creates:
- **VPC** with public and private subnets across availability zones
- **EKS Cluster** (`opentelemetry-project-eks-cluster`)
- **IAM Roles & Policies** for master node and worker nodes
- **Node Group** — managed EC2 worker nodes

<!-- INSERT: VPC screenshot -->
![VPC](INSERT_SCREENSHOT_URL_HERE)

<!-- INSERT: EKS cluster screenshot -->
![EKS Cluster](INSERT_SCREENSHOT_URL_HERE)

### Kubernetes Deployment

**Update kubeconfig to connect to the EKS cluster:**

```bash
aws eks update-kubeconfig --region ap-south-1 --name opentelemetry-project-eks-cluster
```

**Verify the current context:**

```bash
kubectl config current-context
kubectl get nodes
kubectl get all
```

<!-- INSERT: kubectl get all terminal screenshot -->
![kubectl get all](INSERT_SCREENSHOT_URL_HERE)

**Create the Service Account:**

```bash
cd kubernetes/
kubectl apply -f serviceaccount.yaml
kubectl get sa
```

<!-- INSERT: service account screenshot -->
![Service Account](INSERT_SCREENSHOT_URL_HERE)

**Deploy all microservices:**

```bash
kubectl apply -f completedeploy.yaml
```

<!-- INSERT: kubectl apply screenshot -->
![Complete Deploy](INSERT_SCREENSHOT_URL_HERE)

### Exposing with LoadBalancer

Check the frontend proxy service:

```bash
kubectl get svc | grep frontendproxy
```

Edit the service to change type to `LoadBalancer`:

```bash
kubectl edit svc opentelemetry-demo-frontendproxy
# Change: type: ClusterIP  →  type: LoadBalancer
```

<!-- INSERT: AWS LoadBalancer console screenshot -->
![LoadBalancer](INSERT_SCREENSHOT_URL_HERE)

> ⚠️ **Note:** Classic LoadBalancers have limitations (no path-based routing, higher cost per service). We'll replace this with an ALB Ingress Controller.

### ALB Ingress Controller

Revert the service type back to `NodePort`:

```bash
kubectl edit svc opentelemetry-demo-frontendproxy
# Change: type: LoadBalancer  →  type: NodePort
```

Deploy the Ingress resource:

```bash
cd kubernetes/frontendproxy/
kubectl apply -f ingress.yaml
```

<!-- INSERT: ingress.yaml file screenshot -->
![Ingress YAML](INSERT_SCREENSHOT_URL_HERE)

<!-- INSERT: ALB in AWS console screenshot -->
![ALB Console](INSERT_SCREENSHOT_URL_HERE)

<!-- INSERT: browser screenshot via ALB URL -->
![Browser via ALB](INSERT_SCREENSHOT_URL_HERE)

### Route 53 & Custom Domain

Map a custom domain to the ALB via Route 53:

1. **Create a Hosted Zone** in Route 53 for your domain
2. **Create an A Record** (Alias) pointing to the ALB
3. **Copy the 4 Nameservers** from Route 53 hosted zone
4. **Update nameservers** in your domain registrar (e.g. Hostinger) with the Route 53 nameservers

<!-- INSERT: Route 53 hosted zone screenshot -->
![Route 53](INSERT_SCREENSHOT_URL_HERE)

<!-- INSERT: Hostinger nameserver update screenshot -->
![Hostinger Nameservers](INSERT_SCREENSHOT_URL_HERE)

<!-- INSERT: browser screenshot via custom domain -->
![Custom Domain Browser](INSERT_SCREENSHOT_URL_HERE)

---

## 🚀 Part 3 — CI/CD Pipeline

### GitHub Actions

The CI pipeline is triggered automatically on **pull requests** and **merges to main**.

**Workflow:**
1. Developer pushes code changes and opens a Pull Request
2. GitHub Actions CI workflow triggers
3. Tests run, Docker image is built for the changed service
4. Image is pushed to container registry
5. On merge to `main`, updated manifests are applied to the EKS cluster

<!-- INSERT: GitHub Actions workflow runs screenshot -->
![GitHub Actions](INSERT_SCREENSHOT_URL_HERE)

<!-- INSERT: GitHub Actions CI steps screenshot -->
![CI Steps](INSERT_SCREENSHOT_URL_HERE)

### ArgoCD — GitOps Continuous Delivery

ArgoCD continuously reconciles the desired state (GitHub) with the live state (Kubernetes), providing self-healing deployments.

**Install Helm:**
```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

**Install ArgoCD via Helm:**
```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm install argocd argo/argo-cd --namespace argocd --create-namespace
```

**Retrieve the initial admin password:**
```bash
kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath="{.data.password}" | base64 -d
```

**Access the ArgoCD UI:**
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
# Access at: https://localhost:8080  (note: HTTPS, not HTTP)
# Or expose permanently via LoadBalancer/Ingress
```

**Configure the Application in ArgoCD UI:**

1. Login with `admin` and the retrieved password
2. Click **New App** and configure:
   - **Repository URL:** Your GitHub repository
   - **Path:** `kubernetes/`
   - **Cluster:** `https://kubernetes.default.svc` (in-cluster)
   - **Namespace:** `default` (or your target namespace)
   - **Sync Policy:** Enable **Auto Sync** + **Self Heal** + **Prune**
3. Click **Create** and **Sync**

<!-- INSERT: ArgoCD app creation screenshot -->
![ArgoCD New App](INSERT_SCREENSHOT_URL_HERE)

<!-- INSERT: ArgoCD app healthy/synced screenshot -->
![ArgoCD Synced](INSERT_SCREENSHOT_URL_HERE)

<!-- INSERT: ArgoCD service graph screenshot -->
![ArgoCD Graph](INSERT_SCREENSHOT_URL_HERE)

**Result:** Any change pushed to the `kubernetes/` directory in your repository is automatically detected and deployed to your EKS cluster within minutes — no manual `kubectl apply` required.

---

## 📸 Project Screenshots

| Stage | Screenshot |
|---|---|
| IAM User & Credentials | INSERT_SCREENSHOT_URL_HERE |
| EC2 Instance | INSERT_SCREENSHOT_URL_HERE |
| Docker Compose Running | INSERT_SCREENSHOT_URL_HERE |
| Application (Port 8080) | INSERT_SCREENSHOT_URL_HERE |
| Terraform Backend (S3 + DynamoDB) | INSERT_SCREENSHOT_URL_HERE |
| VPC Created | INSERT_SCREENSHOT_URL_HERE |
| EKS Cluster | INSERT_SCREENSHOT_URL_HERE |
| kubectl get all | INSERT_SCREENSHOT_URL_HERE |
| Complete Deploy | INSERT_SCREENSHOT_URL_HERE |
| LoadBalancer (AWS Console) | INSERT_SCREENSHOT_URL_HERE |
| ALB Ingress Controller | INSERT_SCREENSHOT_URL_HERE |
| Route 53 Hosted Zone | INSERT_SCREENSHOT_URL_HERE |
| Application via Custom Domain | INSERT_SCREENSHOT_URL_HERE |
| GitHub Actions CI Pipeline | INSERT_SCREENSHOT_URL_HERE |
| ArgoCD Dashboard | INSERT_SCREENSHOT_URL_HERE |

---

<div align="center">

**Built with ❤️ — OpenTelemetry | AWS | Terraform | Kubernetes | GitHub Actions | ArgoCD**

*Reference: [OpenTelemetry Demo Docs](https://opentelemetry.io/docs/demo/) · [Architecture](https://opentelemetry.io/docs/demo/architecture/)*

</div>

