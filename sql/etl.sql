-- ============================================================================
-- E-Commerce ETL (Extract, Transform, Load) Pipeline
-- Target Database: PostgreSQL
-- ============================================================================

INSERT INTO dim_location (city, state)
SELECT DISTINCT customer_city, customer_state
FROM raw_ecommerce_sales
ON CONFLICT (city, state) DO NOTHING;

INSERT INTO dim_customer (customer_id, customer_name, age, location_key)
SELECT DISTINCT ON (r.customer_id)
    r.customer_id,
    r.customer_name,
    r.customer_age,
    l.location_key
FROM raw_ecommerce_sales r
JOIN dim_location l ON r.customer_city = l.city AND r.customer_state = l.state
ON CONFLICT (customer_id) DO NOTHING;

INSERT INTO dim_category (category_name)
SELECT DISTINCT category
FROM raw_ecommerce_sales
ON CONFLICT (category_name) DO NOTHING;

INSERT INTO dim_brand (brand_name)
SELECT DISTINCT brand
FROM raw_ecommerce_sales
ON CONFLICT (brand_name) DO NOTHING;

INSERT INTO dim_product (product_id, product_name, category_key, brand_key, base_price)
SELECT DISTINCT ON (r.product_id)
    r.product_id,
    r.product_name,
    c.category_key,
    b.brand_key,
    r.unit_price
FROM raw_ecommerce_sales r
JOIN dim_category c ON r.category = c.category_name
JOIN dim_brand b ON r.brand = b.brand_name
ON CONFLICT (product_id) DO NOTHING;

INSERT INTO dim_date (date_key, full_date, day, month, month_name, quarter, year, day_of_week)
SELECT DISTINCT
    CAST(TO_CHAR(order_date, 'YYYYMMDD') AS INT) AS date_key,
    order_date AS full_date,
    EXTRACT(DAY FROM order_date) AS day,
    EXTRACT(MONTH FROM order_date) AS month,
    TO_CHAR(order_date, 'Month') AS month_name,
    EXTRACT(QUARTER FROM order_date) AS quarter,
    EXTRACT(YEAR FROM order_date) AS year,
    TO_CHAR(order_date, 'Day') AS day_of_week
FROM raw_ecommerce_sales
ON CONFLICT (full_date) DO NOTHING;

INSERT INTO dim_payment (payment_method)
SELECT DISTINCT payment_method
FROM raw_ecommerce_sales
ON CONFLICT (payment_method) DO NOTHING;

INSERT INTO dim_order_status (order_status)
SELECT DISTINCT order_status
FROM raw_ecommerce_sales
ON CONFLICT (order_status) DO NOTHING;

INSERT INTO fact_sales (
    order_id,
    customer_key,
    product_key,
    date_key,
    payment_key,
    status_key,
    quantity,
    unit_price,
    discount_pct,
    discount_amount,
    total_price,
    customer_rating
)
SELECT
    r.order_id,
    cust.customer_key,
    prod.product_key,
    d.date_key,
    pay.payment_key,
    stat.status_key,
    r.quantity,
    r.unit_price,
    r.discount_pct,
    r.discount_amount,
    r.total_price,
    r.customer_rating
FROM raw_ecommerce_sales r
JOIN dim_customer cust ON r.customer_id = cust.customer_id
JOIN dim_product prod ON r.product_id = prod.product_id
JOIN dim_date d ON r.order_date = d.full_date
JOIN dim_payment pay ON r.payment_method = pay.payment_method
JOIN dim_order_status stat ON r.order_status = stat.order_status;
