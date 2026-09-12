# E-Commerce Data Warehouse and Customer Analytics

## Project Overview

This project implements a Data Warehouse and Data Mining solution for analyzing e-commerce sales transactions and customer purchasing behavior.

The project uses a **Snowflake Schema** for dimensional modelling and **K-Means Clustering** for customer segmentation.

The complete workflow includes:

- Data collection & raw dataset generation
- Data preprocessing & feature engineering
- Extract, Transform, and Load (ETL) pipeline
- Data Warehouse design
- Snowflake Schema implementation
- Data loading into PostgreSQL
- SQL-based business sales analytics
- Customer segmentation using K-Means Clustering

---

## Project Title

**E-Commerce Data Warehouse and Customer Analytics using Snowflake Schema and K-Means Clustering**

---

## Technologies Used

- Python
- Pandas
- NumPy
- Scikit-learn
- PostgreSQL
- SQL
- K-Means Clustering
- Matplotlib
- Seaborn
- GitHub

---

## Dataset Details

The raw dataset contains:

- **15,000 rows**
- **17 columns**

The dataset contains information related to:

- Orders & Transactions (`order_id`, `order_date`)
- Customer Demographics (`customer_id`, `customer_name`, `customer_age`, `customer_city`, `customer_state`)
- Product & Catalog (`product_id`, `product_name`, `category`, `brand`)
- Order Quantities & Pricing (`quantity`, `unit_price`, `discount_pct`)
- Payment & Fulfillment (`payment_method`, `order_status`)
- Customer Feedback (`customer_rating`)

### Data Preprocessing

After preprocessing:

- **15,000 records** processed cleanly
- **24 columns** available
- Missing values handled
- Additional derived attributes created:
  - `total_price`
  - `discount_amount`
  - `order_year`
  - `order_month`
  - `order_day`
  - `order_quarter`
  - `price_category`

The cleaned dataset is available in:

`data/cleaned_ecommerce_sales.csv`

---

## Data Warehouse Design

The project uses a **Snowflake Schema** for dimensional modelling to normalize sub-dimensions like location and product attributes.

### Dimension Tables

- `dim_customer`
- `dim_location`
- `dim_category`
- `dim_brand`
- `dim_product`
- `dim_date`
- `dim_payment`
- `dim_order_status`

### Fact Table

- `fact_sales`

The raw cleaned data is first loaded into:

- `raw_ecommerce_sales`

The ETL process then populates the dimension tables and finally the fact table.

---

## Warehouse Architecture

```text
                    dim_location
                         |
                         |
                    dim_customer
                         |
                         |
dim_category ---> dim_product <--------- dim_brand
                         |
                         |
dim_payment -------> fact_sales <--------- dim_date
                         |
                         |
                  dim_order_status
```

---

## Repository Structure

```text
E-commerce-Analysis---DWDM/
│-- data/
│   ├── ecommerce_dataset.csv          # Raw transaction dataset
│   ├── cleaned_ecommerce_sales.csv    # Preprocessed dataset
│   └── customer_segments.csv         # Customer cluster assignments
│-- docs/
│   └── project_diary.md               # Detailed project diary & log
│-- python/
│   ├── data_preprocessing.py          # Data cleaning & feature engineering
│   └── kmeans_customer_segmentation.py# K-Means clustering & visualization
│-- sql/
│   ├── 01_schema.sql                  # PostgreSQL Snowflake DDL schema
│   ├── 02_etl.sql                     # ETL transformation & load scripts
│   └── 03_analytics.sql               # Analytical SQL business queries
│-- customer_segments.png              # Cluster scatter plot visualization
│-- requirements.txt                   # Python dependencies
└── README.md                          # Project documentation
```

---

## Running the Project

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/YashBardhanRoy/E-commerce-Analysis---DWDM.git
   cd E-commerce-Analysis---DWDM
   ```

2. **Install Dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Run Data Preprocessing:**
   ```bash
   python python/data_preprocessing.py
   ```

4. **Set Up Database & Execute ETL (PostgreSQL):**
   - Create database: `CREATE DATABASE ecommerce_dw;`
   - Run DDL: `psql -d ecommerce_dw -f sql/01_schema.sql`
   - Load cleaned CSV into `raw_ecommerce_sales`
   - Run ETL: `psql -d ecommerce_dw -f sql/02_etl.sql`

5. **Run Analytical Queries:**
   ```bash
   psql -d ecommerce_dw -f sql/03_analytics.sql
   ```

6. **Run Customer Segmentation (K-Means):**
   ```bash
   python python/kmeans_customer_segmentation.py
   ```

---

## Customer Segmentation Results

The K-Means clustering algorithm evaluated cluster counts from $K=2$ to $K=8$.

The highest silhouette score was achieved for **K = 2**:

| K | Silhouette Score |
|---|---:|
| 2 | 0.4780 |
| 3 | 0.2044 |
| 4 | 0.1967 |
| 5 | 0.2002 |
| 6 | 0.2053 |
| 7 | 0.1959 |
| 8 | 0.2000 |

### Customer Segments

- **Cluster 0 (High-Value Premium Buyers):** 236 customers, average spending ₹50,724.35. High order values & premium category purchases.
- **Cluster 1 (Regular Buyers):** 2,258 customers, average spending ₹12,371.49. Value-conscious & steady order volume.

Visualization generated and saved to `customer_segments.png`.

---

## Conclusion

The project successfully implements an end-to-end Data Warehousing and Data Mining solution for e-commerce transactions, demonstrating practical applications of **ETL, Snowflake Schema Dimensional Modelling, PostgreSQL Analytics, and K-Means Clustering**.
