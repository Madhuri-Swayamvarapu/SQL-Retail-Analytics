
1. Data Understanding
  
-- 1.	Find total number of transactions.
select count(*) as Total_No_Transactions from sales5;

-- 2.	Find total revenue generated.
select sum(amount) as revenue from sales5
  
-- 3.	Find total unique customers.
select count(distinct(customer_id)) as Unique_customer from customers5
  
-- 4.	Find average order value.
select avg(amount) as Avg_order_value from sales5
  
-- 5.	Find total quantity sold.
select sum(quantity) as Total_quantity_sold from sales5
  
-- 6.	Find minimum and maximum sale amount.
select min(amount) as Min_amt,max(amount) as Max_amt from sales5
  
-- 7.	Find average discount given.
select round(avg(discount),2) as Avg_discount from sales5

-- 8.	Find total sales per store.
select s1.store_id,s1.store_name,sum(s2.amount) as Total_sales from stores5 s1
left join sales5 s2
on s1.store_id=s1.store_id
group by s1.store_id,s1.store_name

-- 9.	Find total sales per category.
select p.product_id ,p.category,sum(s.amount)as Total_sales from products5 p
left join sales5 s
on p.product_id=s.product_id
group by p.product_id ,p.category

-- 10.	Find number of transactions per day.
select sale_date,count(sale_id) as No_of_transactions from sales5
group by sale_date

--------------------------------------------------------------------------------------------------------------------------------------------------------------
2. Data Cleaning

-- 11.	Replace NULL discount with 0.
select sale_id,nvl(discount,0) as discount from sales5

-- 12.	Find number of NULL discounts.
select count(*) from sales5
where discount is null

-- 13.	Calculate net revenue (amount - discount).
select sum(amount-nvl(discount,0)) as revenue from sales5

-- 14.	Replace NULL quantity with 1.
select nvl(quantity,1) from sales5

-- 15.	Identify rows where amount is NULL.
select sale_id,customer_id from sales5 where amount is null

-- 16.	Use COALESCE to handle multiple NULL columns.
select sale_id,COALESCE (amount,quantity,discount,0) as value from sales5

-- 17.	Create a cleaned column for revenue.
select sale_id,nvl(amount,0)-nvl(discount,0) as cleaned_revenue from sales5
-- 18.	Check percentage of missing data.
SELECT 
  ROUND(AVG(CASE WHEN amount IS NULL THEN 1 ELSE 0 END) * 100, 2) AS amount_missing_pct,
  ROUND(AVG(CASE WHEN discount IS NULL THEN 1 ELSE 0 END) * 100, 2) AS discount_missing_pct,
  ROUND(AVG(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) * 100, 2) AS quantity_missing_pct
FROM sales5;

-- 19.	Flag rows with missing values.
select sale_id,
CASE 
    when amount is null or discount is null then 'missing'
    else 'complete'
    end as flag
    from sales5

select * from sales5
-----------------------------------------------------------------------------------------------------------------------------------------------------------
  3. Filtering (WHERE)
  
    -- 21.	Find sales in last 30 days.
    select * from sales5
    where max(sale_date)>=sysdate-30
    
-- 21.	Find sales above 5000.
select * from sales5 where amount>5000

-- 22.	Find sales between 1000 and 5000.
select * from sales5 where amount>1000 and amount<5000

-- 23.	Find sales from CMR store.
select s.store_id,store_name,product_id,quantity,amount,nvl(discount,0) from sales5 s
left join stores5 ss
on s.store_id=ss.store_id
where store_name='CMR'

-- 24.	Find Electronics category sales.
select p.product_id,p.category,sum(amount) as Amount from products5 p
join sales5 s
on p.product_id=s.product_id
where category='Electronics'
group by  p.product_id,p.category

-- 25.	Find sales excluding Grocery category.
SELECT *
FROM sales5 s
LEFT JOIN products5 p
ON s.product_id = p.product_id
WHERE p.category IS NULL OR p.category <> 'Grocery';


