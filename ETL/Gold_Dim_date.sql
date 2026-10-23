SQL
DROP TABLE IF EXISTS gold.dim_date CASCADE;

-- 1. Định nghĩa lại bảng với full_date kiểu DATE
CREATE TABLE gold.dim_date (
    date_key INT PRIMARY KEY,          -- Khóa dạng số nguyên: YYYYMMDD (VD: 20240822)
    full_date DATE NOT NULL,           -- Kiểu DATE chuẩn Data Warehouse
    day INT NOT NULL,                  -- Ngày trong tháng (1-31)
    month INT NOT NULL,                -- Tháng dương lịch (1-12)
    month_name VARCHAR(20) NOT NULL,   -- Tên tháng
    quarter INT NOT NULL,              -- Quý (1-4)
    year INT NOT NULL,                 -- Năm dương lịch
    fiscal_year INT NOT NULL,          -- Năm tài chính (FY kết thúc vào tháng 8)
    day_of_week INT NOT NULL,          -- Thứ trong tuần (1-7)
    day_name VARCHAR(20) NOT NULL,     -- Tên thứ
    is_weekend BOOLEAN NOT NULL        -- Cờ ngày cuối tuần
);

-- 2. Nạp dữ liệu tự động từ 2022 đến 2026
INSERT INTO gold.dim_date (
    date_key, 
    full_date, 
    day, 
    month, 
    month_name, 
    quarter, 
    year, 
    fiscal_year,
    day_of_week, 
    day_name, 
    is_weekend
)
SELECT 
    TO_CHAR(d, 'YYYYMMDD')::INT AS date_key,
    d::DATE AS full_date,               -- Giữ nguyên kiểu DATE
    EXTRACT(DAY FROM d)::INT AS day,
    EXTRACT(MONTH FROM d)::INT AS month,
    TO_CHAR(d, 'Month') AS month_name,
    EXTRACT(QUARTER FROM d)::INT AS quarter,
    EXTRACT(YEAR FROM d)::INT AS year,
    
    -- LOGIC NĂM TÀI CHÍNH (FY kết thúc vào tháng 8)
    -- Từ tháng 9 trở đi tính sang Fiscal Year của năm sau
    CASE 
        WHEN EXTRACT(MONTH FROM d) >= 9 THEN EXTRACT(YEAR FROM d)::INT + 1
        ELSE EXTRACT(YEAR FROM d)::INT
    END AS fiscal_year,
    
    EXTRACT(ISODOW FROM d)::INT AS day_of_week,
    TO_CHAR(d, 'Day') AS day_name,
    CASE 
        WHEN EXTRACT(ISODOW FROM d) IN (6, 7) THEN TRUE 
        ELSE FALSE 
    END AS is_weekend
FROM generate_series('2022-01-01'::date, '2026-12-31'::date, INTERVAL '1 day') AS t(d)
ON CONFLICT (date_key) DO NOTHING;
