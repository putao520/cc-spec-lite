# Database Development Standards - CODING-STANDARDS-DATABASE

**Version**: 2.0.0
**Scope**: Database development positions (SQL/NoSQL/Graph/Time-series databases, technology stack agnostic)
**Last Updated**: 2025-12-25

---

## 🚨 Core Iron Rules (Inherited from common.md)

> **Must follow the four core iron rules from common.md**

```
Iron Rule 1: SPEC is the Only Source of Truth (SSOT)
       - Data models must comply with SPEC definitions
       - Table structures, indexes, and constraints follow SPEC

Iron Rule 2: Smart Reuse and Destroy-Rebuild
       - Existing table structures completely matched → Direct reuse
       - Partial match → Rebuild with migration scripts

Iron Rule 3: Prohibitive Incremental Development
       - Prohibit keeping old fields and adding new fields
       - Prohibit compatibility views and triggers

Iron Rule 4: Context7 Research First
       - Database design references best practices
       - Use mature ORM and query patterns
```

---

## 🗄️ Data Modeling

### Design Principles
- ✅ Comply with business domain model
- ✅ Clear entity relationships and constraints
- ✅ Design based on access patterns (read-heavy/write-heavy/balanced)
- ✅ Avoid over-normalization or de-normalization
- ❌ Prohibit using business data as primary keys

### Naming Conventions
- ✅ Table/collection names: plural nouns (users, orders)
- ✅ Column/field names: singular nouns (user_id, created_at)
- ✅ Index naming: idx_[table_name]_[column_name]
- ✅ Foreign key naming: fk_[table_name]_[referenced_table_name]
- ❌ Avoid reserved words and special characters

### Data Types
- ✅ Use smallest data type that meets requirements
- ✅ Clear string length limitations
- ✅ Use UTC for time storage
- ✅ Use fixed-point or integer for amounts (avoid floating-point)
- ❌ Prohibit abuse of TEXT/BLOB types

---

## 🔐 Data Integrity

### Constraint Settings
- ✅ Primary key constraints: Each table must have a primary key
- ✅ NOT NULL constraints: Required fields clearly marked
- ✅ Unique constraints: Business uniqueness guaranteed through indexes
- ✅ Foreign key constraints: Relationships clearly defined
- ✅ Check constraints: Business rules validated at database layer

### Default Values and Computed Fields
- ✅ Reasonable default settings (created_at defaults to current time)
- ✅ Status fields have clear initial values
- ✅ Computed fields consider storage vs real-time calculation trade-offs
- ❌ Avoid ambiguous NULL values (use defaults or Optional types)

---

## 📊 Query Optimization

### Query Design
- ✅ Clear query intent, avoid SELECT *
- ✅ Use parameterized queries (prevent SQL injection)
- ✅ Break complex queries into multiple steps
- ✅ Avoid N+1 query problems
- ✅ Use EXPLAIN to analyze execution plans
- ❌ Prohibit function operations on columns in WHERE clauses

### Index Strategies
- ✅ Create indexes on high-query-frequency fields
- ✅ Composite indexes follow leftmost prefix principle
- ✅ Covering indexes optimize query performance
- ✅ Regularly monitor index usage
- ✅ Delete unused indexes
- ❌ Avoid over-indexing (impacts write performance)

### Pagination and Limits
- ✅ Large datasets must be paginated
- ✅ Use cursor pagination instead of OFFSET (for large offsets)
- ✅ Limit rows returned per query (< 10,000 rows)
- ✅ Consider time range limits for aggregate queries

---

## ⚡ Transaction Management

### Transaction Principles
- ✅ Clear transaction boundaries (ACID requirements)
- ✅ Keep transactions as short as possible (reduce lock hold time)
- ✅ Avoid executing external IO operations within transactions
- ✅ Use appropriate isolation levels
- ✅ Explicit commit or rollback

### Concurrency Control
- ✅ Understand concurrency issues (dirty read, non-repeatable read, phantom read)
- ✅ Use optimistic or pessimistic locking
- ✅ Avoid deadlocks (access resources in same order)
- ✅ Set transaction timeout
- ❌ Avoid holding locks for long periods

---

## 🔄 Data Migration

### Migration Standards
- ✅ All schema changes through migration scripts
- ✅ Migration scripts are repeatable (idempotent)
- ✅ Backward-compatible change strategies
- ✅ Batch execute large table changes
- ✅ Backup data before migration
- ❌ Prohibit manual production database schema modifications

### Version Control
- ✅ Migration files named with timestamps or version numbers
- ✅ Record migration history
- ✅ Provide rollback scripts
- ✅ Verify migrations in development environment
- ❌ Prohibit modification of already executed migration scripts

---

## 🛡️ Data Security

