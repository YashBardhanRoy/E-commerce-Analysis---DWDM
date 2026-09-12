# E-Commerce Customer Purchase and Sales Analysis Using Data Warehousing and Data Mining

## Project Overview

This project implements a data-warehouse and data-mining workflow for analysing e-commerce purchases and sales. It uses a Snowflake Schema for dimensional modelling and K-Means clustering for customer segmentation.

## Workflow

- Data preprocessing
- Extract, transform, and load process
- Snowflake Schema implementation
- Data loading
- SQL-based sales analytics
- Customer segmentation with K-Means clustering

## Technologies Used

- Python, Pandas, NumPy, and Scikit-learn
- PostgreSQL and SQL
- Matplotlib and Seaborn

## Repository Structure

- data/ — sample e-commerce transactions
- docs/ — project diary and implementation notes
- python/ — preprocessing and customer-segmentation scripts
- sql/ — schema, ETL, and analytical queries

## Data Warehouse Design

Dimension tables include customer, location, category, brand, product, date, payment, and order status. The fact table, fact_sales, stores order-level sales measures. Cleaned records are staged in raw_ecommerce_sales before the ETL process loads the dimensions and the fact table.

## Running the Project

1. Run the preprocessing script to create the cleaned transaction dataset.
2. Create a PostgreSQL database and run sql/01_schema.sql.
3. Load the cleaned CSV into raw_ecommerce_sales.
4. Run sql/02_etl.sql, followed by sql/03_analytics.sql.
5. Run the customer-segmentation script to save segment results and a visualisation under outputs/.

## Customer Segmentation

The clustering workflow evaluates customer age, total orders, total spending, average order value, and average rating. It selects a cluster count with silhouette scores and writes the resulting segments to a CSV file.

See docs/project_diary.md for the complete project objective, ETL plan, analytics, and deliverables.
