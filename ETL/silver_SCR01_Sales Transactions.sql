
CREATE TABLE silver.SCR01_sales_transactions AS 
WITH CTE AS (
    SELECT 
        *,
        -- Khử trùng lặp dựa trên tổ hợp khóa nghiệp vụ (order_id + product_id), ưu tiên bản ghi nạp mới nhất
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(order_id), TRIM(product_id) 
            ORDER BY ingestion_at DESC
        ) AS row_num
    FROM bronze."SRC01_Sales_Transactions")
SELECT 
    -- 1. index
    NULLIF(TRIM(index::TEXT), '')::BIGINT                  AS index,
    -- 2. order_id
    NULLIF(TRIM(order_id), '')                             AS order_id,
    -- 3. order_date (Chuyển từ TEXT sang TIMESTAMP)
    NULLIF(TRIM(order_date), '')::Date               AS order_date,
    -- 4. order_month
    NULLIF(TRIM(order_month::TEXT), '')::INT               AS order_month,
    -- 5. order_quarter
    NULLIF(TRIM(order_quarter::TEXT), '')::INT             AS order_quarter,
    -- 6. order_year
    NULLIF(TRIM(order_year::TEXT), '')::INT                AS order_year,
    -- 7. customer_id
    NULLIF(TRIM(customer_id), '')                          AS customer_id,
    -- 8. region
    NULLIF(TRIM(region), '')                               AS region,
    -- 9. province
    NULLIF(TRIM(province), '')                             AS province,
    -- 10. channel
    NULLIF(TRIM(channel), '')                              AS channel,
    -- 11. employee_id
    NULLIF(TRIM(employee_id), '')                          AS employee_id,
    -- 12. product_id
    NULLIF(TRIM(product_id), '')                           AS product_id,
    -- 13. product_category
    NULLIF(TRIM(product_category), '')                     AS product_category,
    -- 14. quantity
    NULLIF(TRIM(quantity::TEXT), '')::INT                  AS quantity,
    -- 15. unit_price
    NULLIF(TRIM(unit_price::TEXT), '')::BIGINT             AS unit_price,
    -- 16. discount_pct
    NULLIF(TRIM(discount_pct::TEXT), '')::INT              AS discount_pct,
    -- 17. discount_amount
    NULLIF(TRIM(discount_amount::TEXT), '')::FLOAT         AS discount_amount,
    -- 18. gross_amount
    NULLIF(TRIM(gross_amount::TEXT), '')::BIGINT           AS gross_amount,
    -- 19. net_amount
    NULLIF(TRIM(net_amount::TEXT), '')::FLOAT              AS net_amount,
    -- 20. delivery_status
    NULLIF(TRIM(delivery_status), '')                      AS delivery_status,
    -- 21. payment_method
    NULLIF(TRIM(payment_method), '')                       AS payment_method,
    -- 22. payment_status
    NULLIF(TRIM(payment_status), '')                       AS payment_status,
    -- 23. ingestion_at (Metadata)
    ingestion_at,
    -- 24. _source_file (Metadata)
    NULLIF(TRIM(_source_file), '')                         AS _source_file,
    -- 25. _source_platform (Metadata)
    NULLIF(TRIM(_source_platform), '')                     AS _source_platform,
    -- 26. _batch_id (Metadata)
    NULLIF(TRIM(_batch_id::TEXT), '')                      AS _batch_id
FROM CTE 
WHERE row_num = 1;