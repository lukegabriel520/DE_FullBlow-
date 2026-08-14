-- dim_date
INSERT INTO dim_date (date_key, full_date, year, month, month_name, day, day_name, week) VALUES
(20240108, '2024-01-08', 2024, 1, 'January', 8, 'Monday', 2),
(20240214, '2024-02-14', 2024, 2, 'February', 14, 'Wednesday', 7),
(20240305, '2024-03-05', 2024, 3, 'March', 5, 'Tuesday', 10),
(20240312, '2024-03-12', 2024, 3, 'March', 12, 'Tuesday', 11),
(20240318, '2024-03-18', 2024, 3, 'March', 18, 'Monday', 12),
(20240320, '2024-03-20', 2024, 3, 'March', 20, 'Wednesday', 12),
(20240401, '2024-04-01', 2024, 4, 'April', 1, 'Monday', 14);

-- dim_customer
INSERT INTO dim_customer (customer_key, customer_id, first_name, last_name, email, city, country, signup_date, segment) VALUES
(1, 101, 'Ana', 'Reyes', 'ana@shopflow.test', 'Manila', 'PH', '2023-11-01', 'VIP'),
(2, 102, 'Ben', 'Cruz', 'ben@shopflow.test', 'Quezon City', 'PH', '2023-12-01', 'REGULAR'),
(3, 103, 'Cara', 'Lim', 'cara@shopflow.test', 'Dubai', 'AE', '2023-06-15', 'VIP'),
(4, 104, 'Dan', 'Tan', 'dan@shopflow.test', 'Manila', 'PH', '2024-01-02', 'NEW'),
(5, 105, 'Eva', 'Santos', 'eva@shopflow.test', 'Abu Dhabi', 'AE', '2023-09-01', 'REGULAR'),
(6, 106, 'Fay', 'Ong', 'fay@shopflow.test', 'Cebu', 'PH', '2024-03-01', 'NEW'),
(7, 107, 'Gio', 'Nair', 'gio@shopflow.test', 'Dubai', 'AE', '2023-08-20', 'REGULAR');

-- dim_product
INSERT INTO dim_product (product_key, product_id, sku, product_name, category, brand, unit_cost, list_price) VALUES
(1, 501, 'SKU-SHIRT-01', 'Cotton Shirt', 'Apparel', 'BasicWear', 8.00, 25.00),
(2, 502, 'SKU-MOUSE-01', 'Wireless Mouse', 'Electronics', 'LogiTech', 12.00, 40.00),
(3, 503, 'SKU-LAMP-01', 'Desk Lamp', 'Home', 'LumenCo', 15.00, 45.00),
(4, 504, 'SKU-PHONE-01', 'Phone Case', 'Electronics', 'CasePro', 3.00, 15.00),
(5, 505, 'SKU-TOWEL-01', 'Bath Towel', 'Home', 'SoftHome', 6.00, 18.00);

-- dim_store
INSERT INTO dim_store (store_key, store_id, store_name, city, country, channel) VALUES
(1, 1, 'Manila Online', 'Manila', 'PH', 'ONLINE'),
(2, 2, 'BGC Retail', 'Taguig', 'PH', 'RETAIL'),
(3, 3, 'Dubai Mall', 'Dubai', 'AE', 'RETAIL'),
(4, 4, 'Dubai Online', 'Dubai', 'AE', 'ONLINE');

-- sales_fact
INSERT INTO sales_fact (sales_key, customer_key, product_key, store_key, date_key, order_id, quantity, unit_price, line_amount, status) VALUES
(1, 1, 1, 1, 20240108, 1001, 2, 25.00, 50.00, 'COMPLETED'),
(2, 1, 2, 1, 20240108, 1001, 1, 40.00, 40.00, 'COMPLETED'),
(3, 3, 4, 3, 20240305, 1002, 3, 12.00, 36.00, 'COMPLETED'),
(4, 3, 3, 3, 20240305, 1002, 1, 45.00, 45.00, 'COMPLETED'),
(5, 2, 1, 2, 20240312, 1003, 1, 25.00, 25.00, 'COMPLETED'),
(6, 4, 2, 1, 20240320, 1004, 2, 40.00, 80.00, 'PENDING'),
(7, 5, 5, 4, 20240214, 1005, 4, 18.00, 72.00, 'CANCELLED'),
(8, 1, 1, 2, 20240401, 1006, 1, 25.00, 25.00, 'COMPLETED'),
(9, 1, 5, 2, 20240401, 1006, 2, 18.00, 36.00, 'COMPLETED'),
(10, 7, 2, 3, 20240318, 1007, 1, 40.00, 40.00, 'COMPLETED');