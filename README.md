# Data Engineering Lab

Hands-on practice for Data Engineer roles in **Manila** and **Dubai**. Both markets hire on **Azure** and **Databricks**, so that is the stack this repo is built around.

The end goal is one capstone: mock events in, warehouse tables out, scheduled by Airflow. I am not there yet. This folder is the work in progress.

**Now:** Phase 1 is done (SQL + a real star schema in Postgres).  
**Next:** Phase 2 — PySpark and Delta Lake on Databricks Free Edition.

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

Until Phase 3, Azure is not in this repo. The SQL lab below is local Docker Postgres.

---

## Progress

| Phase | Weeks | Status |
| --- | --- | --- |
| 1. SQL + physical star schema | 1–2 | **Done** |
| 2. Databricks, PySpark, Delta Lake | 3–5 | Next |
| 3. Terraform + Azure | 6–7 | Not started |
| 4. Airflow + Kafka | 8–10 | Not started |
| 5. Capstone + interview prep | 11–12 | Not started |

---

## Phase 1 — what is in here

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
| `SQL/queries/04_star_queries.sql` | March 2024 revenue by category; AOV by month |
| `SQL/queries/05_units_by_channel.sql` | Units sold by `ONLINE` / `RETAIL` |

AOV uses `COUNT(DISTINCT order_id)` so two lines on the same checkout still count as one order.

---

## Run the SQL lab

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

## Repo layout

```text
SQL/                 Phase 1 (this is the only code so far)
  docker-compose.yml
  init/              schema + seed (runs on first boot)
  queries/           practice queries
  scripts/           run_query.ps1

databricks/          Phase 2 (not in the repo yet)
terraform/           Phase 3
airflow/             Phase 4
kafka/               Phase 4
capstone/            Phase 5
```

Later phases get their own folders. They do not go under `SQL/`.

---

## Phases 2–5 (not built yet)

**Phase 2** — Databricks Free Edition, PySpark DataFrames, Delta Lake (`MERGE`, time travel). Community Edition was retired in January 2026.

**Phase 3** — Terraform: Azure resource group, Blob Storage, Postgres. Billing alerts before anything is applied.

**Phase 4** — Airflow DAG with two dependent tasks. Local Kafka producer / consumer writing JSON.

**Phase 5** — Wire the pieces into one pipeline, document the architecture, practice Azure Data Engineering interview questions for Manila and Dubai.
