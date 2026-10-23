--bài này kế hoạch

--1. join bảng fact_sales với bảng dim_employee_master để xem rằng net sales của employee sẽ

--cho biết cái thời điểm phát sinh revenue nằm trong khoảng thời gian nào của nhân viên

-- trước khi hay sau khi chuyển

--2. vì return quy về thời gian của order id để tính (ví dụ order id tháng 6 thì dù return ở tháng 7 thì vẫn quy về tháng 6 để tính)
--nên join return theo order_date và product id(trong trường hợp return nhiều lần thì sum return theo product để product_id khớp 1 lần trong bảng fact sales)
--có actual = sales - return mình join với bảng target từng tháng 

with sales as(
select 
		gold.fact_sales.order_id,
		gold.fact_sales.order_date,
		gold.fact_sales.customer_id,
		gold.fact_sales.employee_id,
		gold.dim_employees.version,
		gold.dim_employees.region,
		gold.fact_sales.order_month,
		gold.fact_sales.order_year,
		gold.fact_sales.product_id,
		gold.fact_sales.quantity,
		gold.fact_sales.net_amount
from gold.fact_sales
left join gold.dim_employees
on	gold.fact_sales.employee_id = gold.dim_employees.employee_id
and gold.fact_sales.order_date between gold.dim_employees.effective_from and gold.dim_employees.effective_to),
--dùng row_number để đánh số thứ tự đơn hàng, đơn đầu tiên của khách là khách mới
customer_first_order as(
select 
		customer_id,
		order_id,
		row_number() over (partition by customer_id order by order_date asc) as rn
from gold.fact_sales
),
--tạo cờ đánh dấu đơn nào là khách mới
new_customer_flag as(
select 
		order_id,
		case when rn = 1 then 1 else 0 end as is_new_customer
from customer_first_order
),
--return total
return_value as(
select 
		original_order_id,
		product_id,
		sum(return_quantity) as total_return_quantity,
		sum(return_amount) as total_return_amount
from gold.fact_return
group by
		original_order_id,
		product_id
	),
--join sales với return value và cờ khách hàng mới
sales_and_return as(
select 
		sales.order_id,
		sales.employee_id,
		sales.region,
		sales.order_month,
		sales.order_year,
		sales.quantity,
		coalesce(return_value.total_return_quantity, 0) as total_return_quantity,
		sales.net_amount,
		coalesce(return_value.total_return_amount, 0) as total_return_amount,
		coalesce(new_customer_flag.is_new_customer, 0) as is_new_customer
from sales
left join return_value
on sales.order_id = return_value.original_order_id
and sales.product_id = return_value.product_id
left join new_customer_flag
on sales.order_id = new_customer_flag.order_id),
--tinh actual gồm cả quantity, amount và số lượng khách hàng mới
actual_table as(
select
		employee_id,
		region,
		order_month,
		order_year,
		sum(quantity - total_return_quantity) as actual_quantity,
		sum(net_amount - total_return_amount) as actual_amount,
		sum(is_new_customer) as actual_new_customers
from sales_and_return
group by
		employee_id,
		region,
		order_month,
		order_year)
select
	gold.fact_sales_target_plan.employee_id,
	gold.fact_sales_target_plan.plan_version,
	gold.fact_sales_target_plan.region,
	gold.fact_sales_target_plan.month,
	gold.fact_sales_target_plan.year,
	actual_table.actual_quantity,
	gold.fact_sales_target_plan.target_quantity,
	actual_table.actual_amount,
	gold.fact_sales_target_plan.target_revenue,
	actual_table.actual_new_customers,
	gold.fact_sales_target_plan.target_new_customers
from 
	gold.fact_sales_target_plan
left join actual_table 
on gold.fact_sales_target_plan.employee_id = actual_table.employee_id
and gold.fact_sales_target_plan.month = actual_table.order_month
and gold.fact_sales_target_plan.year =actual_table.order_year