select * from  sales5
-- 26.	Find customers from specific store.
SELECT DISTINCT c.customer_id,
                c.customer_name,
                s.store_id,
                st.store_name
FROM sales5 s
JOIN customers5 c
  ON s.customer_id = c.customer_id
JOIN stores5 st
  ON s.store_id = st.store_id
WHERE st.store_name = 'CMR';

-- 27.	Find high discount transactions.
SELECT sale_id,
       customer_id,
       store_id,
       product_id,
       amount,
       NVL(discount,0) AS discount,
       sale_date
FROM sales5
WHERE NVL(discount,0) > 300;

-- 28.	Find low quantity sales.
SELECT * FROM sales5
WHERE quantity < 2;

-- 29.	Find recent transactions.
SELECT *
FROM sales5
WHERE sale_date >= (SELECT MAX(sale_date) - 7 FROM sales5);

-----------------------------------------------------------------------------------------------------------------------------------------------------------
4.Aggregation (GROUP BY)
  
-- 30.	Revenue per store.
select s1.store_id,s1.store_name,sum(amount) as revenue from stores5 s1
left join sales5 s2
on s1.store_id=s2.store_id
group by  s1.store_id,s1.store_name


-- 31.	Revenue per category.

select p.product_id,p.category,sum(nvl(amount,0)) as revenue from products5 p
left join sales5 s
on p.product_id=s.product_id
group by   p.product_id,p.category

-- 32.	Revenue per customer.
select c.customer_id,sum(amount) as revenue 
from customers5 c
left join sales5 s
on c.customer_id=s.customer_id
group by c.customer_id

-- 33.	Monthly revenue.
SELECT TO_CHAR(sale_date, 'YYYY-MM') AS month,
       NVL(SUM(amount),0) AS revenue
FROM sales5
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY month;

-- 34.	Daily revenue.
select to_char(sale_date,'dd-mm-yyyy') as daily,
nvl(sum(amount),0) as revenue
from sales5
group by to_char(sale_date,'dd-mm-yyyy')
order by daily

-- 35.	Average sales per store.
select to_char(sale_date,'dd-mm-yyyy') as daily,
round(nvl(avg(amount),0),2) as avg_sales
from sales5
group by to_char(sale_date,'dd-mm-yyyy')
order by daily

-- 36.	Total quantity per category.
select p.category,NVL(SUM(s.quantity),0) as Total_Quantity from products p
left join sales s
 on p.product_id=s.product_id
group by p.category

-- 37.	Total discount per store.
SELECT st.store_name,
       NVL(SUM(s.discount),0) AS total_discount
FROM stores5 st
LEFT JOIN sales5 s
ON st.store_id = s.store_id
GROUP BY st.store_name
ORDER BY st.store_name;

-- 38.	Customer-wise total spending.
SELECT c.customer_id,
       c.customer_name,
       NVL(SUM(s.amount),0) AS total_spent
FROM customers5 c
LEFT JOIN sales5 s
ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;

-- 39.	Store-wise transaction count.
SELECT st.store_name,
       COUNT(s.sale_id) AS transaction_count
FROM stores5 st
LEFT JOIN sales5 s
ON st.store_id = s.store_id
GROUP BY st.store_name
ORDER BY transaction_count DESC;
-----------------------------------------------------------------------------------------------------------------------------------------------------------
5. HAVING
  
-- 40.	Customers with revenue > 20000
select customer_id,nvl(sum(amount),0) as revenue   from sales5
group by customer_id
having  nvl(sum(amount),0) >20000

-- 41.	Stores with revenue > 100000.
select s.store_id,s.store_name,nvl(sum(amount),0) as Store_revenue from stores5 s
left join sales5 ss
on s.store_id=ss.store_id
group by s.store_id,s.store_name
having nvl(sum(amount),0)>100000

-- 42.	Categories with avg sales > 3000.
select p.category,round(nvl(avg(amount),0),2)  as avg_sales from products5 p
left join sales5 s
on p.product_id=s.product_id
group by p.category
having nvl(avg(amount),0)>3000


