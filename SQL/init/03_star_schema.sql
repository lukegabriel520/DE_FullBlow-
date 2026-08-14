-- Grain: one fact row = one order line
-- Dims: dim_customer, dim_product, dim_store, dim_date
-- Fact: sales_fact
-- Fact keys (FKs): customer_key, product_key, store_key, date_key
-- Degenerate: order_id (no dim_order)
-- Measures: quantity, line_amount
-- Non-additive on the fact: unit_price

DROP TABLE IF EXISTS sales_fact;
DROP TABLE IF EXISTS dim_customer;
DROP TABLE IF EXISTS dim_product;
DROP TABLE IF EXISTS dim_store;
DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_customer (
    customer_key INT PRIMARY KEY,
    customer_id INT UNIQUE NOT NULL,
    first_name VARCHAR(255) NOT NULL, 
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL, 
    signup_date DATE NOT NULL,
    segment VARCHAR(20) CHECK (segment IN ('NEW', 'REGULAR', 'VIP')) NOT NULL
);

CREATE TABLE dim_product (
    product_key INT PRIMARY KEY,
    product_id INT UNIQUE NOT NULL,
    sku VARCHAR(255) UNIQUE NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    category VARCHAR(255) CHECK (category in ('Electronics', 'Apparel', 'Home')) NOT NULL,
    brand VARCHAR(255) NOT NULL,
    unit_cost NUMERIC(10, 2) NOT NULL, 
    list_price NUMERIC(10, 2) NOT NULL
);


CREATE TABLE dim_store (
    store_key INT PRIMARY KEY,
    store_id INT UNIQUE NOT NULL, 
    store_name VARCHAR(255) NOT NULL, 
    city VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL,
    channel VARCHAR(255) CHECK (channel IN ('ONLINE', 'RETAIL')) NOT NULL
);

CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE UNIQUE NOT NULL,
    year INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(255) NOT NULL,
    day INT NOT NULL,
    day_name VARCHAR(255) NOT NULL,
    week INT NOT NULL
);

CREATE TABLE sales_fact (
    sales_key INT PRIMARY KEY,
    customer_key INT NOT NULL REFERENCES dim_customer (customer_key),
    product_key INT NOT NULL REFERENCES dim_product (product_key),
    store_key INT NOT NULL REFERENCES dim_store (store_key),
    date_key INT NOT NULL REFERENCES dim_date (date_key),
    order_id INT NOT NULL,
    quantity INT NOT NULL,
    line_amount NUMERIC(10, 2) NOT NULL,
    unit_price NUMERIC(10, 2) NOT NULL,
    status VARCHAR(255) CHECK (status IN ('COMPLETED', 'PENDING', 'CANCELLED')) NOT NULL
);