### Access Control
- ✅ Principle of least privilege
- ✅ Application accounts have only necessary permissions ( prohibit root connections)
- ✅ Sensitive data encrypted storage
- ✅ Regular audit of database access logs
- ❌ Prohibit hardcoding database credentials in code

### SQL Injection Protection
- ✅ 100% use parameterized queries/prepared statements
- ✅ Validate and sanitize user input
- ✅ Limit database error information exposure
- ❌ Prohibit string concatenation SQL

### Data Masking
- ✅ Mask sensitive fields (phone, email, ID card)
- ✅ Don't log sensitive data
- ✅ Use masked data in development environment
- ❌ Prohibit plaintext password storage

---

## 📈 Performance and Monitoring

### Performance Optimization
- ✅ Monitor slow query logs
- ✅ Regularly analyze table statistics
- ✅ Reasonable use of connection pools
- ✅ Cache hot data
- ✅ Read-write separation (read-heavy scenarios)
- ✅ Sharding and partitioning (ultra-large scale data)

### Capacity Planning
- ✅ Monitor data growth trends
- ✅ Regularly clean up historical data
- ✅ Archive cold data
- ✅ Set table size alerts
- ✅ Reserve storage space

---

## 💾 Backup and Recovery

### Backup Strategy
- ✅ Regular full backups
- ✅ Incremental backups (high-change frequency scenarios)
- ✅ Verify backup recoverability
- ✅ Offsite backup storage
- ✅ Record backup timestamps

### Disaster Recovery
- ✅ Define Recovery Time Objective (RTO)
- ✅ Define Recovery Point Objective (RPO)
- ✅ Regular recovery drills
- ✅ Master-slave replication/cluster high availability
- ✅ Monitor replication lag

---

## 📋 Database Development Checklist

- [ ] Data model complies with business domain
- [ ] Primary keys, indexes, and constraints complete
- [ ] Queries use parameterization (prevent SQL injection)
- [ ] Indexes cover high-frequency queries
- [ ] Transaction boundaries clear and short
- [ ] Migration scripts are idempotent and rollbackable
- [ ] Sensitive data encrypted and masked
- [ ] Slow query monitoring and optimization
- [ ] Backup strategy and recovery verification

---

---

## 🏛️ Advanced Architectural Patterns (20+ years experience)

### Distributed Database Architecture
```
Sharding Strategies:
- Horizontal sharding: by user ID/time range
- Vertical sharding: by business module
- Consistent hashing: dynamic scaling
- Shard key selection: high cardinality, even distribution, frequently queried

Read-Write Separation Architecture:
- Master-slave replication (async/semi-sync/sync)
- Read request load balancing
- Write-read consistency guarantee
- Automatic failover

Multi-active Architecture:
- Dual-master replication (conflict resolution)
- Partition tolerance (CAP trade-offs)
- Nearest access (geographic distribution)
- Data synchronization lag monitoring
```

### NewSQL and Distributed Transactions
```
Distributed Transaction Patterns:
- 2PC (Two-Phase Commit): strong consistency, poor performance
- TCC (Try-Confirm-Cancel): eventual consistency
- Saga Pattern: long transaction orchestration
- Local Message Table: reliable message delivery

NewSQL Selection:
- TiDB: MySQL compatible, horizontal scaling
- CockroachDB: PostgreSQL compatible, strong consistency
- YugabyteDB: multi-model support
- Use cases: OLTP + Distributed
```

### Multi-Model Database Design
```
Relational (RDBMS):
- Use cases: Transaction processing, strong consistency requirements
- Representatives: PostgreSQL, MySQL

Document:
- Use cases: Flexible schema, nested data
- Representatives: MongoDB, Couchbase

Time-Series:
- Use cases: Monitoring, IoT, financial quotes
- Representatives: TimescaleDB, InfluxDB

Graph:
- Use cases: Social networks, knowledge graphs
- Representatives: Neo4j, Amazon Neptune

Vector:
- Use cases: AI retrieval, similarity search
- Representatives: Pinecone, Milvus, pgvector
```

---

## 🔧 Essential Techniques for Senior Developers

### Deep Query Optimization Techniques
```
Execution Plan Analysis:
- EXPLAIN ANALYZE actual execution statistics
- Identify Seq Scan vs Index Scan
- Identify Nested Loop vs Hash Join
- Evaluate Rows estimation accuracy

Advanced Index Strategies:
- Partial indexes (WHERE conditions)
- Expression indexes (function indexes)
- Covering indexes (Include columns)
- Conditional indexes (filtered indexes)

Query Rewrite Techniques:
- CTE recursive query optimization
- Window functions replace self-joins
- EXISTS replaces IN (subqueries)
- LATERAL JOIN advanced usage
```

