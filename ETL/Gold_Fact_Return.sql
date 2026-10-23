create table gold.fact_return as
select 
	"index",
	return_id,
	original_order_id,
	return_date,
	return_month,
	customer_id,
	employee_id,
	product_id,
	region,
	province,
	return_quantity,
	unit_price,
	return_amount,
	return_reason,
	status
from silver.scr09_return_transactions


		
