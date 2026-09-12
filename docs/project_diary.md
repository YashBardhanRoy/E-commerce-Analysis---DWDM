# Project Diary

## Project Title

**E-Commerce Customer Purchase and Sales Analysis using Snowflake Schema and K-Means Clustering**

---

## 1. Project Objective

The objective of this project is to design and implement a Data Warehouse for an e-commerce transaction dataset and perform customer analytics and data mining using SQL and K-Means Clustering.

The project demonstrates the complete Data Warehousing and Data Mining workflow, including data preprocessing, ETL, dimensional modelling using a Snowflake Schema, data loading, analytical querying, and customer segmentation.

---

## 2. Dataset Details

### Original Dataset

- Records: 15,000
- Columns: 17
- Dataset Type: E-Commerce Sales & Customer Transaction Data
- Data Format: CSV

### Major Attributes

The dataset contains information about:

- Order ID (`order_id`)
- Order Date (`order_date`)
- Customer ID (`customer_id`)
- Customer Name (`customer_name`)
- Customer Age (`customer_age`)
- Customer City (`customer_city`)
- Customer State (`customer_state`)
- Product ID (`product_id`)
- Product Name (`product_name`)
- Product Category (`category`)
- Brand (`brand`)
- Quantity Ordered (`quantity`)
- Unit Price (`unit_price`)
- Discount Percentage (`discount_pct`)
- Payment Method (`payment_method`)
- Order Status (`order_status`)
- Customer Rating (`customer_rating`)

---

## 3. Data Preprocessing

Python and Pandas were used for data preprocessing.

The preprocessing process included:

1. Loading the raw CSV transaction dataset.
2. Inspecting the dataset structure, missing values, and data types.
3. Filtering invalid values (ensuring quantity > 0, unit_price > 0, discount_pct between 0 and 100, ratings between 1 and 5).
4. Removing duplicate records.
5. Converting `order_date` to standard datetime format.
6. Creating derived price features (`total_price`, `discount_amount`).
7. Extracting temporal features (`order_year`, `order_month`, `order_day`, `order_quarter`).
8. Creating a price tier classification (`price_category`).
9. Saving the cleaned dataset to CSV.

### Preprocessing Result

| Parameter | Value |
|---|---:|
| Original Records | 15,000 |
| Original Columns | 17 |
| Final Records | 15,000 |
| Final Columns | 24 |
| Missing Values | 0 |

### Derived Attributes

The following attributes were created:

- `total_price`
- `discount_amount`
- `order_year`
- `order_month`
- `order_day`
- `order_quarter`
- `price_category`

---

## 4. Data Warehouse Design

PostgreSQL was selected as the Data Warehouse database engine.

A **Snowflake Schema** was designed to organize data into fact and dimension tables, normalizing normalized sub-dimensions (such as location normalized from customer, and category/brand normalized from product).

### Fact Table

- `fact_sales`

### Dimension Tables

- `dim_location`
- `dim_customer`
- `dim_category`
- `dim_brand`
- `dim_product`
- `dim_date`
- `dim_payment`
- `dim_order_status`

### Raw/Staging Table

- `raw_ecommerce_sales`

---

## 5. ETL Process

### Extract

The cleaned CSV dataset is extracted and loaded into the `raw_ecommerce_sales` staging table in PostgreSQL.

### Transform

The staging data is transformed into normalized dimensional entities. Location data is isolated from customer addresses, category and brand attributes are decoupled from products, and dates are transformed into calendar keys.

### Load

1. Dimension tables without foreign dependencies (`dim_location`, `dim_category`, `dim_brand`, `dim_date`, `dim_payment`, `dim_order_status`) are populated first.
2. Dependent dimension tables (`dim_customer` linked to `dim_location`, `dim_product` linked to `dim_category` & `dim_brand`) are populated next.
3. The fact table (`fact_sales`) is loaded by joining staging records with all dimension tables to map surrogate keys.

---

## 6. Important Parameters

### Data Warehouse

- Database: PostgreSQL
- Schema Type: Snowflake Schema
- Fact Table: `fact_sales`
- Dimension Tables: 8
- Fact Records: 15,000