### High Concurrency Scenario Optimization
```
Lock Optimization:
- Row-level locks vs Table-level locks
- Optimistic locking (version number) vs Pessimistic locking
- Avoid lock escalation
- Deadlock detection and prevention

Connection Pool Tuning:
- Pool size = (core count * 2) + disk count
- Connection lifecycle management
- Warm-up strategy
- Monitor idle connections

Batch Operation Optimization:
- Batch INSERT (Bulk Insert)
- COPY command (PostgreSQL)
- Batch process large transactions
- Delayed index updates
```

### Data Archiving and Hot-Cold Separation
```
Tiered Storage Strategy:
- Hot data: SSD, high-frequency access
- Warm data: HDD, periodic access
- Cold data: Object storage, archive query

Archiving Solutions:
- Time-based partitioning (by month/quarter)
- Automatic archiving triggers
- Archive table compression
- Archive data remains queryable

Table Partitioning:
- Range partitioning (time)
- List partitioning (enumerated values)
- Hash partitioning (even distribution)
- Partition pruning
```

### High Availability and Disaster Recovery
```
Replication Topology:
- Cascading replication (reduce master pressure)
- Ring replication (multi-data center)
- Delayed replication (accidental operation recovery)

Failover:
- Automatic Failover (Patroni/Orchestrator)
- VIP floating
- DNS switching
- Application layer routing

RPO/RTO Design:
- RPO=0: Synchronous replication (performance sacrifice)
- RPO<1min: Semi-synchronous replication
- RTO<30s: Automatic failover
```

---

## 🚨 Common Pitfalls for Senior Developers

### Design Pitfalls
```
❌ Over-normalization:
- Split all data into separate tables
- Queries require multi-table JOINs
- Correct approach: Moderate de-normalization based on access patterns

❌ JSON/JSONB Field Abuse:
- Store relational data as JSON
- Lose constraint and index advantages
- Correct approach: Use JSON for truly flexible data

❌ Ignoring Data Growth:
- Design only considers current data volume
- Query performance degrades after table bloating
- Correct approach: Capacity planning, reserve partitions
```

### Performance Pitfalls
```
❌ SELECT * Habit:
- Query all columns
- Cannot use covering indexes
- Correct approach: Explicitly specify required columns

❌ ORM Abuse:
- N+1 query problems
- Over-abstraction hides inefficient queries
- Correct approach: Monitor ORM-generated SQL

❌ Over-indexing:
- Index every column
- Write performance severely degraded
- Correct approach: Build indexes based on query patterns
```

### Operations Pitfalls
```
❌ Large Table DDL Assessment:
- Direct ALTER TABLE on large tables
- Long table locking
- Correct approach: Online DDL tools (pt-osc/gh-ost)

❌ Backup Verification:
- Have backups but never restore and verify
- Discover backup corruption when actually needed
- Correct approach: Regular restore drills

❌ Ignoring Replication Lag:
- Read from replicas without considering lag
- Data inconsistency
- Correct approach: Monitor lag, critical reads go to master
```

---

## 📊 Performance Monitoring Metrics

| Metric | Target Value | Alert Threshold | Measurement Tool |
|--------|-------------|----------------|------------------|
| Query Response Time (P99) | < 100ms | > 500ms | APM/Slow query logs |
| QPS | Varies by scenario | > 80% capacity | Monitoring system |
| Connection Usage Rate | < 70% | > 90% | Connection pool monitoring |
| Cache Hit Rate | > 95% | < 80% | Database statistics |
| Replication Lag | < 1s | > 10s | Replication monitoring |
| Deadlock Frequency | 0 | > 1/hour | Database logs |
| Disk Usage Rate | < 70% | > 85% | System monitoring |
| IOPS | Varies by storage | > 80% capacity | IO monitoring |
| Long Transactions | 0 | > 5 minutes | Transaction monitoring |
| Index Bloat | < 20% | > 50% | pg_stat_user_indexes |

---

## 📋 Database Development Checklist (Complete)

### Design Check
- [ ] Data model complies with business domain
- [ ] Partitioning/sharding strategy clear
- [ ] Primary keys, indexes, and constraints complete
- [ ] Consider future data growth

### Query Check
- [ ] All queries use parameterization
- [ ] Execution plans analyzed
- [ ] No N+1 query problems
- [ ] High-frequency queries have index coverage

### Transaction Check
- [ ] Transaction boundaries clear and short
- [ ] Concurrency control strategy clear
- [ ] No long transactions

### Operations Check
- [ ] Migration scripts are idempotent and rollbackable
- [ ] Backup strategy and recovery verified
- [ ] Monitoring and alerts configured
- [ ] High availability solution verified

---

**Database Development Principles Summary**:
Data integrity, query optimization, transaction ACID, security protection, performance monitoring, backup recovery, migration version control, least privilege, parameterized queries, capacity planning
