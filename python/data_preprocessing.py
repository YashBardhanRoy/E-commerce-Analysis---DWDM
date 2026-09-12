import pandas as pd
import numpy as np

# Load the raw dataset
input_file = "../data/ecommerce_dataset.csv"

try:
    df = pd.read_csv(input_file)
except FileNotFoundError:
    input_file = "data/ecommerce_dataset.csv"
    df = pd.read_csv(input_file)

print("========================================")
print("E-COMMERCE DATASET - DATA PREPROCESSING")
print("========================================")

# Basic information
print("\n1. Dataset Shape:")
print(df.shape)

print("\n2. Number of Rows:", df.shape[0])
print("3. Number of Columns:", df.shape[1])

# Column names
print("\n4. Columns:")
for column in df.columns:
    print("-", column)

# Missing values
print("\n5. Missing Values:")
print(df.isnull().sum())

# Duplicate records
print("\n6. Duplicate Records:")
print(df.duplicated().sum())

# Basic statistics
print("\n7. Numerical Statistics:")
print(df.describe())

# Remove duplicate records
df = df.drop_duplicates()

# Convert date columns
df["order_date"] = pd.to_datetime(df["order_date"], errors="coerce")

# Remove invalid values
df = df[df["quantity"] > 0]
df = df[df["unit_price"] > 0]
df = df[(df["discount_pct"] >= 0) & (df["discount_pct"] <= 100)]
df = df[(df["customer_rating"] >= 1) & (df["customer_rating"] <= 5)]

# Handle missing values if any
for column in df.select_dtypes(include=["object"]).columns:
    df[column] = df[column].fillna("Unknown")

for column in df.select_dtypes(include=["number"]).columns:
    df[column] = df[column].fillna(df[column].median())

# Create useful derived features
df["total_price"] = (df["quantity"] * df["unit_price"] * (1 - df["discount_pct"] / 100.0)).round(2)
df["discount_amount"] = (df["quantity"] * df["unit_price"] * (df["discount_pct"] / 100.0)).round(2)

df["order_year"] = df["order_date"].dt.year
df["order_month"] = df["order_date"].dt.month
df["order_day"] = df["order_date"].dt.day
df["order_quarter"] = df["order_date"].dt.quarter

# Create price tier category
def categorize_price(price):
    if price < 1000:
        return "Budget"
    elif price <= 5000:
        return "Mid-Range"
    else:
        return "Premium"

df["price_category"] = df["unit_price"].apply(categorize_price)

# Save cleaned dataset
output_file = "../data/cleaned_ecommerce_sales.csv"
try:
    df.to_csv(output_file, index=False)
except Exception:
    output_file = "data/cleaned_ecommerce_sales.csv"
    df.to_csv(output_file, index=False)

print("\n========================================")
print("PREPROCESSING COMPLETED")
print("========================================")

print("\nFinal Dataset Shape:")
print(df.shape)

print("\nRemaining Missing Values:")
print(df.isnull().sum().sum())

print("\nCleaned dataset saved successfully:")
print(output_file)
