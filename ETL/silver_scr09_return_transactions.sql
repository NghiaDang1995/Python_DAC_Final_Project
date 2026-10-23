CREATE TABLE silver.SCR09_Return_Transactions AS 
WITH CTE AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(return_id), TRIM(product_id) 
            ORDER BY ingestion_at DESC
        ) AS row_num
    FROM bronze."SCR09_Return_Transactions"
)
SELECT 
    index,
    NULLIF(TRIM(return_id), '')                            AS return_id,
    NULLIF(TRIM(original_order_id), '')                    AS original_order_id,   
    -- return_date chuyển sang DATE
    NULLIF(TRIM(return_date), '')::DATE                    AS return_date, 
    return_month,
    NULLIF(TRIM(customer_id), '')                          AS customer_id,
    NULLIF(TRIM(employee_id), '')                          AS employee_id,
    NULLIF(TRIM(product_id), '')                           AS product_id,
    NULLIF(TRIM(region), '')                               AS region,
    NULLIF(TRIM(province), '')                             AS province,
    return_quantity,
    unit_price,
    return_amount,
    NULLIF(TRIM(return_reason), '')                        AS return_reason,
    NULLIF(TRIM(status), '')                               AS status,
    ingestion_at,
    NULLIF(TRIM(_source_file), '')                         AS _source_file,
    NULLIF(TRIM(_source_platform), '')                     AS _source_platform,
    _batch_id,
    row_num
FROM CTE 
WHERE row_num = 1;