SELECT 
    COUNT(*) AS total_rows,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(distributor_id), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_distributor_id,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(distributor_name), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_distributor_name,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(tier), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_tier,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(channel), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_channel,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(province), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_province,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(region), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_region,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(contact_person), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_contact_person,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(phone::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_phone,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(email), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_email,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(tax_code::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_tax_code,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(join_date), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_join_date,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(credit_limit::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_credit_limit,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(status), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_status,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(assigned_supervisor_id), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_assigned_supervisor_id,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(ingestion_at::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_ingestion_at,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(_source_file), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing__source_file,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(_source_platform), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing__source_platform,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(_batch_id::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing__batch_id
FROM bronze."SCR06_distributor_master";

SELECT 
    TRIM(distributor_id) AS distributor_id,
    COUNT(*) AS row_count
FROM bronze."SCR06_distributor_master"
GROUP BY TRIM(distributor_id)
HAVING COUNT(*) > 1;