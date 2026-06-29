# 🚀 My GitOps

> GitOps repository responsible for continuously deploying the Stock Alert platform onto Kubernetes using ArgoCD.

---

# Overview

This repository contains all Kubernetes deployment manifests and Helm values used to deploy the Stock Alert platform.

Unlike the application repository, this project contains **no application source code**. Instead, it stores the desired state of the Kubernetes cluster.

Whenever a new application image is built, GitHub Actions automatically updates the corresponding Helm values in this repository. ArgoCD detects those Git changes and synchronizes the Kubernetes cluster without requiring any manual deployment.

This repository is the single source of truth for application deployments.

---

# Responsibilities

This repository manages:

* Kubernetes application deployments
* Helm values
* ArgoCD Applications
* Image version updates
* Environment configuration
* Kubernetes ConfigMaps
* Ingress configuration
* GitOps workflows

Application code lives in the **stock-alert** repository.

Infrastructure components live in the **my-platform-infra** repository.

---

# GitOps Workflow

```text
Developer

    │

    ▼

Push Code

    │

    ▼

GitHub Actions
(Build Docker Images)

    │

    ▼

Push Images to GHCR

    │

    ▼

Update Helm Values

    │

    ▼

Commit to my-gitops

    │

    ▼

ArgoCD detects Git change

    │

    ▼

Sync Kubernetes Cluster

    │

    ▼

Rolling Deployment
```

---

# Repository Structure

```text
my-gitops/

├── apps/
│   ├── stock-alert.yaml
│   └── ...
│
├── charts/
│   └── platform-workload/
│
├── values/
│   └── stock-alert/
│       ├── frontend.yaml
│       ├── gateway.yaml
│       ├── auth-service.yaml
│       ├── user-service.yaml
│       ├── analyzer-service.yaml
│       ├── scanner-service.yaml
│       ├── notifier-service.yaml
│       └── market-service.yaml
│
└── README.md
```

---

# Application Deployment

Every microservice is deployed using a reusable Helm chart.

Only the values differ between services.

This keeps the deployment configuration consistent while reducing duplication.

Current workloads include:

* Frontend
* API Gateway
* Auth Service
* User Service
* Analyzer Service
* Scanner Service
* Market Service
* Notifier Service

---

# Helm Strategy

Instead of maintaining separate Kubernetes manifests for every service, a reusable Helm chart is used.

Each application provides its own values file containing:

* Image repository
* Image tag
* Replica count
* Service configuration
* Environment variables
* ConfigMaps
* Ingress
* Health probes
* Resources

This makes onboarding a new microservice straightforward by adding a values file rather than duplicating manifests.

---

# ArgoCD Integration

ArgoCD continuously monitors this repository.

Whenever a change is pushed:

1. ArgoCD detects the Git commit.
2. The desired state is compared with the live cluster.
3. Differences are identified.
4. Kubernetes resources are synchronized automatically.
5. Rolling updates are performed without downtime.

No manual `kubectl apply` commands are required.

---

# Continuous Deployment

Application deployment follows a fully automated GitOps workflow.

```text
Code Change

↓

CI Pipeline

↓

Docker Image

↓

GitHub Container Registry

↓

Update Helm Values

↓

Commit to GitOps Repository

↓

ArgoCD Sync

↓

Kubernetes Deployment
```

This separation allows the build pipeline and deployment pipeline to remain independent.

---

# Image Management

Container images are stored in GitHub Container Registry (GHCR).

Each deployment references immutable image tags generated during the CI pipeline.

The GitOps repository is automatically updated with the latest image versions after successful builds.

---

# Configuration Management

Application configuration is managed declaratively through Helm values.

Examples include:

* Environment variables
* Database connections
* Service URLs
* Kafka configuration
* JWT settings
* Feature flags
* Resource limits

Configuration changes are version controlled alongside deployment manifests.

---

# Deployment Features

Current deployment capabilities include:

* Rolling updates
* Kubernetes health probes
* ConfigMaps
* Secrets support
* Service discovery
* Internal ClusterIP services
* Ingress routing
* Namespace isolation
* Automatic image updates

---

# Design Principles

## GitOps

Git serves as the single source of truth.

## Declarative Deployments

Cluster state is fully described in Git.

## Immutable Infrastructure

Deployments reference immutable container images.

## Reusable Helm Charts

A common chart is shared across all services.

## Separation of Concerns

Application code, platform infrastructure, and deployment configuration are maintained independently.

---

# Related Repositories

| Repository        | Purpose                            |
| ----------------- | ---------------------------------- |
| stock-alert       | Application source code            |
| my-platform-infra | Kubernetes platform infrastructure |
| my-gitops         | GitOps deployment repository       |

---

# Current Platform

## Applications

* Frontend
* API Gateway
* Auth Service
* User Service
* Analyzer Service
* Scanner Service
* Market Service
* Notifier Service

## Deployment Stack

* Kubernetes
* Helm
* ArgoCD
* GitHub Actions
* GitHub Container Registry (GHCR)
* NGINX Ingress Controller

---

# Roadmap

Planned enhancements include:

* Progressive deployments
* Canary releases
* Blue/Green deployments
* Multi-environment support (Dev, QA, Production)
* Image signing
* Policy enforcement
* Secret management
* Automated rollback
* Observability stack integration
* Deployment notifications

---

# Project Status

Current Status

* ✅ GitOps workflow implemented
* ✅ Automated image updates
* ✅ ArgoCD continuous deployment
* ✅ Helm-based deployments
* ✅ All Stock Alert microservices onboarded
* 🚧 Observability integration in progress

---

# Author

**Rakesh H**

Platform Engineer | DevOps | Kubernetes | GitOps | Cloud

This repository demonstrates a production-inspired GitOps workflow using Helm, GitHub Actions, ArgoCD, and Kubernetes to achieve fully automated application deployments.
