# Data Engineering Lab

Hello. This is my hands-on practice for Data Engineer roles in **Manila** and **Dubai**. Both markets hire on **Azure** and **Databricks**, so that is the stack this repo is built around.

The end goal is one capstone: mock events in, warehouse tables out, scheduled by Airflow. I am not there yet. This folder is the work in progress.

**Now:** Phases 1 and 2 are done (SQL + star schema in Postgres; PySpark + Delta on Databricks Free Edition).  
**Next:** Phase 3 — Terraform + Azure (resource group, Blob Storage, Postgres, billing alerts).

---

## What the finished project will look like

```text
Kafka (fake events)
        │
        ▼
Azure Blob  ── Bronze
        │
Databricks + PySpark + Delta Lake
        │
        ├── Silver
        └── Gold
                │
                ▼
        Postgres + dbt
                │
        Airflow runs the schedule

Terraform creates the Azure storage, resource group, and database.
```

Until Phase 3, Azure is not in this repo. Phase 1 runs on local Docker Postgres. Phase 2 runs on Databricks Free Edition (cloud notebooks, not local Spark).

---

## Progress

| Phase | Weeks | Status |
| --- | --- | --- |
| 1. SQL + physical star schema | 1–2 | **Done** |
| 2. Databricks, PySpark, Delta Lake | 3–5 | **Done** |
| 3. Terraform + Azure | 6–7 | Not started |
| 4. Airflow + Kafka | 8–10 | Not started |
| 5. Capstone + interview prep | 11–12 | Not started |

---

## Phase 1 — SQL lab (local Postgres)

Two datasets in the same Postgres database (`ecommerce`):

1. **`orders`** — one row per order. Used to practice window functions and date logic.
2. **ShopFlow star** — warehouse tables. Used to practice facts, dimensions, keys, and reporting joins.

### Window functions (on `orders`)

| File | What it does |
| --- | --- |
| `SQL/queries/01_tier4_reorder_velocity.sql` | CTE + `LAG`: average days between completed orders |
| `SQL/queries/06_row_number_latest_order.sql` | Latest completed order per customer |
| `SQL/queries/07_rank_vs_row_number.sql` | `ROW_NUMBER` vs `RANK` vs `DENSE_RANK` (ties) |
| `SQL/queries/08_lead_next_order.sql` | `LEAD`: next completed order date |
| `SQL/queries/09_date_trunc_monthly.sql` | Monthly buckets with `DATE_TRUNC` |

Postgres note: there is no `DATEDIFF`. `DATE - DATE` returns days. Databricks and SQL Server still use `DATEDIFF`.

### Star schema (ShopFlow)

Grain: **one fact row = one product line on one order.**

```text
                    dim_customer
                          │
dim_date ──── sales_fact ──── dim_product
                          │
                      dim_store
```

- **Fact** (`sales_fact`): keys, `order_id`, `quantity`, `line_amount`, `unit_price`, `status`
- **Dims**: customer, product, store, date
- Fact joins on **surrogate keys** (`customer_key`, not `customer_id`)
- `order_id` stays on the fact. There is no `dim_order` (degenerate dimension)
- `unit_price` is stored but not summed. `SUM(unit_price)` is not a useful metric

| File | What it does |
| --- | --- |
| `SQL/init/03_star_schema.sql` | `CREATE TABLE` + PKs/FKs |
| `SQL/init/04_star_seed.sql` | Load dims first, fact last |
| `SQL/queries/02_star_schema_check.sql` | Verify tables and FKs |
| `SQL/queries/03_star_seed_check.sql` | Row counts after seed |
| `SQL/queries/04_star_queries.sql` | March 2024 revenue by category; AOV by month |
| `SQL/queries/05_units_by_channel.sql` | Units sold by `ONLINE` / `RETAIL` |

AOV uses `COUNT(DISTINCT order_id)` so two lines on the same checkout still count as one order.

### Run the SQL lab

Needs [Docker Desktop](https://www.docker.com/products/docker-desktop/) and PowerShell.

```powershell
cd SQL
docker compose up -d
.\scripts\run_query.ps1 .\queries\01_tier4_reorder_velocity.sql
```

| | |
| --- | --- |
| Engine | Postgres 16 |
| Database | `ecommerce` |
| User / password | `de_student` / `de_student` |
| Host port | `5433` (container is `5432`) |

Init scripts in `SQL/init/` run **only on an empty volume**. After you already started the container once, apply new SQL with `run_query.ps1`, or wipe and rebuild:

```powershell
cd SQL
docker compose down -v
docker compose up -d
```

`down -v` deletes the database. Do not run it if you have local data you want to keep.

---

## Phase 2 — Databricks Free Edition (PySpark + Delta)

Notebooks live in `DataBricks/`. Run them in a [Databricks Free Edition](https://www.databricks.com/learn/free-edition) workspace (Community Edition was retired January 2026). `spark` is already available in the notebook — no local Spark install.

Free Edition quirks worth knowing:

- **Unity Catalog** is on by default. Public DBFS paths like `/tmp/...` are blocked.
- Delta files go under a **Volume**: `/Volumes/workspace/default/de_lab/...`
- `MERGE INTO` on UC **managed** tables (`saveAsTable`) may fail. Use path-based Delta: `delta.\`/Volumes/...\``
- If you overwrite a Delta table with a different schema, add `.option("overwriteSchema", "true")`

| Notebook | What it covers |
| --- | --- |
| `01_hello_spark.py.ipynb` | `createDataFrame`, `printSchema`, `show`, `count` |
| `02_dataframe_basics.py.ipynb` | `filter`, `groupBy`, `agg` — units by channel |
| `03_join_revenue_by_category.py.ipynb` | Inner join fact + product dim, revenue by category |
| `04_delta_merge_timetravel.py.ipynb` | Write Delta, `MERGE` upsert, `DESCRIBE HISTORY`, `versionAsOf` |
| `05_medallion_bronze_silver_gold.py.ipynb` | Bronze → Silver (clean + join) → Gold (aggregate) |

**Join** = combine tables for a query (read). **MERGE** = apply updates into a target table (write). **Medallion** = layered Delta tables: Bronze (landed), Silver (cleaned), Gold (aggregated).

Gold output matches the Postgres star query: Apparel 100, Electronics 116, Home 81 (completed revenue only).

---

## Repo layout

```text
SQL/                 Phase 1 — local Postgres lab
  docker-compose.yml
  init/              schema + seed (runs on first boot)
  queries/           practice queries
  scripts/           run_query.ps1

DataBricks/          Phase 2 — Databricks notebooks (Free Edition)

terraform/           Phase 3 (not started)
airflow/             Phase 4 (not started)
kafka/               Phase 4 (not started)
capstone/            Phase 5 (not started)
```

Later phases get their own folders. They do not go under `SQL/`.

---

## Phases 3–5 (not built yet)

**Phase 3** — Terraform: Azure resource group, Blob Storage, Postgres. Billing alerts before anything is applied.

**Phase 4** — Airflow DAG with two dependent tasks. Local Kafka producer / consumer writing JSON.

**Phase 5** — Wire the pieces into one pipeline, document the architecture, practice Azure Data Engineering interview questions for Manila and Dubai.
