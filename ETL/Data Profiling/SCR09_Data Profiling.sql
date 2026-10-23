SELECT 
    COUNT(*) AS total_rows,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(return_id), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_return_id,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(original_order_id), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_original_order_id,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(return_date), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_return_date,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(return_month::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_return_month,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(customer_id), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_customer_id,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(employee_id), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_employee_id,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(product_id), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_product_id,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(region), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_region,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(province), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_province,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(return_quantity::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_return_quantity,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(unit_price::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_unit_price,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(return_amount::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_return_amount,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(return_reason), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_return_reason,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(status), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_status,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(ingestion_at::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_ingestion_at,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(_source_file), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing__source_file,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(_source_platform), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing__source_platform,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(_batch_id::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing__batch_id
FROM bronze."SCR09_Return_Transactions";

SELECT 
    TRIM(return_id) AS return_id,
    TRIM(product_id) AS product_id,
    COUNT(*) AS row_count
FROM bronze."SCR09_Return_Transactions"
GROUP BY TRIM(return_id), TRIM(product_id)
HAVING COUNT(*) > 1;