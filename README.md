SQL Project
-
---


Project Overview
--
---
This SQL project involves querying a database to extract meaningful insights and answer specific questions related to customers, orders, products, and their interactions.

---
💻 Tech Stack:
-
---

![SQL/MySQL](https://img.shields.io/badge/-SQL%2FMySQL-blue?logo=mysql&labelColor=ffc6ff&color=ffc6ff) 

Project Queries
-
---

### 1. Unique Customers in Surat

> Question: How many unique customers are in the city of 'Surat'? 
> Ans: 11


### 2. Min-Max Order Quantities for Each Product

```
Quetion: What are the minimum and maximum order quantities for each product?
    -- What is the highest quantity available for the product 'AM Tea 100'?
-- Ans: 200
```

### 3. Monthly Unfulfilled Orders Report
```
Quetion: Generate a report with month_name and number of unfulfilled_orders(i.e order_qty - delivery_qty) in that respective month?
	-- In which month were the unfulfilled orders the highest in number?
-- Ans: May
```

### 4. Order Quantity Percentage Breakdown by Category
```
Quetion: What is the percentage breakdown of order_qty by category?
	-- The final output includes the following fields - category, order_qty_pct
	-- What is the percentage of the total order quantity accounted for by the 'food' category?
-- Ans: 12.50 
```

### 5. Customer On-time Performance Report
```
Quetion: Generate a report that includes the customer ID, customer name, ontime_target_pct, and percentage_category. 
	-- The percentage category is divided into four types: 
		'Above 90' if the  ontime_target_pct is greater than 90, 
		'Above 80' if it is greater than 80, 
		'Above 70' if it is greater than 70, 
		and 'Less than 70' for all other cases. 
	-- What is the count of customers falling under the 'Above 90' category based on their ontime_target_pct?
-- Ans: 9
```

### 6. Product Category-wise Count Report
```
Quetion: Generate a report that lists all the product categories, along with the product names and total count of products in each category.
	-- The output should have three columns: category, products, and product_count.
	-- What is the count of distinct products available in the 'Dairy' category?
-- Ans: 12
```

### 7. Top 3 Demanded Products in Dairy Category
```
Quetion: What are the top 3 most demanded products in the 'Dairy' category, and their respective order quantity in millions?
    -- The final output includes the fields: product name, order_qty_mln. */
    -- What is the total order quantity (in millions) for the top 3 products in the Dairy Category? 
-- Ans: 3.81
```

### 8. OTIF % Calculation for Vijay Stores
```
Quetion: Calculate the OTIF % for a customer named Vijay Stores
    -- The final output should contain these fields - customer_name, OTIF_percentage 
-- Ans: 28.28
```

### 9. Product In-full Percentage Analysis
```
Quetion: What is the percentage of 'in full' for each product and which product has the highest percentage,
    -- based on the data from the 'fact_order_lines' and 'dim_products' tables?
    -- What is the count of products with an IF percentage greater than 67%?
-- Ans: 3
```
