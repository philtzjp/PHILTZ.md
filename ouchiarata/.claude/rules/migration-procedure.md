---
description: データマイグレーション、DB移行を扱うとき
alwaysApply: false
---

# Migration Procedure

1. MUST create an API to retrieve the number of data records subject to migration
2. MUST create an API to perform the migration and execute a Dry Run
3. IF pre-fetched data count == Dry Run changed count -> proceed to step 4
   ELSE -> MUST fix and re-run
4. MUST execute the migration, then delete the API
