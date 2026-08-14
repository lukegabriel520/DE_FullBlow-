-- Tier 4: Customer Re-order Velocity
-- Write your solution below. Do not ask for the answer — run it.
--
-- Requirement:
--   Filter status = 'COMPLETED'
--   CTE + LAG(order_date) per customer_id ORDER BY order_date
--   Days between consecutive completed orders
--   Outer: AVG(days_between_orders), COUNT completed orders
--   Keep customers with at least 2 completed orders
--   ORDER BY avg_days_between_orders ASC
--
-- Output columns:
--   customer_id
--   total_completed_orders
--   avg_days_between_orders
--
-- Run:
--   .\scripts\run_query.ps1 .\queries\01_tier4_reorder_velocity.sql

WITH days_between_orders AS (
    SELECT 
    customer_id, 
    order_date,
    order_date - LAG(order_date, 1) OVER (
    PARTITION BY customer_id
    ORDER BY order_date
    ) AS days_diff
    FROM orders
    WHERE status = 'COMPLETED'
)


SELECT customer_id,
COUNT(customer_id) AS total_completed_orders,
ROUND(AVG(days_diff), 1) AS avg_days_between_orders
FROM days_between_orders
GROUP BY customer_id 
HAVING COUNT(customer_id) >= 2
ORDER BY avg_days_between_orders ASC;