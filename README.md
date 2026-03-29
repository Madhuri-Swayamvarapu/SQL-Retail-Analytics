# 🛒 SQL Retail Analytics Project

# 📌 Overview

This project demonstrates end-to-end SQL skills using a retail dataset. It covers data creation, cleaning, transformation, and advanced analytics using real-world business scenarios.

The goal is to analyze sales, customers, stores, and products to extract meaningful insights.

---

# 🗂️ Database Schema

# Tables Used:

* **customers** → Customer details
* **stores** → Store information
* **products** → Product categories
* **sales** → Transaction data

---

# ⚙️ Features & Concepts Covered

# 🔹 Basic SQL

* SELECT, WHERE, ORDER BY
* Filtering, sorting, conditions

### 🔹 Aggregations

* COUNT, SUM, AVG, MIN, MAX
* GROUP BY & HAVING

# 🔹 Joins

* INNER JOIN
* LEFT JOIN
* Multi-table joins

### 🔹 Data Cleaning

* Handling NULL values (NVL, COALESCE)
* Missing data analysis
* Data validation queries

### 🔹 Conditional Logic

* CASE WHEN
* Segmentation & classification

### 🔹 Window Functions

* RANK(), DENSE_RANK()
* NTILE()
* LAG(), LEAD()
* Running totals & moving averages

### 🔹 Advanced Analytics

* Customer segmentation
* Store performance analysis
* Category-wise insights
* Revenue trends
* Growth analysis

---

## 📊 Key Business Insights

* 💰 Total revenue and average order value
* 🏆 Top customers and best-performing stores
* 📉 Low-performing categories
* 🔁 Repeat vs inactive customers
* 📈 Monthly and daily sales trends
* 🎯 Customer segmentation (Premium, Gold, Silver)

---

## 🧪 Sample Queries

```sql
-- Total revenue
SELECT SUM(amount) FROM sales;

-- Top 5 customers
SELECT customer_id, SUM(amount) AS revenue
FROM sales
GROUP BY customer_id
ORDER BY revenue DESC
FETCH FIRST 5 ROWS ONLY;

-- Customer segmentation
SELECT customer_id,
       CASE 
           WHEN SUM(amount) > 50000 THEN 'Premium'
           WHEN SUM(amount) > 20000 THEN 'Gold'
           ELSE 'Regular'
       END AS segment
FROM sales
GROUP BY customer_id;
```

---

## 📁 Project Structure

```
📦 SQL-Retail-Analytics
 ┣ 📜 schema.sql
 ┣ 📜 data.sql
 ┣ 📜 queries.sql
 ┣ 📜 README.md
```

---

## 🚀 Tools Used

* Oracle SQL / SQL Developer
* Oracle Live SQL

---

## 🎯 Learning Outcomes

* Strong understanding of SQL fundamentals
* Ability to solve real-world business problems
* Hands-on experience with analytics queries
* Confidence in writing optimized SQL

---

## 💡 Future Improvements

* Connect with Power BI / Tableau dashboard
* Add real-world dataset
* Optimize queries for performance
* Add stored procedures & indexes

---

## 🙌 Author

Swayamvarapu Madhuri
Aspiring Data Analyst

---





