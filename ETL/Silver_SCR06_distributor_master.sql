CREATE TABLE silver.SCR06_distributor_master AS 
WITH CTE AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(distributor_id) 
            ORDER BY ingestion_at DESC
        ) AS row_num
    FROM bronze."SCR06_distributor_master"
)
SELECT 
    index,
    NULLIF(TRIM(distributor_id), '')                       AS distributor_id,
    NULLIF(TRIM(distributor_name), '')                     AS distributor_name,
    NULLIF(TRIM(tier), '')                                 AS tier,
    NULLIF(TRIM(channel), '')                              AS channel,
    NULLIF(TRIM(province), '')                             AS province,
    NULLIF(TRIM(region), '')                               AS region,
    NULLIF(TRIM(contact_person), '')                       AS contact_person,
    
    CASE 
        WHEN phone IS NULL OR TRIM(phone::TEXT) = '' THEN NULL
        WHEN TRIM(phone::TEXT) LIKE '0%' THEN TRIM(phone::TEXT)
        ELSE '0' || TRIM(phone::TEXT)
    END AS phone,   
    NULLIF(TRIM(email), '')                                AS email,
    NULLIF(TRIM(tax_code::TEXT), '')                       AS tax_code,
    NULLIF(TRIM(join_date), '')::DATE                      AS join_date,
    credit_limit,
    NULLIF(TRIM(status), '')                               AS status,
    NULLIF(TRIM(assigned_supervisor_id), '')               AS assigned_supervisor_id,
    ingestion_at,
    NULLIF(TRIM(_source_file), '')                         AS _source_file,
    NULLIF(TRIM(_source_platform), '')                     AS _source_platform,
    _batch_id,
    row_num
FROM CTE 
WHERE row_num = 1;