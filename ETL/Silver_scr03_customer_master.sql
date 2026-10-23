CREATE TABLE silver.SCR03_Customer_Master AS 
WITH CTE AS (
    SELECT 
        *,
        -- Khử trùng lặp theo customer_id, lấy bản ghi nạp mới nhất
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(customer_id) 
            ORDER BY ingestion_at DESC
        ) AS row_num
    FROM bronze."SCR03_Customer_Master"
)
SELECT 
    NULLIF(TRIM(index::TEXT), '')::BIGINT                  AS index,
    NULLIF(TRIM(customer_id), '')                          AS customer_id,
    NULLIF(TRIM(customer_name), '')                        AS customer_name,
    NULLIF(TRIM(customer_type), '')                        AS customer_type,
    NULLIF(TRIM(channel), '')                              AS channel,
    NULLIF(TRIM(province), '')                             AS province,
    NULLIF(TRIM(region), '')                               AS region,
    NULLIF(TRIM(address), '')                              AS address,
    CASE 
        WHEN phone IS NULL OR TRIM(phone::TEXT) = '' THEN NULL
        WHEN TRIM(phone::TEXT) LIKE '0%' THEN TRIM(phone::TEXT)
        ELSE '0' || TRIM(phone::TEXT)
    END AS phone,
    NULLIF(TRIM(tax_code::TEXT), '')                       AS tax_code, 
    NULLIF(TRIM(join_date), '')::DATE                      AS join_date,
    NULLIF(TRIM(credit_limit::TEXT), '')::BIGINT           AS credit_limit,
    NULLIF(TRIM(status), '')                               AS status,
    ingestion_at,
    NULLIF(TRIM(_source_file), '')                         AS _source_file,
    NULLIF(TRIM(_source_platform), '')                     AS _source_platform,
    NULLIF(TRIM(_batch_id::TEXT), '')                      AS _batch_id,
    row_num
FROM CTE 
WHERE row_num = 1;