---
name: nosql
description: NoSQL guidance for document, key-value, wide-column, search, and cache data stores including MongoDB, DynamoDB, Redis, Cassandra, and Elasticsearch/OpenSearch.
license: MIT
compatibility: opencode
metadata:
  domain: database
  type: nosql
---

## Use when

- Working on MongoDB, DynamoDB, Redis, Cassandra/Scylla, Elasticsearch/OpenSearch, Firestore, or other non-relational stores.
- Reviewing data model, access pattern, index, TTL, cache, consistency, or migration changes.

## Rules

- Start from access patterns. NoSQL schema quality depends on read/write paths, cardinality, and consistency requirements.
- Identify partition/shard keys, hot-key risk, item/document size limits, and expected growth.
- Keep consistency, TTL, retries, backoff, idempotency, and conflict behavior explicit.
- Avoid unbounded scans, wildcard searches, or high-cardinality secondary indexes on production paths.
- For caches, define source of truth, invalidation, TTL, stampede protection, and stale-read tolerance.
- For search indexes, define mapping changes, reindex strategy, aliases, and rollback.

## Verification

- Check the target store’s query/index constraints.
- Validate migration/backfill plan, dual-write/read compatibility, and rollback path.
- Confirm observability for latency, throttling, errors, evictions, replication lag, and hot partitions.

## DevOps checks

- Call out capacity mode, autoscaling, backup/PITR, encryption, IAM/RBAC, network access, and disaster recovery assumptions.
