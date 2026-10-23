SELECT 
    COUNT(*) AS total_rows,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(promotion_id), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_promotion_id,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(promotion_name), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_promotion_name,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(promotion_type), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_promotion_type,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(target_channel), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_target_channel,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(target_region), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_target_region,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(start_date), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_start_date,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(end_date), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_end_date,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(applicable_products), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_applicable_products,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(discount_pct::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_discount_pct,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(min_order_quantity::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_min_order_quantity,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(budget_vnd::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_budget_vnd,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(actual_cost_vnd::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_actual_cost_vnd,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(status), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_status,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(created_by), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_created_by,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(ingestion_at::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_ingestion_at,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(_source_file), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing__source_file,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(_source_platform), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing__source_platform,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(_batch_id::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing__batch_id
FROM bronze."SCR10_Promotion_Program";


SELECT 
    TRIM(promotion_id) AS promotion_id,
    COUNT(*) AS row_count
FROM bronze."SCR10_Promotion_Program"
GROUP BY TRIM(promotion_id)
HAVING COUNT(*) > 1;