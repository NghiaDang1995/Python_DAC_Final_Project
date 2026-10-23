CREATE TABLE silver.SCR10_Promotion_Program AS 
WITH CTE AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(promotion_id) 
            ORDER BY ingestion_at DESC
        ) AS row_num
    FROM bronze."SCR10_Promotion_Program"
)
SELECT 
    index,
    NULLIF(TRIM(promotion_id), '')                         AS promotion_id,
    NULLIF(TRIM(promotion_name), '')                       AS promotion_name,
    NULLIF(TRIM(promotion_type), '')                       AS promotion_type,
    NULLIF(TRIM(target_channel), '')                       AS target_channel,
    NULLIF(TRIM(target_region), '')                        AS target_region,   
    -- start_date chuyển sang DATE
    NULLIF(TRIM(start_date), '')::DATE                     AS start_date,
    -- end_date chuyển sang DATE
    NULLIF(TRIM(end_date), '')::DATE                       AS end_date,
    NULLIF(TRIM(applicable_products), '')                  AS applicable_products,
    discount_pct,
    min_order_quantity,
    budget_vnd,
    actual_cost_vnd,
    NULLIF(TRIM(status), '')                               AS status,
    NULLIF(TRIM(created_by), '')                           AS created_by,
    ingestion_at,
    NULLIF(TRIM(_source_file), '')                         AS _source_file,
    NULLIF(TRIM(_source_platform), '')                     AS _source_platform,
    _batch_id,
    row_num
FROM CTE 
WHERE row_num = 1;