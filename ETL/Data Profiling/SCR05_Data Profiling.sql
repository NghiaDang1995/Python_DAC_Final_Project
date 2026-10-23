SELECT 
    COUNT(*) AS total_rows,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(order_id), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_order_id,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(order_date), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_order_date,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(order_month::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_order_month,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(order_quarter::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_order_quarter,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(distributor_id), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_distributor_id,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(region), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_region,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(channel), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_channel,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(product_id), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_product_id,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(product_category), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_product_category,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(qty_ordered::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_qty_ordered,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(qty_delivered::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_qty_delivered,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(fill_rate_pct::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_fill_rate_pct,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(unit_price_list::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_unit_price_list,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(distributor_price::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_distributor_price,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(gross_amount::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_gross_amount,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(delivered_amount::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_delivered_amount,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(expected_delivery_date), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_expected_delivery_date,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(actual_delivery_date), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_actual_delivery_date,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(ontime_delivery), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_ontime_delivery,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(delivery_status), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_delivery_status,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(payment_terms), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_payment_terms,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(ingestion_at::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing_ingestion_at,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(_source_file), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing__source_file,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(_source_platform), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing__source_platform,
    ROUND(100.0 * (COUNT(*) - COUNT(NULLIF(TRIM(_batch_id::TEXT), ''))) / NULLIF(COUNT(*), 0), 2) AS pct_missing__batch_id
FROM bronze."SCR05_distributor_orders"; -- k missing 


SELECT 
    TRIM(order_id) AS order_id,
    TRIM(product_id) AS product_id,
    COUNT(*) AS row_count
FROM bronze."SCR05_distributor_orders"
GROUP BY TRIM(order_id), TRIM(product_id)
HAVING COUNT(*) > 1; --không dup