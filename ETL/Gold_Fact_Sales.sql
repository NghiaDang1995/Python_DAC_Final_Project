create table gold.fact_sales as
select 
		"index",
		order_id,
		order_date,
		order_month,
		order_quarter,
		order_year,
		customer_id,
		region,
		province,
		channel,
		employee_id,
		product_id,
		product_category,
		quantity,
		unit_price,
		discount_pct,
		discount_amount,
		gross_amount,
		net_amount,
		delivery_status,
		payment_method,
		payment_status
from silver.scr01_sales_transactions


		
