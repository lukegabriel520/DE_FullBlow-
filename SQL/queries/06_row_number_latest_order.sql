WITH latest_order AS (
    SELECT customer_id, 
    order_id, 
    order_date,
    total_amount,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) as rn
    FROM orders 
    WHERE status = 'COMPLETED'
)
SELECT customer_id, order_id, order_date, total_amount
FROM latest_order
WHERE rn = 1;
