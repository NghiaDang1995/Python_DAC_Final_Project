WITH cleaned_base AS (
    SELECT 
        -- Làm sạch khoảng trắng và chuyển chuỗi rỗng thành NULL để đếm chính xác
        NULLIF(TRIM(order_id), '') AS order_id,
        NULLIF(TRIM(customer_id), '') AS customer_id,
        NULLIF(TRIM(employee_id), '') AS employee_id,
        NULLIF(TRIM(product_id), '') AS product_id,
        NULLIF(TRIM(quantity::TEXT), '')::NUMERIC AS quantity,
        NULLIF(TRIM(unit_price::TEXT), '')::NUMERIC AS unit_price,
        NULLIF(TRIM(net_amount::TEXT), '')::NUMERIC AS net_amount,
        NULLIF(TRIM(delivery_status), '') AS delivery_status
    FROM bronze."SRC01_Sales_Transactions"
)
-- Thống kê số lượng dòng thiếu (missing/null) cho từng cột
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(order_id) AS missing_order_id,
    COUNT(*) - COUNT(customer_id) AS missing_customer_id,
    COUNT(*) - COUNT(employee_id) AS missing_employee_id,
    COUNT(*) - COUNT(product_id) AS missing_product_id,
    COUNT(*) - COUNT(quantity) AS missing_quantity,
    COUNT(*) - COUNT(unit_price) AS missing_unit_price,
    COUNT(*) - COUNT(net_amount) AS missing_net_amount,
    COUNT(*) - COUNT(delivery_status) AS missing_delivery_status
FROM cleaned_base;

--check dup vì 1 order id có thể mua nhiều hàng nên check bổ sung product id nếu trung product_id thì bị trùng
SELECT 
    order_id, 
    product_id, 
    COUNT(*) AS duplicate_count
FROM bronze."SRC01_Sales_Transactions"
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;




