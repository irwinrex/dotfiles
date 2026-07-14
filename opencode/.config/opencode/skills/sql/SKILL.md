---
name: sql
description: SQL guidance for schema design, migrations, query review, indexes, transactions, data safety, performance, and rollback planning.
license: MIT
compatibility: opencode
metadata:
  domain: database
  type: relational
---

## Use when

- Working on SQL queries, migrations, relational schemas, indexes, stored procedures, analytics queries, or ORM-generated SQL.
- Reviewing production database changes.

## Rules

- Treat schema and migration work as production-impacting.
- Identify database engine first: PostgreSQL, MySQL/MariaDB, SQLite, SQL Server, BigQuery, Snowflake, Redshift, etc.
- Prefer reversible, small migrations. Separate expand, backfill, contract steps when zero-downtime matters.
- Do not assume table size is small. Avoid full-table locks/scans on hot paths unless explicitly accepted.
- Use transactions where supported and safe. Know when DDL auto-commits.
- Keep indexes tied to concrete query patterns. Avoid redundant or write-heavy indexes without reason.
- Never expose raw secrets or customer data in examples.

## Verification

- Check syntax for the target engine.
- For queries, inspect joins, filters, cardinality, null behavior, ordering, limits, and index usage.
- For migrations, include rollback or forward-fix strategy, lock risk, backfill approach, and validation query.

## DevOps checks

- Call out blast radius, backup/snapshot requirement, maintenance window needs, replication lag, migration timeout, and observability signals.
