WITH cleaned_base AS (
    SELECT 
        NULLIF(TRIM(customer_id::TEXT), '')        AS customer_id,
        NULLIF(TRIM(customer_name), '')           AS customer_name,
        NULLIF(TRIM(customer_type), '')           AS customer_type,
        NULLIF(TRIM(channel), '')                 AS channel,
        NULLIF(TRIM(province), '')                AS province,
        NULLIF(TRIM(region), '')                  AS region,
        NULLIF(TRIM(address), '')                 AS address,
        NULLIF(TRIM(phone::TEXT), '')             AS phone,
        NULLIF(TRIM(tax_code::TEXT), '')          AS tax_code,
        NULLIF(TRIM(join_date), '')               AS join_date,
        NULLIF(TRIM(credit_limit::TEXT), '')      AS credit_limit,
        NULLIF(TRIM(status), '')                  AS status,
        NULLIF(TRIM(ingestion_at::TEXT), '')      AS ingestion_at,
        NULLIF(TRIM(_source_file), '')            AS _source_file,
        NULLIF(TRIM(_source_platform), '')        AS _source_platform,
        NULLIF(TRIM(_batch_id::TEXT), '')         AS _batch_id
    FROM bronze."SCR03_Customer_Master"
)
SELECT 
    COUNT(*) AS total_rows,
    ROUND(100.0 * (COUNT(*) - COUNT(customer_id)) / NULLIF(COUNT(*), 0), 2)       AS pct_missing_customer_id,
    ROUND(100.0 * (COUNT(*) - COUNT(customer_name)) / NULLIF(COUNT(*), 0), 2)    AS pct_missing_customer_name,
    ROUND(100.0 * (COUNT(*) - COUNT(customer_type)) / NULLIF(COUNT(*), 0), 2)    AS pct_missing_customer_type,
    ROUND(100.0 * (COUNT(*) - COUNT(channel)) / NULLIF(COUNT(*), 0), 2)          AS pct_missing_channel,
    ROUND(100.0 * (COUNT(*) - COUNT(province)) / NULLIF(COUNT(*), 0), 2)         AS pct_missing_province,
    ROUND(100.0 * (COUNT(*) - COUNT(region)) / NULLIF(COUNT(*), 0), 2)           AS pct_missing_region,
    ROUND(100.0 * (COUNT(*) - COUNT(address)) / NULLIF(COUNT(*), 0), 2)          AS pct_missing_address,
    ROUND(100.0 * (COUNT(*) - COUNT(phone)) / NULLIF(COUNT(*), 0), 2)            AS pct_missing_phone,
    ROUND(100.0 * (COUNT(*) - COUNT(tax_code)) / NULLIF(COUNT(*), 0), 2)         AS pct_missing_tax_code,
    ROUND(100.0 * (COUNT(*) - COUNT(join_date)) / NULLIF(COUNT(*), 0), 2)        AS pct_missing_join_date,
    ROUND(100.0 * (COUNT(*) - COUNT(credit_limit)) / NULLIF(COUNT(*), 0), 2)     AS pct_missing_credit_limit,
    ROUND(100.0 * (COUNT(*) - COUNT(status)) / NULLIF(COUNT(*), 0), 2)           AS pct_missing_status,
    ROUND(100.0 * (COUNT(*) - COUNT(ingestion_at)) / NULLIF(COUNT(*), 0), 2)     AS pct_missing_ingestion_at,
    ROUND(100.0 * (COUNT(*) - COUNT(_source_file)) / NULLIF(COUNT(*), 0), 2)     AS pct_missing__source_file,
    ROUND(100.0 * (COUNT(*) - COUNT(_source_platform)) / NULLIF(COUNT(*), 0), 2) AS pct_missing__source_platform,
    ROUND(100.0 * (COUNT(*) - COUNT(_batch_id)) / NULLIF(COUNT(*), 0), 2)        AS pct_missing__batch_id
FROM cleaned_base;


--missing 51.75% năm ở tax code cái này k tự tiện thêm được và có thể nguyên nhân là các missing do k có mst


  select
    	Trim(customer_id) as customer_id,
        TRIM(customer_name)   AS customer_name,
       	TRIM(customer_type) as customer_type,
       	COUNT(*)            AS row_count
    FROM bronze."SCR03_Customer_Master"
    GROUP by
    	customer_id,
        customer_name,
       	customer_type      
    HAVING COUNT(*) > 1;
--  k có dup