-- 43.	Customers with more than 5 transactions.
SELECT customer_id,
       COUNT(sale_id) AS transaction_count
FROM sales5
GROUP BY customer_id
HAVING COUNT(sale_id) > 5;

-- 44.	Stores with high discount usage.   
select s1.store_id,s1.store_name,nvl(sum(discount),0) as Total_discount from stores5 s1
left join sales5 s2
on s1.store_id=s2.store_id
group by s1.store_id,s1.store_name
having nvl(sum(discount),0) >65000

-- 45.	Categories with low performance.
SELECT p.category,
       NVL(SUM(s.amount),0) AS total_revenue
FROM products5 p
LEFT JOIN sales5 s
ON p.product_id = s.product_id
GROUP BY p.category
HAVING NVL(SUM(s.amount),0) < 90000;

-- 46. Customers with high avg order value
SELECT customer_id,
       ROUND(NVL(AVG(amount),0),2) AS avg_order_value
FROM sales5
GROUP BY customer_id
HAVING NVL(AVG(amount),0) > 5000;

-- 47.	Find top 5 customers using HAVING.
SELECT customer_id,
       SUM(amount) AS total_revenue
FROM sales5
GROUP BY customer_id
ORDER BY total_revenue DESC
FETCH FIRST 5 ROWS ONLY;

-- 48.	Stores with max transactions.
SELECT s.store_id,
       st.store_name,
       COUNT(s.sale_id) AS transaction_count
FROM sales5 s
JOIN stores5 st
ON s.store_id = st.store_id
GROUP BY s.store_id, st.store_name
HAVING COUNT(s.sale_id) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(sale_id) AS cnt
        FROM sales5
        GROUP BY store_id
    )
);

-- 49.	Categories with high growth.
SELECT p.category,
       SUM(CASE WHEN TO_CHAR(s.sale_date,'MM') = '02' THEN s.amount ELSE 0 END) AS feb_sales,
       SUM(CASE WHEN TO_CHAR(s.sale_date,'MM') = '01' THEN s.amount ELSE 0 END) AS jan_sales
FROM sales5 s
JOIN products5 p
ON s.product_id = p.product_id
GROUP BY p.category
HAVING SUM(CASE WHEN TO_CHAR(s.sale_date,'MM') = '02' THEN s.amount ELSE 0 END) >
       SUM(CASE WHEN TO_CHAR(s.sale_date,'MM') = '01' THEN s.amount ELSE 0 END);

------------------------------------------------------------------------------------------------------------------------------------------------------
6.CASE WHEN
  
-- 50.	Classify customers as High/Medium/Low spenders.
SELECT c.customer_id,
       c.customer_name,
       CASE 
           WHEN NVL(SUM(s.amount),0) < 100000 THEN 'Low spender'
           WHEN NVL(SUM(s.amount),0) < 500000 THEN 'Medium spender'
           ELSE 'High spender'
       END AS shopping_category
FROM customers5 c
LEFT JOIN sales5 s
ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name;

-- 51.	Classify transactions as Big/Small.
SELECT sale_id,
       CASE 
           WHEN amount > 5000 THEN 'Big'
           ELSE 'Small'
       END AS transaction_category
FROM sales5;

-- 52. Create discount flag
SELECT sale_id,
       CASE 
           WHEN discount IS NULL OR discount = 0 THEN 'No Discount'
           ELSE 'Discount Applied'
       END AS discount_flag
FROM sales5;

-- 53. Segment stores based on revenue
SELECT s.store_id,
       st.store_name,
       SUM(s.amount) AS revenue,
       CASE 
           WHEN SUM(s.amount) > 2000000 THEN 'High'
           WHEN SUM(s.amount) > 1000000 THEN 'Medium'
           ELSE 'Low'
       END AS store_segment
FROM sales5 s
JOIN stores5 st
ON s.store_id = st.store_id
GROUP BY s.store_id, st.store_name

