
CREATE TABLE gold.fact_sales_target_plan AS
WITH v1_plan AS (
    SELECT 
        employee_id,
        employee_name,
        region,
        team,
        year,
        month,
        target_revenue,
        target_quantity,
        target_new_customers,
        plan_version,
        version_date,
        effective_from,
        effective_to
    FROM silver.scr02_sales_target_plan
    WHERE plan_version = 'v1'
),
v2_plan AS (
    SELECT 
        employee_id,
        employee_name,
        region,
        team,
        year,
        month,
        target_revenue,
        target_quantity,
        target_new_customers,
        plan_version,
        version_date,
        effective_from,
        effective_to
    FROM silver.scr02_sales_target_plan
    WHERE plan_version = 'v2'
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY COALESCE(v2.employee_id, v1.employee_id), COALESCE(v2.year, v1.year), COALESCE(v2.month, v1.month)) AS target_key, 
    -- Nếu v2 có tồn tại (tức là có bản ghi điều chỉnh cho tháng đó) thì ưu tiên dùng v2, ngược lại fallback về v1
    COALESCE(v2.plan_version, v1.plan_version)                   AS plan_version,
    COALESCE(v2.version_date, v1.version_date)                   AS version_date,
    COALESCE(v2.effective_from, v1.effective_from)               AS effective_from,
    COALESCE(v2.effective_to, v1.effective_to)                   AS effective_to,
    COALESCE(v2.employee_id, v1.employee_id)                     AS employee_id,
    COALESCE(v2.employee_name, v1.employee_name)                 AS employee_name,
    COALESCE(v2.region, v1.region)                               AS region,
    COALESCE(v2.team, v1.team)                                   AS team,
    COALESCE(v2.year, v1.year)                                   AS year,
    COALESCE(v2.month, v1.month)                                 AS month,
    -- Lấy target của v2 nếu có thay đổi, nếu không có v2 thì giữ nguyên v1
    COALESCE(v2.target_revenue, v1.target_revenue)               AS target_revenue,
    COALESCE(v2.target_quantity, v1.target_quantity)             AS target_quantity,
    COALESCE(v2.target_new_customers, v1.target_new_customers)   AS target_new_customers
FROM v1_plan v1
FULL OUTER JOIN v2_plan v2 
  ON v1.employee_id = v2.employee_id 
 AND v1.year = v2.year 
 AND v1.month = v2.month;



		
