---
name: go
description: Go development guidance for idiomatic, testable, production-ready services, CLIs, libraries, concurrency, modules, and DevOps-adjacent tooling.
license: MIT
compatibility: opencode
metadata:
  language: go
  focus: backend-devops
---

## Use when

- Working on `.go`, `go.mod`, `go.sum`, generated mocks, CLIs, services, Kubernetes operators, Terraform providers, or Go-based DevOps tools.
- Reviewing concurrency, HTTP/gRPC APIs, error handling, tests, build flags, or module dependency changes.

## Rules

- Prefer simple, explicit code over clever abstractions.
- Keep package boundaries small. Avoid import cycles and large `internal` grab-bags.
- Use `context.Context` for cancellation across I/O, RPC, DB, cloud SDK, and Kubernetes calls.
- Wrap errors with useful operation/context. Do not log and return the same error unless required.
- Avoid goroutine leaks. Every goroutine should have a clear shutdown path.
- Use table-driven tests for branching logic and focused integration tests for external boundaries.
- Do not edit generated files directly. Regenerate through the project command.

## Verification

- Discover commands from repo files first: `Makefile`, `Taskfile.yml`, `justfile`, CI config, `go.mod`.
- Common focused checks:
  - `go test ./...`
  - `go test ./path/to/pkg`
  - `go test -race ./path/to/pkg`
  - `go vet ./...`
  - `gofmt` or `go fmt ./...`

## DevOps checks

- For Kubernetes/client-go, confirm context, namespace, retries, rate limits, and RBAC scope.
- For cloud SDKs, confirm region/account handling, retries, idempotency tokens, and least privilege.
- For CLIs, preserve stable flags, exit codes, stdout/stderr behavior, and machine-readable output.