### K-Means Parameters

- Algorithm: K-Means Clustering
- Tested K values: 2 to 8
- Feature Scaling: StandardScaler
- Random State: 42
- Number of Initializations: 10
- Selected K: 2

---

## 7. SQL Analytics

SQL analytical queries were developed to extract business insights from the Snowflake Schema.

Major analytical queries include:

1. Overall order volume, total revenue, average order value, and total discounts.
2. Revenue and volume breakdown by product category.
3. Brand-wise sales revenue and market share.
4. Monthly and quarterly sales revenue trends.
5. Payment method distribution and revenue contribution.
6. Identification of top high-value spending customers.
7. Customer satisfaction rating across order delivery statuses.

---

## 8. Customer Segmentation

K-Means Clustering was applied to aggregated customer-level metrics.

### Features Used

- Customer Age (`age`)
- Total Orders (`total_orders`)
- Total Spending (`total_spending`)
- Average Order Value (`avg_order_value`)
- Average Discount (`avg_discount`)
- Average Customer Rating (`avg_rating`)

All numerical features were standardized using `StandardScaler` prior to clustering.

---

## 9. Cluster Selection

K-Means was evaluated across cluster counts $K \in [2, 8]$.

The silhouette score and WCSS (Within-Cluster Sum of Squares) were used to evaluate cluster quality.

| K | Silhouette Score |
|---|---:|
| 2 | 0.4780 |
| 3 | 0.2044 |
| 4 | 0.1967 |
| 5 | 0.2002 |
| 6 | 0.2053 |
| 7 | 0.1959 |
| 8 | 0.2000 |

The highest silhouette score was obtained for **K = 2**.

---

## 10. Customer Segments

### Cluster 0 — High-Value Premium Buyers

- Number of Customers: 236
- Average Spending: 50,724.35
- Primary characteristics: Higher average order value, higher overall spending, preference for premium product tiers.

### Cluster 1 — Regular & Value-Conscious Buyers

- Number of Customers: 2,258
- Average Spending: 12,371.49
- Primary characteristics: Moderate spending, steady purchase frequency, price-sensitive buying pattern.

---

## 11. Project Milestones

| Milestone | Status |
|---|---|
| Dataset Collection & Generation | Completed |
| Dataset Understanding | Completed |
| Data Preprocessing | Completed |
| Cleaned Dataset Creation | Completed |
| PostgreSQL Schema Design | Completed |
| Raw Data Staging Setup | Completed |
| Dimension Table Creation | Completed |
| Fact Table Creation | Completed |
| ETL Process Scripting | Completed |
| SQL Business Analytics | Completed |
| K-Means Algorithm Implementation | Completed |
| Cluster Evaluation (Silhouette / WCSS) | Completed |
| Customer Segmentation Output | Completed |
| Visualization Generation | Completed |
| Documentation & GitHub Setup | Completed |

---

## 12. Final Deliverables

The project contains:

- Raw transaction dataset (`data/ecommerce_dataset.csv`)
- Cleaned transaction dataset (`data/cleaned_ecommerce_sales.csv`)
- Python data preprocessing script (`python/data_preprocessing.py`)
- Python K-Means clustering script (`python/kmeans_customer_segmentation.py`)
- PostgreSQL DDL schema (`sql/01_schema.sql`, `sql/schema.sql`)
- SQL ETL scripts (`sql/02_etl.sql`, `sql/etl.sql`)
- SQL analytical queries (`sql/03_analytics.sql`, `sql/analytics_queries.sql`)
- Customer segmentation output dataset (`data/customer_segments.csv`)
- Customer segmentation visualization plot (`customer_segments.png`)
- Project Diary documentation (`docs/project_diary.md`)
- Comprehensive repository README (`README.md`)

---

## 13. Conclusion

The project successfully implements an end-to-end Data Warehousing and Data Mining pipeline for e-commerce transactions.

The dataset was processed using Python, structured into a PostgreSQL Snowflake Schema, analyzed using SQL, and mined using K-Means Clustering to extract customer behavior patterns.
