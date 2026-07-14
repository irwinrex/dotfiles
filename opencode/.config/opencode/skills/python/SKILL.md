---
name: python
description: Python development guidance for scripts, services, automation, data tools, tests, packaging, virtual environments, and DevOps workflows.
license: MIT
compatibility: opencode
metadata:
  language: python
  focus: automation-devops
---

## Use when

- Working on `.py`, `pyproject.toml`, requirements files, Python CLIs, automation scripts, web services, data pipelines, or infrastructure tooling.
- Reviewing typing, packaging, tests, dependency changes, runtime configuration, or cloud/Kubernetes automation.

## Rules

- Detect the project tool before changing commands: `uv`, Poetry, Hatch, pip-tools, pip, tox, nox, pytest, ruff, mypy.
- Keep scripts idempotent and explicit about filesystem, cloud, and network side effects.
- Prefer small pure functions around parsing/transform logic and thin wrappers around I/O.
- Preserve typing style already used. Do not weaken types to silence errors.
- Handle timeouts, retries, exit codes, and structured errors for automation.
- Do not edit generated files, vendored code, virtualenvs, caches, or lockfiles unless the task requires dependency changes.

## Verification

- Prefer focused checks:
  - `pytest path/to/test.py`
  - `ruff check .`
  - `ruff format --check .`
  - `mypy .`
  - project-specific `uv run`, `poetry run`, `tox`, or `nox` commands

## DevOps checks

- Confirm secret handling, config loading order, environment variable names, log redaction, retry behavior, and idempotency.
- For containers, confirm non-root runtime, slim dependencies, reproducible installs, and health checks.
