-- 1. How many unique customers are in the city of 'Surat'? 
-- Ans: 11
SELECT COUNT(DISTINCT(customer_name)) AS distinct_customer
FROM dim_customers 
WHERE city = "Surat";

-- 2. What are the minimum and maximum order quantities for each product?
	-- What is the highest quantity available for the product 'AM Tea 100'?
-- Ans: 200
WITH min_max_qty AS (
	SELECT 
		DISTINCT(p.product_name),
		MIN(o.order_qty) AS min_order_qty,
		MAX(o.order_qty) As max_order_qty
	FROM dim_products p
	JOIN fact_order_lines o ON p.product_id = o.product_id
	GROUP BY p.product_id)

SELECT product_name, max_order_qty
FROM min_max_qty
WHERE product_name = "AM Tea 100" ;

-- 3. Generate a report with month_name and number of unfulfilled_orders(i.e order_qty - delivery_qty) in that respective month?
	-- In which month were the unfulfilled orders the highest in number?
-- Ans: May
SELECT 
	MONTHNAME(order_placement_date) AS month_name,
	SUM(order_qty - delivery_qty) AS unfulfilled_orders
FROM fact_order_lines
GROUP BY month_name
ORDER BY unfulfilled_orders DESC
LIMIT 1;

-- 4. What is the percentage breakdown of order_qty by category?
	-- The final output includes the following fields - category, order_qty_pct
	-- What is the percentage of the total order quantity accounted for by the 'food' category? 
-- Ans: 12.50
WITH order_percentage AS (
	WITH total_order_by_categary AS 
		(SELECT 
			p.category,
			SUM(o.order_qty) AS total_qty
		FROM dim_products p
		JOIN fact_order_lines o ON p.product_id = o.product_id
		GROUP BY p.category
		)
	SELECT 
		category,
		/* using window function */
		ROUND(100 * total_qty / SUM(total_qty) OVER (), 2) AS percentage
	FROM total_order_by_categary
	ORDER BY percentage DESC)

SELECT percentage FROM order_percentage WHERE category="Food";

-- 5. Generate a report that includes the customer ID, customer name, ontime_target_pct, and percentage_category. 
	/*  The percentage category is divided into four types: 
		'Above 90' if the  ontime_target_pct is greater than 90, 
		'Above 80' if it is greater than 80, 
		'Above 70' if it is greater than 70, 
		and 'Less than 70' for all other cases.  */
	-- What is the count of customers falling under the 'Above 90' category based on their ontime_target_pct?
-- Ans: 9
WITH customer_report AS 
(SELECT 
		c.customer_id, 
		c.customer_name,
		t.ontime_target_pct,
		CASE 
			WHEN t.ontime_target_pct > 90 THEN 'Above 90'
			WHEN t.ontime_target_pct > 80 THEN 'Above 80'
			WHEN t.ontime_target_pct > 70 THEN 'Above 70'
			ELSE "Below 70"
		END AS percentage_category
	FROM dim_customers c
	JOIN dim_targets_orders t ON c.customer_id = t.customer_id)

SELECT COUNT(customer_id) AS customer_count_above_90 
FROM customer_report 
WHERE percentage_category = "Above 90";

-- 6. Generate a report that lists all the product categories, along with the product names and total count of products in each category.
	/* The output should have three columns: category, products, and product_count. */
    -- What is the count of distinct products available in the 'Dairy' category?
-- Ans: 12
WITH product_list AS (
		SELECT 
			category, 
			GROUP_CONCAT(product_name) AS products, 
			COUNT(*) AS product_count
		FROM dim_products
		GROUP BY category)
        
SELECT product_count FROM product_list WHERE category = 'Dairy';

-- 7. What are the top 3 most demanded products in the 'Dairy' category, and their respective order quantity in millions? 
	/* The final output includes the fields: product name, order_qty_mln. */
    -- What is the total order quantity (in millions) for the top 3 products in the Dairy Category? 
-- Ans: 3.81
WITH top_3_dairy_products AS (
		SELECT 
			p.product_name,
			ROUND((SUM(o.order_qty)/1000000),2) AS order_qty_mln
		FROM dim_products p
		JOIN fact_order_lines o ON p.product_id = o.product_id
		WHERE p.category = 'Dairy'
		GROUP BY p.product_name
		ORDER By order_qty_mln DESC
		LIMIT 3)
        
SELECT SUM(order_qty_mln) AS total_order_qty_for_top_3_ FROM top_3_dairy_products;

-- 8. Calculate the OTIF % for a customer named Vijay Stores
	-- The final output should contain these fields - customer_name, OTIF_percentage 
-- Ans: 28.28
SELECT 
	c.customer_name,
    ROUND(SUM(a.otif)/COUNT(a.order_id)*100, 2) AS OTIF_percentage
FROM dim_customers c
JOIN fact_orders_aggregate a ON c.customer_id = a.customer_id
GROUP BY customer_name
HAVING customer_name = "Vijay Stores";

-- 9. What is the percentage of 'in full' for each product and which product has the highest percentage, 
	-- based on the data from the 'fact_order_lines' and 'dim_products' tables?
    -- What is the count of products with an IF percentage greater than 67%?
-- Ans: 3
WITH in_full_percentage AS (
	WITH in_full_target AS (
		SELECT 
			p.product_name,
			SUM(CASE WHEN l.in_full = 1 THEN 1 
					 ELSE 0
				END ) AS in_full_count,
			COUNT(l.order_id) AS total_count
		FROM dim_products p
		JOIN fact_order_lines l ON l.product_id = p.product_id
		GROUP By product_name)
		
	SELECT 
		product_name,
		ROUND(in_full_count/total_count*100, 2) AS in_full_percentage
	FROM in_full_target
	ORDER BY in_full_percentage DESC)

SELECT COUNT(product_name) AS in_full_perc_greater_than_67
FROM in_full_percentage
WHERE in_full_percentage > 67

