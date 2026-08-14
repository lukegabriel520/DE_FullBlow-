SELECT customer_id, 
order_id,
order_date,
COALESCE(LEAD (order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date ASC)::text, 'null') AS next_order_date
FROM orders
WHERE status = 'COMPLETED';