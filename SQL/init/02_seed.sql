-- Hand-designed gaps. Non-COMPLETED rows exist so a missing status filter breaks LAG.
INSERT INTO orders (order_id, customer_id, order_date, total_amount, status) VALUES
-- customer 101: completed gaps 7 then 14 → avg 10.5 (3 completed)
(1,  101, '2024-01-01', 100.00, 'COMPLETED'),
(2,  101, '2024-01-05',  40.00, 'CANCELLED'),
(3,  101, '2024-01-08', 150.00, 'COMPLETED'),
(4,  101, '2024-01-22',  80.00, 'COMPLETED'),

-- customer 102: completed gap 7 → avg 7.0 (2 completed)
(5,  102, '2024-02-01',  50.00, 'COMPLETED'),
(6,  102, '2024-02-08',  60.00, 'COMPLETED'),

-- customer 103: completed gaps 10, 20, 30 → avg 20.0 (4 completed)
(7,  103, '2024-01-10', 200.00, 'COMPLETED'),
(8,  103, '2024-01-20', 210.00, 'COMPLETED'),
(9,  103, '2024-02-09', 220.00, 'COMPLETED'),
(10, 103, '2024-03-10', 230.00, 'COMPLETED'),

-- customer 104: pending in between; completed gap 30 → avg 30.0 (2 completed)
(11, 104, '2024-03-01',  99.00, 'COMPLETED'),
(12, 104, '2024-03-15',  55.00, 'PENDING'),
(13, 104, '2024-03-31', 101.00, 'COMPLETED'),

-- customer 105: completed gaps 14 then 14 → avg 14.0 (3 completed)
(14, 105, '2024-04-01',  75.00, 'COMPLETED'),
(15, 105, '2024-04-10',  20.00, 'CANCELLED'),
(16, 105, '2024-04-15',  88.00, 'COMPLETED'),
(17, 105, '2024-04-29',  92.00, 'COMPLETED'),

-- customer 106: one completed only → drop
(18, 106, '2024-05-01', 300.00, 'COMPLETED'),

-- customer 107: one completed + noise → drop
(19, 107, '2024-05-10',  45.00, 'COMPLETED'),
(20, 107, '2024-05-12',  30.00, 'CANCELLED'),
(21, 107, '2024-05-20',  70.00, 'PENDING');
