SELECT dp.category, ROUND(SUM(sf.line_amount), 2) AS revenue
FROM sales_fact sf
JOIN dim_product dp on sf.product_key = dp.product_key
JOIN dim_date dd on sf.date_key = dd.date_key
WHERE dd.year = 2024
AND dd.month = 3
AND sf.status = 'COMPLETED'
GROUP BY dp.category;

SELECT dd.year, dd.month, COUNT(DISTINCT sf.order_id) AS orders, ROUND(SUM(sf.line_amount) / COUNT(DISTINCT sf.order_id), 2) AS aov
FROM sales_fact sf
JOIN dim_date dd on sf.date_key = dd.date_key
WHERE sf.status = 'COMPLETED'
GROUP BY dd.year, dd.month
ORDER BY dd.month ASC;