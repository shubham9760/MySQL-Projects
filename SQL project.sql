USE gdb023;
#1
#Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region
SELECT DISTINCT(market), customer, region 
FROM
	dim_customer WHERE
		customer='Atliq Exclusive' and region='APAC';

WITH unique_product_2020 as (        
SELECT DISTINCT(COUNT(product_code)) as unique_product_2020
FROM fact_sales_monthly
	WHERE fiscal_year=2020
) SELECT * FROM unique_product_2020;

#2nd
# What is the percentage of unique product increase in 2021 vs. 2020? The
#final output contains these fields,
#unique_products_2020
#unique_products_2021
#percentage_chg
WITH unique_product_2021 as (  
SELECT DISTINCT(COUNT(product_code)) as unique_product_2021
FROM fact_sales_monthly
	WHERE fiscal_year=2021
	)
    SELECT *, ((unique_product_2021 - unique_product_2020)/unique_product_2020)*100 as percentage_change
    FROM unique_product_2021
    CROSS JOIN (SELECT DISTINCT(COUNT(product_code)) as unique_product_2020
FROM fact_sales_monthly
	WHERE fiscal_year=2020) as u20;
 
#3rd
#Provide a report with all the unique product counts for each segment and
#sort them in descending order of product counts. The final output contains
#2 fields,
#segment
#product_count
WITH unique_segmented_product as ( 
SELECT DISTINCT(COUNT(product_code)) as product_count, segment
	FROM dim_product
    GROUP BY segment
    )
	SELECT segment, product_count 
		FROM unique_segmented_product
        ORDER BY product_count DESC;

#4th
# Which segment had the most increase in unique products in
#2021 vs 2020? The final output contains these fields,
#segment
#product_count_2020
#product_count_2021
#difference
WITH CTE1 as (
				SELECT DISTINCT(COUNT(dp.product_code)) as product_count_2020, dp.segment FROM 
					dim_product as dp
                    JOIN fact_sales_monthly as fs
                    ON dp.product_code = fs.product_code
                    WHERE fiscal_year=2020
                    GROUP BY dp.segment
				) 
                SELECT segment, product_count_2020, product_count_2021, (product_count_2021 - product_count_2020) as difference
						FROM CTE1
                        CROSS JOIN (
									SELECT DISTINCT(COUNT(dp.product_code)) as product_count_2021 FROM 
										dim_product as dp
										JOIN fact_sales_monthly as fs
										ON dp.product_code = fs.product_code
										WHERE fiscal_year=2021
										GROUP BY dp.segment
									) as pc21;

#5th
#Get the products that have the highest and lowest manufacturing costs.
#The final output should contain these fields,
#product_code
#product
#manufacturing_cost
WITH CTE1 as (
				SELECT dp.product_code, dp.segment, dp.product, fm.cost_year, fm.manufacturing_cost 
                FROM dim_product dp
				JOIN fact_manufacturing_cost fm
				ON dp.product_code=fm.product_code
			  )
SELECT product_code, product, manufacturing_cost 
FROM CTE1
WHERE manufacturing_cost IN ((SELECT MAX(manufacturing_cost) FROM CTE1), (SELECT MIN(manufacturing_cost) FROM CTE1));

#6th
#Generate a report which contains the top 5 customers who received an average high pre_invoice_discount_pct for the fiscal year 2021 and in the
#Indian market. The final output contains these fields,
#customer_code
#customer
#average_discount_percentage
WITH CTE1 AS
(		
	SELECT dc.customer_code, dc.customer, pre_invoice_discount_pct 
	FROM dim_customer dc
    JOIN fact_pre_invoice_deductions pi
    ON dc.customer_code = pi.customer_code
)
SELECT * FROM CTE1
	WHERE pre_invoice_discount_pct > (SELECT AVG(pre_invoice_discount_pct) FROM CTE1)
    ORDER BY pre_invoice_discount_pct DESC
    LIMIT 5;
    
#7th
#Get the complete report of the Gross sales amount for the customer “Atliq
#Exclusive” for each month. This analysis helps to get an idea of low and
#high-performing months and take strategic decisions.
#The final report contains these columns:
#Month
#Year
#Gross sales Amount
WITH CTE1 AS 
(
SELECT sm.date, sm.product_code, sm.customer_code,dc.customer, sm.fiscal_year, sm.sold_quantity, gp.gross_price,
	ROUND((sm.sold_quantity * gp.gross_price), 2) as total_gross_amount
	FROM fact_sales_monthly sm
    JOIN fact_gross_price gp
    JOIN dim_customer dc
    ON sm.product_code = gp.product_code AND
       sm.fiscal_year = gp.fiscal_year AND
       sm.customer_code = dc.customer_code
	WHERE customer = 'Atliq Exclusive'
)
SELECT MONTH(date) AS sales_month, YEAR(date) AS sales_year, SUM(total_gross_amount) as gross_sales_amount 
	FROM CTE1
    GROUP BY sales_month, sales_year;

#8th
#In which quarter of 2020, got the maximum total_sold_quantity? The final
#output contains these fields sorted by the total_sold_quantity,
#Quarter
#total_sold_quantity
WITH CTE1 AS
(
SELECT *,
	CASE
		WHEN MONTH(date) IN (9, 10, 11) THEN "QTR1"
        WHEN MONTH(date) IN (12, 1, 2) THEN "QTR2"
        WHEN MONTH(date) IN (3, 4, 5) THEN "QTR3"
        WHEN MONTH(date) IN (6, 7, 8) THEN "QTR4"
	END as Quater
        FROM fact_sales_monthly
        WHERE fiscal_year=2020
)
SELECT Quater, SUM(sold_quantity) as total_sold_quantity
	FROM CTE1
    GROUP BY Quater;

#9th
#Which channel helped to bring more gross sales in the fiscal year 2021
#and the percentage of contribution? The final output contains these fields,
#channel
#gross_sales_mln
#percentage
WITH CTE1 AS
(
	SELECT dc.customer_code, dc.channel, gp.product_code, id.pre_invoice_discount_pct, gp.gross_price, sm.sold_quantity,
	((1-id.pre_invoice_discount_pct)*gp.gross_price*sm.sold_quantity)/1000000 as gross_sales_mln
	FROM dim_customer AS dc
    JOIN fact_gross_price AS gp
    JOIN fact_sales_monthly AS sm
    JOIN fact_pre_invoice_deductions AS id
    ON dc.customer_code=sm.customer_code AND
	   dc.customer_code=sm.customer_code AND
       sm.customer_code=id.customer_code
       LIMIT 1000000
)
SELECT channel, SUM(gross_sales_mln) as gross_sales_mln
	FROM CTE1
    GROUP BY channel;

#10th
#Get the Top 3 products in each division that have a high
#total_sold_quantity in the fiscal_year 2021? The final output contains these
#fields,
#division
#product_code
#product
#total_sold_quantity
#rank_order

WITH CTE AS 
(	
	SELECT dp.division, dp.product_code, dp.product, SUM(sm.sold_quantity) AS total_sold_quantity, sm.fiscal_year
    FROM dim_product dp
    JOIN fact_sales_monthly sm
    ON dp.product_code = sm.product_code
    WHERE sm.fiscal_year = 2021
    GROUP BY dp.division, dp.product_code, dp.product
    ORDER BY total_sold_quantity DESC
)
SELECT * FROM 
(SELECT division, product_code, product, total_sold_quantity,
rank() OVER(PARTITION BY division ORDER BY total_sold_quantity DESC) AS rank_order  
FROM CTE) x
WHERE rank_order < 5;