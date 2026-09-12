-- ============================================================================
-- E-Commerce Data Warehouse Schema (Snowflake Schema Architecture)
-- Target Database: PostgreSQL
-- ============================================================================

DROP TABLE IF EXISTS fact_sales CASCADE;
DROP TABLE IF EXISTS dim_product CASCADE;
DROP TABLE IF EXISTS dim_customer CASCADE;
DROP TABLE IF EXISTS dim_location CASCADE;
DROP TABLE IF EXISTS dim_category CASCADE;
DROP TABLE IF EXISTS dim_brand CASCADE;
DROP TABLE IF EXISTS dim_date CASCADE;
DROP TABLE IF EXISTS dim_payment CASCADE;
DROP TABLE IF EXISTS dim_order_status CASCADE;
DROP TABLE IF EXISTS raw_ecommerce_sales CASCADE;

CREATE TABLE raw_ecommerce_sales (
    order_id VARCHAR(50),
    order_date DATE,
    customer_id VARCHAR(50),
    customer_name VARCHAR(100),
    customer_age INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(100),
    product_id VARCHAR(50),
    product_name VARCHAR(150),
    category VARCHAR(100),
    brand VARCHAR(100),
    quantity INT,
    unit_price NUMERIC(10, 2),
    discount_pct NUMERIC(5, 2),
    payment_method VARCHAR(50),
    order_status VARCHAR(50),
    customer_rating INT,
    total_price NUMERIC(12, 2),
    discount_amount NUMERIC(12, 2),
    order_year INT,
    order_month INT,
    order_day INT,
    order_quarter INT,
    price_category VARCHAR(50)
);

CREATE TABLE dim_location (
    location_key SERIAL PRIMARY KEY,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    CONSTRAINT unq_location UNIQUE (city, state)
);

CREATE TABLE dim_customer (
    customer_key SERIAL PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL UNIQUE,
    customer_name VARCHAR(100) NOT NULL,
    age INT,
    location_key INT REFERENCES dim_location(location_key)
);

CREATE TABLE dim_category (
    category_key SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE dim_brand (
    brand_key SERIAL PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE dim_product (
    product_key SERIAL PRIMARY KEY,
    product_id VARCHAR(50) NOT NULL UNIQUE,
    product_name VARCHAR(150) NOT NULL,
    category_key INT REFERENCES dim_category(category_key),
    brand_key INT REFERENCES dim_brand(brand_key),
    base_price NUMERIC(10, 2)
);

CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL UNIQUE,
    day INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    quarter INT NOT NULL,
    year INT NOT NULL,
    day_of_week VARCHAR(20) NOT NULL
);

CREATE TABLE dim_payment (
    payment_key SERIAL PRIMARY KEY,
    payment_method VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE dim_order_status (
    status_key SERIAL PRIMARY KEY,
    order_status VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE fact_sales (
    sales_key SERIAL PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    customer_key INT REFERENCES dim_customer(customer_key),
    product_key INT REFERENCES dim_product(product_key),
    date_key INT REFERENCES dim_date(date_key),
    payment_key INT REFERENCES dim_payment(payment_key),
    status_key INT REFERENCES dim_order_status(status_key),
    quantity INT NOT NULL,
    unit_price NUMERIC(10, 2) NOT NULL,
    discount_pct NUMERIC(5, 2) NOT NULL,
    discount_amount NUMERIC(12, 2) NOT NULL,
    total_price NUMERIC(12, 2) NOT NULL,
    customer_rating INT NOT NULL
);

CREATE INDEX idx_fact_customer ON fact_sales(customer_key);
CREATE INDEX idx_fact_product ON fact_sales(product_key);
CREATE INDEX idx_fact_date ON fact_sales(date_key);
CREATE INDEX idx_fact_payment ON fact_sales(payment_key);
CREATE INDEX idx_fact_status ON fact_sales(status_key);
