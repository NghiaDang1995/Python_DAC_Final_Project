CREATE TABLE silver.SCR05_distributor_orders AS 
WITH CTE AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(order_id), TRIM(product_id) 
            ORDER BY ingestion_at DESC
        ) AS row_num
    FROM bronze."SCR05_distributor_orders"
)
SELECT 
    index,
    NULLIF(TRIM(order_id), '')                             AS order_id,
    NULLIF(TRIM(order_date), '')::DATE                     AS order_date,
    order_month,
    order_quarter,
    NULLIF(TRIM(distributor_id), '')                       AS distributor_id,
    NULLIF(TRIM(region), '')                               AS region,
    NULLIF(TRIM(channel), '')                              AS channel,
    NULLIF(TRIM(product_id), '')                           AS product_id,
    NULLIF(TRIM(product_category), '')                     AS product_category,
    qty_ordered,
    qty_delivered,
    fill_rate_pct,
    unit_price_list,
    distributor_price,
    gross_amount,
    delivered_amount,
    NULLIF(TRIM(expected_delivery_date), '')::DATE         AS expected_delivery_date,
    NULLIF(TRIM(actual_delivery_date), '')::DATE           AS actual_delivery_date,
    NULLIF(TRIM(ontime_delivery), '')                      AS ontime_delivery,
    NULLIF(TRIM(delivery_status), '')                      AS delivery_status,
    NULLIF(TRIM(payment_terms), '')                        AS payment_terms,
    ingestion_at,
    NULLIF(TRIM(_source_file), '')                         AS _source_file,
    NULLIF(TRIM(_source_platform), '')                     AS _source_platform,
    _batch_id,
    row_num
FROM CTE 
WHERE row_num = 1;