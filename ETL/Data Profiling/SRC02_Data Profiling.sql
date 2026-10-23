WITH cleaned_base AS (
    SELECT 
        NULLIF(TRIM(plan_version), '')           AS plan_version,
        NULLIF(TRIM(version_date), '')           AS version_date,
        NULLIF(TRIM(effective_from), '')         AS effective_from,
        NULLIF(TRIM(effective_to), '')           AS effective_to,
        NULLIF(TRIM(employee_id), '')            AS employee_id,
        NULLIF(TRIM(employee_name), '')          AS employee_name,
        NULLIF(TRIM(region), '')                 AS region,
        NULLIF(TRIM(team), '')                   AS team,
        NULLIF(TRIM(year::TEXT), '')             AS year,
        NULLIF(TRIM(month::TEXT), '')            AS month,
        NULLIF(TRIM(target_revenue::TEXT), '')   AS target_revenue,
        NULLIF(TRIM(target_quantity::TEXT), '')  AS target_quantity,
        NULLIF(TRIM(target_new_customers::TEXT), '') AS target_new_customers,
        NULLIF(TRIM(ingestion_at::TEXT), '')     AS ingestion_at,
        NULLIF(TRIM(_source_file), '')           AS _source_file,
        NULLIF(TRIM(_source_platform), '')       AS _source_platform,
        NULLIF(TRIM(_batch_id), '')              AS _batch_id,
        NULLIF(TRIM(version_label), '')          AS version_label
    FROM bronze."SCR02_sales_target_plan"
)
    SELECT 
        COUNT(*) AS total_rows,
        ROUND(100.0 * (COUNT(*) - COUNT(plan_version)) / NULLIF(COUNT(*), 0), 2)         AS pct_missing_plan_version,
        ROUND(100.0 * (COUNT(*) - COUNT(version_date)) / NULLIF(COUNT(*), 0), 2)         AS pct_missing_version_date,
        ROUND(100.0 * (COUNT(*) - COUNT(effective_from)) / NULLIF(COUNT(*), 0), 2)       AS pct_missing_effective_from,
        ROUND(100.0 * (COUNT(*) - COUNT(effective_to)) / NULLIF(COUNT(*), 0), 2)         AS pct_missing_effective_to,
        ROUND(100.0 * (COUNT(*) - COUNT(employee_id)) / NULLIF(COUNT(*), 0), 2)          AS pct_missing_employee_id,
        ROUND(100.0 * (COUNT(*) - COUNT(employee_name)) / NULLIF(COUNT(*), 0), 2)        AS pct_missing_employee_name,
        ROUND(100.0 * (COUNT(*) - COUNT(region)) / NULLIF(COUNT(*), 0), 2)               AS pct_missing_region,
        ROUND(100.0 * (COUNT(*) - COUNT(team)) / NULLIF(COUNT(*), 0), 2)                 AS pct_missing_team,
        ROUND(100.0 * (COUNT(*) - COUNT(year)) / NULLIF(COUNT(*), 0), 2)                 AS pct_missing_year,
        ROUND(100.0 * (COUNT(*) - COUNT(month)) / NULLIF(COUNT(*), 0), 2)                AS pct_missing_month,
        ROUND(100.0 * (COUNT(*) - COUNT(target_revenue)) / NULLIF(COUNT(*), 0), 2)       AS pct_missing_target_revenue,
        ROUND(100.0 * (COUNT(*) - COUNT(target_quantity)) / NULLIF(COUNT(*), 0), 2)      AS pct_missing_target_quantity,
        ROUND(100.0 * (COUNT(*) - COUNT(target_new_customers)) / NULLIF(COUNT(*), 0), 2) AS pct_missing_target_new_customers,
        ROUND(100.0 * (COUNT(*) - COUNT(ingestion_at)) / NULLIF(COUNT(*), 0), 2)         AS pct_missing_ingestion_at,
        ROUND(100.0 * (COUNT(*) - COUNT(_source_file)) / NULLIF(COUNT(*), 0), 2)         AS pct_missing__source_file,
        ROUND(100.0 * (COUNT(*) - COUNT(_source_platform)) / NULLIF(COUNT(*), 0), 2)     AS pct_missing__source_platform,
        ROUND(100.0 * (COUNT(*) - COUNT(_batch_id)) / NULLIF(COUNT(*), 0), 2)            AS pct_missing__batch_id,
        ROUND(100.0 * (COUNT(*) - COUNT(version_label)) / NULLIF(COUNT(*), 0), 2)        AS pct_missing_version_label
    FROM cleaned_base;

-- 1. Thống kê tổng số lượng các tổ hợp bị trùng lặp và tổng số dòng bị dư thừa

    select
    	Trim(plan_version) as plan_version,
        TRIM(employee_id)   AS employee_id,
        year,
        month,
        target_revenue,
        target_quantity,
        COUNT(*)            AS row_count
    FROM bronze."SCR02_sales_target_plan"
    GROUP by
    	Trim(plan_version),
        TRIM(employee_id),
        year,
        month,
        target_revenue,
        target_quantity
    HAVING COUNT(*) > 1
--có đúp do ingestion at nhiều thời điểm sẽ distinct khi làm silver
    