-- 54. Categorize customers based on frequency
SELECT customer_id,
       COUNT(sale_id) AS transactions,
       CASE 
           WHEN COUNT(sale_id) > 20 THEN 'Frequent'
           WHEN COUNT(sale_id) > 10 THEN 'Regular'
           ELSE 'Occasional'
       END AS customer_type
FROM sales5
GROUP BY customer_id;

-- 55. Create sales buckets
SELECT sale_id,
       CASE 
           WHEN amount < 1000 THEN 'Low'
           WHEN amount < 5000 THEN 'Medium'
           ELSE 'High'
       END AS sales_bucket
FROM sales5;

-- 56. Identify premium customers
SELECT customer_id,
       SUM(amount) AS total_spent
FROM sales5
GROUP BY customer_id
HAVING SUM(amount) > 50000;

-- 57. Mark high-value transactions
SELECT sale_id,
       CASE 
           WHEN amount > 7000 THEN 'High Value'
           ELSE 'Normal'
       END AS transaction_type
FROM sales5;

-- 58. Classify categories based on performance
SELECT p.category,
       SUM(s.amount) AS revenue,
       CASE 
           WHEN SUM(s.amount) > 100000 THEN 'High'
           WHEN SUM(s.amount) > 50000 THEN 'Medium'
           ELSE 'Low'
       END AS performance
FROM sales5 s
JOIN products5 p
ON s.product_id = p.product_id
GROUP BY p.category;

-- 59. Create custom labels for reporting
SELECT sale_id,
       customer_id,
       amount,
       CASE 
           WHEN amount > 5000 AND discount IS NOT NULL THEN 'High Value + Discount'
           WHEN amount > 5000 THEN 'High Value'
           WHEN discount IS NOT NULL THEN 'Discounted Sale'
           ELSE 'Regular Sale'
       END AS label
FROM sales5;

-----------------------------------------------------------------------------------------------------------------------------------------------------------
7. JOINS (Multiple Tables)
  
-- 60.	Join sales with customers table.
select  s.sale_id,
       s.sale_date,
       s.amount,
       c.customer_id,
       c.customer_name from  sales5 s
left join customers5 c
on s.customer_id=c.customer_id

-- 61. Join sales with stores table
SELECT s.sale_id,
       s.amount,
       s.store_id,
       st.store_name
FROM sales5 s
LEFT JOIN stores5 st
ON s.store_id = st.store_id;

-- 62. Join sales with products table
SELECT s.sale_id,
       s.amount,
       p.product_id,
       p.category
FROM sales5 s
LEFT JOIN products5 p
ON s.product_id = p.product_id;

-- 63. Find customer name with store name and sales
SELECT c.customer_name,
       st.store_name,
       s.amount
FROM sales5 s
JOIN customers5 c
ON s.customer_id = c.customer_id
JOIN stores5 st
ON s.store_id = st.store_id;

-- 64. Find category-wise revenue using joins
SELECT p.category,
       SUM(s.amount) AS revenue
FROM sales5 s
JOIN products5 p
ON s.product_id = p.product_id
GROUP BY p.category;

-- 65. Find store-wise customer count
SELECT st.store_id,
       st.store_name,
       COUNT(DISTINCT s.customer_id) AS customer_count
FROM sales5 s
JOIN stores5 st
ON s.store_id = st.store_id
GROUP BY st.store_id, st.store_name

-- 66. Find top product per store
SELECT st.store_id,
       st.store_name,
       COUNT(DISTINCT s.customer_id) AS customer_count
FROM sales5 s
JOIN stores5 st
ON s.store_id = st.store_id
GROUP BY st.store_id, st.store_name

-- 67. Find customers who purchased from multiple stores
    SELECT customer_id,
        COUNT(DISTINCT store_id) AS store_count
    FROM sales5
    GROUP BY customer_id
    HAVING COUNT(DISTINCT store_id) > 1;

-- 68. Find sales with product category
    SELECT s.sale_id,
        s.amount,
        p.category
    FROM sales5 s
    JOIN products5 p
    ON s.product_id = p.product_id
