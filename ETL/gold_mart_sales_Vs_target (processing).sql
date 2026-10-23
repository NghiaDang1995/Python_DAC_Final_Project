--bài này kế hoạch

--1. join bảng fact_sales với bảng dim_employee_master để xem rằng net sales của employee sẽ

--cho biết cái thời điểm phát sinh revenue nằm trong khoảng thời gian nào của nhân viên

-- trước khi hay sau khi chuyển

--2. tương tự với bảng return join với bảng dim_master sẽ nằm trong khoảng nào để tính chi phí

-- atual = net revenue-return (theo từng tháng )

--có actual mình join với bảng target từng tháng 
with sales as(
select 
		gold.fact_sales.order_id,
		gold.fact_sales.order_date,
		gold.fact_sales.employee_id,
		gold.dim_employees.version,
		gold.dim_employees.region,
		gold.fact_sales.order_month,
		gold.fact_sales.order_year,
		gold.fact_sales.quantity,
		gold.fact_sales.net_amount
from gold.fact_sales
left join gold.dim_employees
on	gold.fact_sales.employee_id = gold.dim_employees.employee_id
and gold.fact_sales.order_date between gold.dim_employees.effective_from and gold.dim_employees.effective_to),
--return join với dim_employees
return_value as(
select 
	gold.fact_return.return_id,
	gold.fact_return.original_order_id,
	gold.fact_return.return_date,
	gold.dim_employees.employee_id,
	gold.dim_employees.version,
	gold.dim_employees.region,
	gold.fact_return.return_month,
	gold.fact_return.return_quantity,
	gold.fact_return.return_amount
from gold.fact_return
left join gold.dim_employees
on	gold.fact_return.employee_id = gold.dim_employees.employee_id
and gold.fact_return.return_date between gold.dim_employees.effective_from and gold.dim_employees.effective_to),
--tinh total sales - total return
total_sales as(
select 
	employee_id,
	version,
	region,
	order_month,
	sum(quantity)as total_quantity,
	sum(net_amount) as total_amount
from sales
group by
	employee_id,
	version,
	region,
	order_month),
--total return
total_return as 
(select 
	employee_id,
	version,
	region,
	return_month,
	sum(return_quantity)as total_return_quantity,
	sum(return_amount) as total_return_amount
from return_value
group by
	employee_id,
	version,
	region,
	return_month)
	
actual as
(
)




		
