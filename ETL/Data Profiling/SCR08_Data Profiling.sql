SELECT 
    COUNT(*) AS total_rows,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(territory_id), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_territory_id,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(employee_id), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_employee_id,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(customer_id), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_customer_id,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(effective_date), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_effective_date,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(expiry_date), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_expiry_date,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(version), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_version,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(ingestion_at::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_ingestion_at,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(_source_file), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing__source_file,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(_source_platform), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing__source_platform,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(_batch_id::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing__batch_id
FROM bronze."SCR08_Territory_Mapping";

SELECT 
    TRIM(territory_id) AS territory_id,
    TRIM(version) AS version,
    COUNT(*) AS row_count
FROM bronze."SCR08_Territory_Mapping"
GROUP BY TRIM(territory_id), TRIM(version)
HAVING COUNT(*) > 1;