;
-- 69. Find revenue per customer per store
SELECT s.customer_id,
       s.store_id,
       SUM(s.amount) AS revenue
FROM sales5 s
GROUP BY s.customer_id, s.store_id;


-- 70. Find customers with no transactions (LEFT JOIN)
SELECT c.customer_id,
       c.customer_name
FROM customers5 c
LEFT JOIN sales5 s
ON c.customer_id = s.customer_id
WHERE s.customer_id IS NULL;

-- 71. Find missing product mappings
SELECT s.sale_id,
       s.product_id
FROM sales5 s
LEFT JOIN products5 p
ON s.product_id = p.product_id
WHERE p.product_id IS NULL


-- 72. Find store performance using joins
SELECT st.store_id,
       st.store_name,
       SUM(s.amount) AS revenue,
       COUNT(s.sale_id) AS transactions
FROM stores5 st
LEFT JOIN sales5 s
ON st.store_id = s.store_id
GROUP BY st.store_id, st.store_name;

-- 73. Find cross-category purchases
SELECT customer_id,
       COUNT(DISTINCT p.category) AS category_count
FROM sales5 s
JOIN products5 p
ON s.product_id = p.product_id
GROUP BY customer_id
HAVING COUNT(DISTINCT p.category) > 1;


-- 74. Find total revenue using joins
SELECT SUM(s.amount) AS total_revenue
FROM sales5 s
JOIN products5 p
ON s.product_id = p.product_id;
------------------------------------------------------------------------------------------------------------------------------------------------------------
8.Window Functions
  
-- 75. Calculate total spend per customer using window function
SELECT sale_id,
       customer_id,
       amount,
       SUM(amount) OVER (PARTITION BY customer_id) AS total_spent
FROM sales5;

-- 76. Rank customers by revenue
SELECT customer_id,
       SUM(amount) AS revenue,
       RANK() OVER (ORDER BY SUM(amount) DESC) AS rank
FROM sales5
GROUP BY customer_id;

-- 77. Find top customer per store
SELECT store_id,
       customer_id,
       total_spent
FROM (
    SELECT store_id,
           customer_id,
           SUM(amount) AS total_spent,
           RANK() OVER (PARTITION BY store_id ORDER BY SUM(amount) DESC) AS rnk
    FROM sales5
    GROUP BY store_id, customer_id
)
WHERE rnk = 1;

-- 78. Calculate running total of sales
SELECT sale_date,
       amount,
       SUM(amount) OVER (ORDER BY sale_date) AS running_total
FROM sales5;

-- 79. Find previous sale using LAG
SELECT sale_id,
       sale_date,
       amount,
       LAG(amount) OVER (ORDER BY sale_date) AS previous_sale
FROM sales5;

-- 80. Find next sale using LEAD
SELECT sale_id,
       sale_date,
       amount,
       LEAD(amount) OVER (ORDER BY sale_date) AS next_sale
FROM sales5;

-- 81. Calculate sales growth
SELECT sale_date,
       amount,
       amount - LAG(amount) OVER (ORDER BY sale_date) AS growth
FROM sales5;

-- 82. Find difference between transactions
SELECT sale_id,
       amount,
       amount - LAG(amount) OVER (ORDER BY sale_id) AS difference
FROM sales5;

-- 83. Calculate cumulative revenue
SELECT sale_date,
       SUM(amount) OVER (ORDER BY sale_date) AS cumulative_revenue
FROM sales5;

