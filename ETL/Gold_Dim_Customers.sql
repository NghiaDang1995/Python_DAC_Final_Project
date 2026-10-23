CREATE TABLE gold.dim_employees AS
WITH ordered_employee AS (
    SELECT 
        employee_id,
        full_name,
        gender,
        date_of_birth,
        join_date,
        position,
        region,
        team,
        email,
        phone,
        status,
        version,
        effective_date AS effective_from,
        transfer_note
    FROM silver.scr07_employee_master
),
-- Bước 1: So sánh với bản ghi liền trước của chính nhân viên đó để phát hiện sự thay đổi thực sự
detect_changes AS (
    SELECT 
        *,
        LAG(region) OVER (PARTITION BY employee_id ORDER BY effective_from) AS prev_region,
        LAG(team) OVER (PARTITION BY employee_id ORDER BY effective_from) AS prev_team,
        LAG(position) OVER (PARTITION BY employee_id ORDER BY effective_from) AS prev_position
    FROM ordered_employee
),
-- Bước 2: Lọc bỏ các dòng không đổi thông tin (như emp1001), chỉ giữ lại bản ghi đầu tiên hoặc bản ghi có thay đổi thực tế
filtered_changes AS (
    SELECT 
        employee_id,
        full_name,
        gender,
        date_of_birth,
        join_date,
        position,
        region,
        team,
        email,
        phone,
        status,
        version,
        effective_from
    FROM detect_changes
    WHERE prev_region IS NULL -- Luôn giữ lại bản ghi khởi đầu (v1) của mọi nhân viên
       OR region <> prev_region 
       OR team <> prev_team 
       OR position <> prev_position
       OR transfer_note IS NOT NULL
),
-- Bước 3: Tính toán khoảng thời gian hiệu lực (effective_to) và cờ hiện tại (is_current)
calculated_scd AS (
    SELECT 
        employee_id,
        full_name,
        gender,
        date_of_birth,
        join_date,
        position,
        region,
        team,
        email,
        phone,
        status,
        version,
        effective_from,
        -- Nếu có đợt thay đổi tiếp theo thì lấy ngày đó trừ 1 ngày, còn không thì kéo dài đến '9999-12-31'
        COALESCE(
            LEAD(effective_from) OVER (PARTITION BY employee_id ORDER BY effective_from) - INTERVAL '1 day',
            '9999-12-31'::date
        ) AS effective_to
    FROM filtered_changes
)
-- Bước 4: Đổ dữ liệu vào bảng Gold kèm Surrogate Key
SELECT 
    ROW_NUMBER() OVER (ORDER BY employee_id, effective_from) AS employee_key,
    employee_id,
    full_name,
    gender,
    date_of_birth,
    join_date,
    position,
    region,
    team,
    email,
    phone,
    status,
    version,
    effective_from,
    effective_to
FROM calculated_scd;