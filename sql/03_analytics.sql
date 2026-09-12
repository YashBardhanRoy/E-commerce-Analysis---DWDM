-- ============================================================================
-- E-Commerce Business Analytics SQL Queries
-- Target Database: PostgreSQL / Snowflake Schema
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Overall Sales Performance Summary
-- ----------------------------------------------------------------------------
SELECT
    COUNT(sales_key) AS total_orders,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(total_price), 2) AS total_revenue,
    ROUND(AVG(total_price), 2) AS avg_order_value,
    ROUND(SUM(discount_amount), 2) AS total_discount_given
FROM fact_sales;

-- ----------------------------------------------------------------------------
-- 2. Revenue and Volume Breakdown by Product Category
-- ----------------------------------------------------------------------------
SELECT
    cat.category_name,
    COUNT(f.sales_key) AS total_orders,
    SUM(f.quantity) AS total_units_sold,
    ROUND(SUM(f.total_price), 2) AS total_revenue,
    ROUND(AVG(f.total_price), 2) AS avg_order_value
FROM fact_sales f
JOIN dim_product prod ON f.product_key = prod.product_key
JOIN dim_category cat ON prod.category_key = cat.category_key
GROUP BY cat.category_name
ORDER BY total_revenue DESC;

-- ----------------------------------------------------------------------------
-- 3. Top Performing Brands by Sales Revenue
-- ----------------------------------------------------------------------------
SELECT
    b.brand_name,
    COUNT(f.sales_key) AS total_orders,
    SUM(f.quantity) AS total_units_sold,
    ROUND(SUM(f.total_price), 2) AS total_revenue
FROM fact_sales f
JOIN dim_product prod ON f.product_key = prod.product_key
JOIN dim_brand b ON prod.brand_key = b.brand_key
GROUP BY b.brand_name
ORDER BY total_revenue DESC;

-- ----------------------------------------------------------------------------
-- 4. Monthly Revenue and Order Growth Trends
-- ----------------------------------------------------------------------------
SELECT
    d.year,
    d.month,
    TRIM(d.month_name) AS month_name,
    COUNT(f.sales_key) AS total_orders,
    ROUND(SUM(f.total_price), 2) AS monthly_revenue
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.year, d.month, d.month_name
ORDER BY d.year, d.month;

-- ----------------------------------------------------------------------------
-- 5. Payment Method Revenue Distribution
-- ----------------------------------------------------------------------------
SELECT
    pay.payment_method,
    COUNT(f.sales_key) AS transaction_count,
    ROUND(SUM(f.total_price), 2) AS total_revenue,
    ROUND(100.0 * SUM(f.total_price) / (SELECT SUM(total_price) FROM fact_sales), 2) AS revenue_share_pct
FROM fact_sales f
JOIN dim_payment pay ON f.payment_key = pay.payment_key
GROUP BY pay.payment_method
ORDER BY total_revenue DESC;

-- ----------------------------------------------------------------------------
-- 6. Top Spending Customers (High-Value Customers)
-- ----------------------------------------------------------------------------
SELECT
    cust.customer_id,
    cust.customer_name,
    loc.city,
    loc.state,
    COUNT(f.sales_key) AS total_orders,
    ROUND(SUM(f.total_price), 2) AS total_spending,
    ROUND(AVG(f.total_price), 2) AS avg_order_value
FROM fact_sales f
JOIN dim_customer cust ON f.customer_key = cust.customer_key
JOIN dim_location loc ON cust.location_key = loc.location_key
GROUP BY cust.customer_id, cust.customer_name, loc.city, loc.state
ORDER BY total_spending DESC
LIMIT 10;

-- ----------------------------------------------------------------------------
-- 7. Order Status & Rating Satisfaction Analysis
-- ----------------------------------------------------------------------------
SELECT
    stat.order_status,
    COUNT(f.sales_key) AS order_count,
    ROUND(AVG(f.customer_rating), 2) AS avg_customer_rating,
    ROUND(SUM(f.total_price), 2) AS total_value
FROM fact_sales f
JOIN dim_order_status stat ON f.status_key = stat.status_key
GROUP BY stat.order_status
ORDER BY order_count DESC;
