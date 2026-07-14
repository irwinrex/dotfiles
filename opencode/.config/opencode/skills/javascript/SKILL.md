---
name: javascript
description: JavaScript and TypeScript guidance for frontend, Node.js, tooling, tests, package management, and production build quality.
license: MIT
compatibility: opencode
metadata:
  language: javascript
  includes: typescript
---

## Use when

- Working on `.js`, `.jsx`, `.ts`, `.tsx`, package scripts, bundlers, frontend apps, Node.js services, or tooling.
- Reviewing dependency, build, lint, test, SSR, API, or browser-runtime changes.

## Rules

- Inspect `package.json` scripts before guessing commands.
- Preserve the repository package manager. Use the existing lockfile as the signal: `bun.lock`, `pnpm-lock.yaml`, `yarn.lock`, or `package-lock.json`.
- Prefer TypeScript-safe changes when TypeScript is present. Do not add `any` to bypass design issues unless explicitly justified.
- Keep runtime boundaries clear: browser-only, server-only, edge, and build-time code should not leak into each other.
- Avoid broad dependency upgrades unless requested.
- Do not edit generated build output or minified vendor assets directly.

## Verification

- Prefer focused commands from `package.json`:
  - lint/typecheck for touched packages
  - focused unit tests
  - targeted build when runtime boundaries changed
- If no scripts exist, state that clearly and use static inspection.

## DevOps checks

- Check env var usage, secret exposure in client bundles, Docker build context, cache invalidation, and health/readiness endpoints.
- For CI changes, check package-manager cache key, lockfile consistency, and pinned actions/images.