-- 84. Find moving average of sales
SELECT sale_date,
       amount,
       AVG(amount) OVER (ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
FROM sales5;

-- 85. Rank stores by revenue
SELECT store_id,
       SUM(amount) AS revenue,
       RANK() OVER (ORDER BY SUM(amount) DESC) AS rank
FROM sales5
GROUP BY store_id;

-- 86. Find second highest sale
SELECT *
FROM (
    SELECT sale_id,
           amount,
           RANK() OVER (ORDER BY amount DESC) AS rnk
    FROM sales5
)
WHERE rnk = 2;

-- 87. Partition data by store and analyze
SELECT store_id,
       sale_id,
       amount,
       SUM(amount) OVER (PARTITION BY store_id) AS store_total
FROM sales5;

-- 88. Find customer ranking per store
SELECT store_id,
       customer_id,
       SUM(amount) AS revenue,
       RANK() OVER (PARTITION BY store_id ORDER BY SUM(amount) DESC) AS rank
FROM sales5
GROUP BY store_id, customer_id;

-- 89. Calculate frequency using window
SELECT sale_id,
       customer_id,
       COUNT(*) OVER (PARTITION BY customer_id) AS frequency
FROM sales5;

-----------------------------------------------------------------------------------------------------------------------------------------------------------
9.NTILE / Segmentation
  
-- 90. Divide customers into 4 segments
SELECT customer_id,
       SUM(amount) AS revenue,
       NTILE(4) OVER (ORDER BY SUM(amount) DESC) AS segment
FROM sales5
GROUP BY customer_id;

-- 91. Identify top 25% customers
SELECT *
FROM (
    SELECT customer_id,
           SUM(amount) AS revenue,
           NTILE(4) OVER (ORDER BY SUM(amount) DESC) AS seg
    FROM sales5
    GROUP BY customer_id
)
WHERE seg = 1;

-- 92. Identify bottom 25% customers
SELECT *
FROM (
    SELECT customer_id,
           SUM(amount) AS revenue,
           NTILE(4) OVER (ORDER BY SUM(amount) DESC) AS seg
    FROM sales5
    GROUP BY customer_id
)
WHERE seg = 4;

-- 93. Segment stores into 3 groups
SELECT store_id,
       SUM(amount) AS revenue,
       NTILE(3) OVER (ORDER BY SUM(amount) DESC) AS segment
FROM sales5
GROUP BY store_id;

-- 94. Create quartiles based on revenue
SELECT customer_id,
       SUM(amount) AS revenue,
       NTILE(4) OVER (ORDER BY SUM(amount)) AS quartile
FROM sales5
GROUP BY customer_id;

-- 95. Segment customers per store
SELECT store_id,
       customer_id,
       SUM(amount) AS revenue,
       NTILE(3) OVER (PARTITION BY store_id ORDER BY SUM(amount) DESC) AS segment
FROM sales5
GROUP BY store_id, customer_id;

-- 96. Identify premium segment
SELECT *
FROM (
    SELECT customer_id,
           SUM(amount) AS revenue,
           NTILE(4) OVER (ORDER BY SUM(amount) DESC) AS seg
    FROM sales5
    GROUP BY customer_id
)
WHERE seg = 1;

-- 97. Find mid-level customers
SELECT *
FROM (
    SELECT customer_id,
           SUM(amount) AS revenue,
           NTILE(4) OVER (ORDER BY SUM(amount) DESC) AS seg
    FROM sales5
    GROUP BY customer_id
)
WHERE seg IN (2,3);

-- 98. Analyze bucket distribution
SELECT segment,
       COUNT(*) AS customer_count
FROM (
    SELECT customer_id,
           NTILE(4) OVER (ORDER BY SUM(amount) DESC) AS segment
    FROM sales5
    GROUP BY customer_id
)
GROUP BY segment;

-- 99. Create marketing segments
SELECT customer_id,
       SUM(amount) AS revenue,
       CASE 
           WHEN SUM(amount) > 50000 THEN 'Premium'
           WHEN SUM(amount) > 20000 THEN 'Gold'
           WHEN SUM(amount) > 10000 THEN 'Silver'
           ELSE 'Basic'
       END AS marketing_segment
FROM sales5
GROUP BY customer_id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------
10. FIRST_VALUE / LAST_VALUE
  
-- 100. Find highest sale
SELECT MAX(amount) AS highest_sale
FROM sales5;

-- 101. Find lowest sale
SELECT MIN(amount) AS lowest_sale
FROM sales5;

-- 102. Compare each sale with highest
SELECT sale_id,
       amount,
       MAX(amount) OVER () AS highest_sale,
       amount - MAX(amount) OVER () AS difference
FROM sales5;

-- 103. Compare each sale with lowest
SELECT sale_id,
       amount,
       MIN(amount) OVER () AS lowest_sale,
       amount - MIN(amount) OVER () AS difference
FROM sales5;

-- 104. Find highest sale per store
SELECT store_id,
       MAX(amount) AS highest_sale
FROM sales5
GROUP BY store_id;

-- 105. Find lowest sale per store
SELECT store_id,
       MIN(amount) AS lowest_sale
FROM sales5
GROUP BY store_id;

-- 106. Compare category performance
SELECT p.category,
       SUM(s.amount) AS revenue,
       RANK() OVER (ORDER BY SUM(s.amount) DESC) AS rank
FROM sales5 s
JOIN products5 p
ON s.product_id = p.product_id
GROUP BY p.category;

-- 107. Find best customer per store
SELECT store_id,
       customer_id,
       total_spent
FROM (
    SELECT store_id,
           customer_id,
           SUM(amount) AS total_spent,
           RANK() OVER (PARTITION BY store_id ORDER BY SUM(amount) DESC) AS rnk
    FROM sales5
    GROUP BY store_id, customer_id
)
WHERE rnk = 1;

-- 108. Find worst performing category
SELECT *
FROM (
    SELECT p.category,
           SUM(s.amount) AS revenue,
           RANK() OVER (ORDER BY SUM(s.amount)) AS rnk
    FROM sales5 s
    JOIN products5 p
    ON s.product_id = p.product_id
    GROUP BY p.category
)
WHERE rnk = 1;

-- 109. Analyze gap between best and worst
SELECT 
    MAX(amount) AS highest_sale,
    MIN(amount) AS lowest_sale,
    MAX(amount) - MIN(amount) AS gap
FROM sales5;
--------------------------------------------------------------------------------------------------------------------------------------------------------
11.Date Analysis
  
-- 110. Find daily sales
SELECT sale_date,
       SUM(amount) AS daily_sales
FROM sales5
GROUP BY sale_date
ORDER BY sale_date;

-- 111. Find monthly sales
SELECT TO_CHAR(sale_date,'YYYY-MM') AS month,
       SUM(amount) AS monthly_sales
FROM sales5
GROUP BY TO_CHAR(sale_date,'YYYY-MM')
ORDER BY month;

-- 112. Find weekend sales
SELECT sale_id,
       sale_date,
       amount
FROM sales5
WHERE TO_CHAR(sale_date,'DY') IN ('SAT','SUN');

-- 113. Find first sale date
SELECT MIN(sale_date) AS first_sale_date
FROM sales5;

-- 114. Find last sale date
SELECT MAX(sale_date) AS last_sale_date
FROM sales5;

-- 115. Find sales in specific month (Example: Jan 2025)
SELECT *
FROM sales5
WHERE TO_CHAR(sale_date,'MM-YYYY') = '01-2025';

-- 116. Find sales growth month-wise
SELECT month,
       monthly_sales,
       LAG(monthly_sales) OVER (ORDER BY month) AS prev_month_sales,
       monthly_sales - LAG(monthly_sales) OVER (ORDER BY month) AS growth
FROM (
    SELECT TO_CHAR(sale_date,'YYYY-MM') AS month,
           SUM(amount) AS monthly_sales
    FROM sales5
    GROUP BY TO_CHAR(sale_date,'YYYY-MM')
);

-- 117. Find inactive customers (30 days)
SELECT customer_id
FROM sales5
GROUP BY customer_id
HAVING MAX(sale_date) < SYSDATE - 30;

-- 118. Find repeat customers
SELECT customer_id,
       COUNT(*) AS transactions
FROM sales5
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- 119. Find sales trend
SELECT sale_date,
       SUM(amount) AS daily_sales,
       AVG(SUM(amount)) OVER (ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
FROM sales5
GROUP BY sale_date
ORDER BY sale_date;
----------------------------------------------------------------------------------------------------------------------------------------------------------
