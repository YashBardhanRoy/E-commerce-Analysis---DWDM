import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score

print("========================================")
print("CUSTOMER SEGMENTATION USING K-MEANS")
print("========================================")

# Try loading from PostgreSQL database or CSV file fallback
data_path = "data/cleaned_ecommerce_sales.csv"
if not os.path.exists(data_path):
    data_path = "../data/cleaned_ecommerce_sales.csv"

try:
    import psycopg2
    conn = psycopg2.connect(
        host="localhost",
        port="5432",
        database="ecommerce_dw",
        user="postgres"
    )
    query = """
    SELECT
        c.customer_id,
        c.age,
        COUNT(f.sales_key) AS total_orders,
        SUM(f.total_price) AS total_spending,
        AVG(f.total_price) AS avg_order_value,
        AVG(f.discount_amount) AS avg_discount,
        AVG(f.customer_rating) AS avg_rating
    FROM dim_customer c
    JOIN fact_sales f ON c.customer_key = f.customer_key
    GROUP BY c.customer_id, c.age
    ORDER BY c.customer_id;
    """
    df = pd.read_sql(query, conn)
    conn.close()
    print("[SUCCESS] Customer data fetched successfully from PostgreSQL database!")
except Exception as e:
    print(f"[INFO] Database connection not active. Loading preprocessed CSV dataset ({data_path})...")
    raw_df = pd.read_csv(data_path)
    df = raw_df.groupby(["customer_id", "customer_age"]).agg(
        total_orders=("order_id", "count"),
        total_spending=("total_price", "sum"),
        avg_order_value=("total_price", "mean"),
        avg_discount=("discount_amount", "mean"),
        avg_rating=("customer_rating", "mean")
    ).reset_index()
    df.rename(columns={"customer_age": "age"}, inplace=True)

print("Dataset Shape:", df.shape)
print("\nFirst 5 rows:")
print(df.head())

# Feature Selection for Segmentation
features = [
    "age",
    "total_orders",
    "total_spending",
    "avg_order_value",
    "avg_discount",
    "avg_rating"
]

X = df[features].copy()

# Feature Scaling using StandardScaler
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

print("\n[SUCCESS] Features prepared for K-Means Clustering!")
print("Features used:", features)
print("Scaled data shape:", X_scaled.shape)

# Elbow Method (WCSS calculation for K=2 to 8)
wcss = []
k_range = range(2, 9)

for k in k_range:
    kmeans = KMeans(n_clusters=k, random_state=42, n_init=10)
    kmeans.fit(X_scaled)
    wcss.append(kmeans.inertia_)

print("\n[SUCCESS] Elbow Method completed!")
for k, val in zip(k_range, wcss):
    print(f"K={k}, WCSS={val:.2f}")

# Silhouette Score Evaluation
silhouette_scores = []
for k in k_range:
    kmeans = KMeans(n_clusters=k, random_state=42, n_init=10)
    labels = kmeans.fit_predict(X_scaled)
    score = silhouette_score(X_scaled, labels)
    silhouette_scores.append(score)

print("\n[SUCCESS] Silhouette Score calculated!")
for k, score in zip(k_range, silhouette_scores):
    print(f"K={k}, Silhouette Score={score:.4f}")

# Optimal Cluster Selection
optimal_k = 2
kmeans_final = KMeans(n_clusters=optimal_k, random_state=42, n_init=10)
df["cluster"] = kmeans_final.fit_predict(X_scaled)

print(f"\n[SUCCESS] Final K-Means clustering completed with K={optimal_k}!")

print("\nCluster Distribution:")
print(df["cluster"].value_counts().sort_index())

print("\nCluster Summary (Feature Averages):")
cluster_summary = df.groupby("cluster")[features].mean().round(2)
print(cluster_summary)

print("\nCluster Spending Statistics:")
print(
    df.groupby("cluster")["total_spending"]
    .agg(["count", "mean", "min", "max"])
    .round(2)
)

# Plot Customer Segments Visualization
plt.figure(figsize=(8, 6))
scatter = plt.scatter(
    df["total_spending"],
    df["avg_order_value"],
    c=df["cluster"],
    cmap="viridis",
    alpha=0.6,
    edgecolors="k",
    linewidth=0.5
)
plt.xlabel("Total Spending")
plt.ylabel("Average Order Value")
plt.title("Customer Segmentation using K-Means Clustering")
plt.colorbar(scatter, label="Cluster")
plt.grid(True, linestyle="--", alpha=0.5)

plot_output = "customer_segments.png"
plt.savefig(plot_output, dpi=300, bbox_inches="tight")
plt.close()

print(f"\n[SUCCESS] Customer segmentation graph saved as {plot_output}")

# Save Cluster Results CSV
output_csv = "data/customer_segments.csv"
if not os.path.exists("data"):
    output_csv = "../data/customer_segments.csv"

df.to_csv(output_csv, index=False)
print(f"[SUCCESS] Customer segmentation data saved to {output_csv}")
print(f"Total processed customers: {len(df)}")

