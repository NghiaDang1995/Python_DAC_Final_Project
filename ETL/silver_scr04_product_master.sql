CREATE TABLE silver.SCR04_product_master AS 
WITH CTE AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(product_id) 
            ORDER BY ingestion_at DESC
        ) AS row_num
    FROM bronze."SCR04_product_master"
)
SELECT 
    NULLIF(TRIM(index::TEXT), '')::BIGINT                  AS index,
    NULLIF(TRIM(product_id), '')                           AS product_id,
    NULLIF(TRIM(product_name), '')                         AS product_name,
    NULLIF(TRIM(category), '')                             AS category,
    NULLIF(TRIM(sub_category), '')                         AS sub_category,
    NULLIF(TRIM(unit), '')                                 AS unit,
    unit_price,
    cost_price,
    weight_gram,
    NULLIF(TRIM(status), '')                               AS status,
    NULLIF(TRIM(launch_date), '')::DATE                    AS launch_date,
    ingestion_at,
    NULLIF(TRIM(_source_file), '')                         AS _source_file,
    NULLIF(TRIM(_source_platform), '')                     AS _source_platform,
    NULLIF(TRIM(_batch_id::TEXT), '')                      AS _batch_id,
    row_num
FROM CTE 
WHERE row_num = 1;
