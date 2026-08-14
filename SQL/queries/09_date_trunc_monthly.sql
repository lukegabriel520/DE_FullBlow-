SELECT DATE_TRUNC('month', order_date)::date as month_start,
COUNT(order_id) as order_count,
ROUND(SUM(total_amount), 2) as revenue
FROM orders
WHERE status = 'COMPLETED'
GROUP BY month_start
ORDER BY order_count DESC, month_start ASC;