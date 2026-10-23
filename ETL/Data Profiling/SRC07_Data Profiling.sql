SELECT 
    COUNT(*) AS total_rows,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(employee_id), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_employee_id,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(full_name), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_full_name,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(gender), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_gender,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(date_of_birth), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_date_of_birth,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(join_date), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_join_date,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(position), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_position,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(region), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_region,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(team), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_team,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(email), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_email,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(phone::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_phone,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(status), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_status,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(version), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_version,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(effective_date), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_effective_date,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(resign_date::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_resign_date,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(transfer_note::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_transfer_note,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(ingestion_at::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_ingestion_at,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(_source_file), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing__source_file,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(_source_platform), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing__source_platform,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(_batch_id::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing__batch_id
FROM bronze."SCR07_Employee_Master"; -- ko null


SELECT 
    TRIM(employee_id) AS employee_id,
    COUNT(*) AS row_count
FROM bronze."SCR07_Employee_Master"
GROUP BY TRIM(employee_id)
HAVING COUNT(*) > 1; -- ko dup

