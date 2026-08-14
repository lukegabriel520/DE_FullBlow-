CREATE TABLE orders (
  order_id      INTEGER PRIMARY KEY,
  customer_id   INTEGER NOT NULL,
  order_date    DATE NOT NULL,
  total_amount  NUMERIC(10,2) NOT NULL,
  status        TEXT NOT NULL CHECK (status IN ('COMPLETED', 'PENDING', 'CANCELLED'))
);

CREATE INDEX idx_orders_customer_date ON orders (customer_id, order_date);
