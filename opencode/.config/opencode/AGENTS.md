# Global OpenCode Rules

Default behavior:

- Start by identifying the smallest useful context. Use `rg`, `fd`, `git status`, and targeted file reads before broad scans.
- Do not read generated, vendored, dependency, cache, state, lock, or log files unless the task directly requires them.
- Keep plans short. For simple work, state the change and execute it. For risky work, state assumptions and rollback.
- Preserve user changes. Check `git status` before edits and avoid touching unrelated files.
- Prefer patches with narrow diffs. Do not reformat unrelated files.
- Verify changes with the most focused command first, then broaden only when risk justifies it.

DevOps defaults:

- Treat infrastructure changes as production-impacting unless proven otherwise.
- Prefer plan/diff/validate before apply/deploy.
- Never run destructive cloud, Kubernetes, Terraform, Helm, Docker, or Git commands without explicit approval.
- Do not expose secrets. Avoid reading `.env`, Terraform state, kubeconfigs, private keys, certificates, token files, or cloud credential files.
- For deployments, call out blast radius, rollback path, health checks, and observability impact.
- For Kubernetes, check namespace, context, resources, limits, probes, selectors, and rollout strategy.
- For Terraform/OpenTofu/Terragrunt, check state safety, provider versions, module boundaries, drift risk, and import/migration steps.
- For CI/CD, check least-privilege tokens, cache scope, pinned actions/images, branch protections, and artifact retention.

Token discipline:

- Summarize command output instead of pasting large logs.
- Keep persistent decisions in concise bullets.
- Ask for missing context only when it changes the implementation path materially.
- After long work, produce a handoff with current status, changed files, validation, blockers, and next step.
