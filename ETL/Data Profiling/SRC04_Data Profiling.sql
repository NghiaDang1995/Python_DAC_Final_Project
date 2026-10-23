SELECT 
    COUNT(*) AS total_rows,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(product_id::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_product_id,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(product_name), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_product_name,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(category), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_category,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(sub_category), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_sub_category,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(unit), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_unit,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(unit_price::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_unit_price,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(cost_price::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_cost_price,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(weight_gram::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_weight_gram,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(status), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_status,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(launch_date), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_launch_date,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(ingestion_at::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_ingestion_at,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(_source_file), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing__source_file,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(_source_platform), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing__source_platform,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(_batch_id::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing__batch_id
FROM bronze."SCR04_product_master"; -- ko có missing value

SELECT 
    TRIM(product_id) AS product_id,
    COUNT(*) AS row_count
FROM bronze."SCR04_product_master"
GROUP BY TRIM(product_id)
HAVING COUNT(*) > 1; -- k có dup



