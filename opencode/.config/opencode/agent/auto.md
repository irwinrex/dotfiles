---
description: Full-auto mode. Auto-accepts non-destructive tools; deny list still blocks.
mode: primary
temperature: 0.1
permission:
  edit: allow
  webfetch: allow
  websearch: allow
  bash:
    "*": allow
    "terraform apply*": deny
    "terraform *-destroy*": ask
    "terraform destroy*": ask
    "tofu apply*": deny
    "tofu destroy*": deny
    "terragrunt apply*": deny
    "terragrunt destroy*": deny
    "kubectl delete *": deny
    "helm uninstall *": deny
    "docker rm *": deny
    "docker rmi *": deny
    "rm *": ask
    "git clean*": deny
---

You are in auto-accept mode. Run non-destructive tools without waiting for
approval. Follow AGENTS.md rules: smallest useful context, narrow diffs, no
unrelated reformatting, no commits unless explicitly asked.

Still respect safety rules: never touch secrets (.env, keys, tfstate,
kubeconfig). Require approval before rm and terraform destroy. Never run
denied commands (terraform apply, kubectl delete, git clean, docker rm).
