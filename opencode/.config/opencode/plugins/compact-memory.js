export const CompactMemoryPlugin = async () => {
  return {
    "experimental.session.compacting": async (_input, output) => {
      output.context.push(`
## Continuation Memory Rules

Preserve only information needed to continue safely:

- Current user goal and whether it is diagnosis, implementation, review, or deployment.
- Files intentionally changed, files inspected but not changed, and unrelated user-owned changes.
- Commands already run and their pass/fail result. Do not include full logs unless a short excerpt is essential.
- Decisions, assumptions, constraints, approvals, denied actions, and known rollback path.
- DevOps state: target account/cluster/namespace/workspace/environment, blast radius, validation status, and remaining risks.
- Next smallest actionable step.

Drop duplicated logs, generated output, dependency listings, package lock excerpts, vendored code, and stale exploration.
Keep the continuation compact and operationally useful.
`);
    }
  };
};
