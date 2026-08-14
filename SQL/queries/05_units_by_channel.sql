SELECT ds.channel, SUM(sf.quantity) AS units
FROM sales_fact sf
JOIN dim_store ds on sf.store_key = ds.store_key
WHERE sf.status = 'COMPLETED'
GROUP BY ds.channel;