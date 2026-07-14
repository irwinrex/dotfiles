---
description: Read-only DevOps production-readiness review
agent: devops-review
---

Review the current repo or target path for DevOps readiness: $ARGUMENTS

Focus on:

- secret handling and least privilege
- deployment safety, rollback, and blast radius
- Terraform/OpenTofu/Terragrunt state and drift risk
- Kubernetes resources, probes, limits, selectors, and rollout behavior
- CI/CD permissions, pinned dependencies, cache scope, and artifact handling
- observability, health checks, and incident/debug ergonomics

Do not edit files. Rank findings by severity and include concrete remediation steps.
