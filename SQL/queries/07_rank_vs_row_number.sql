WITH order_count AS (
    SELECT customer_id,
    COUNT(order_id) as total_orders
    FROM orders
    WHERE status = 'COMPLETED'
    GROUP BY customer_id
)


SELECT customer_id, 
total_orders as completed_count, 
ROW_NUMBER() OVER (ORDER BY total_orders DESC) AS row_n, 
RANK() OVER (ORDER BY total_orders DESC) AS rank_n, 
DENSE_RANK() OVER (ORDER BY total_orders DESC) AS dense_n
FROM order_count
ORDER BY completed_count DESC, customer_id ASC;