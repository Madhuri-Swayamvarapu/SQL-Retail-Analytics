-- Create customers table
CREATE TABLE customers (
    customer_id NUMBER,
    customer_name VARCHAR2(50)
);

-- Create stores table
CREATE TABLE stores (
    store_id NUMBER,
    store_name VARCHAR2(50)
);

-- Create products table
CREATE TABLE products (
    product_id NUMBER,
    category VARCHAR2(50)
);

-- Create sales table
CREATE TABLE sales (
    sale_id NUMBER,
    customer_id NUMBER,
    store_id NUMBER,
    product_id NUMBER,
    sale_date DATE,
    amount NUMBER,
    quantity NUMBER,
    discount NUMBER
);
