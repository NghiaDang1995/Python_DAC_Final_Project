
create table silver.SCR02_sales_target_plan as
WITH Dup_remove_cte AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY employee_id, employee_name, "year", "month", plan_version 
            ORDER BY ingestion_at DESC
        ) AS row_number
    FROM bronze."SCR02_sales_target_plan" --- đánh số các dòng ingestion at bị nhập nhiều lần theo thời gian theo 3 cột id, year, month 
),
cleaned_data_ver AS (
    SELECT
        TRIM(plan_version) AS plan_version,
        TRIM(version_date)::date AS version_date,
        TRIM(effective_from)::date AS effective_from,
        TRIM(effective_to)::date AS effective_to,
        TRIM(employee_id) AS employee_id,
        TRIM(employee_name) AS employee_name,
        TRIM(region) AS region,
        TRIM(team) AS team,
        "year",
        "month",
        target_revenue,
        target_quantity,
        target_new_customers,
        ingestion_at,
        _source_file,
        _source_platform,
        _batch_id,
        version_label,
        row_number
    FROM Dup_remove_cte
    WHERE row_number = 1
),
pl_v1 AS (
    SELECT *
    FROM cleaned_data_ver
    WHERE plan_version = 'v1'
),
pl_v2 AS (
    SELECT *
    FROM cleaned_data_ver
    WHERE plan_version = 'v2'
)
SELECT 
    COALESCE(pl_v2.plan_version, pl_v1.plan_version) as plan_version,   
    COALESCE(pl_v2.employee_id, pl_v1.employee_id) AS employee_id,
    COALESCE(pl_v2.employee_name, pl_v1.employee_name) AS employee_name,
    COALESCE(pl_v2.region, pl_v1.region) AS region,
    COALESCE(pl_v2.team, pl_v1.team) AS team,
    COALESCE(pl_v2.year, pl_v1.year) AS year,
    COALESCE(pl_v2.month, pl_v1.month) AS month,   
    COALESCE(pl_v2.target_revenue, pl_v1.target_revenue) AS target_revenue,
    COALESCE(pl_v2.target_quantity, pl_v1.target_quantity) AS target_quantity,
    COALESCE(pl_v2.target_new_customers, pl_v1.target_new_customers) AS target_new_customers
FROM pl_v1
LEFT JOIN pl_v2 
    ON pl_v1.employee_id = pl_v2.employee_id 
    AND pl_v1."year" = pl_v2."year" 
    AND pl_v1."month" = pl_v2."month";
	
	
