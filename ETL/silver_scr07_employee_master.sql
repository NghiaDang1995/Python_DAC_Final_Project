CREATE TABLE silver.SCR07_Employee_Master AS 
WITH CTE AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(employee_id) 
            ORDER BY ingestion_at DESC
        ) AS row_num
    FROM bronze."SCR07_Employee_Master"
)
SELECT 
    NULLIF(TRIM(employee_id), '')                          AS employee_id,
    NULLIF(TRIM(full_name), '')                            AS full_name,
    NULLIF(TRIM(gender), '')                               AS gender,
    NULLIF(TRIM(date_of_birth), '')::DATE                  AS date_of_birth,
    NULLIF(TRIM(join_date), '')::DATE                      AS join_date,
    NULLIF(TRIM(position), '')                             AS position,
    NULLIF(TRIM(region), '')                               AS region,
    NULLIF(TRIM(team), '')                                 AS team,
    NULLIF(TRIM(email), '')                                AS email,
    NULLIF(TRIM(phone::TEXT), '')                          AS phone,
    NULLIF(TRIM(status), '')                               AS status,
    NULLIF(TRIM(version), '')                              AS version,
    NULLIF(TRIM(effective_date), '')::DATE                 AS effective_date,
    resign_date,
    transfer_note,
    ingestion_at,
    NULLIF(TRIM(_source_file), '')                         AS _source_file,
    NULLIF(TRIM(_source_platform), '')                     AS _source_platform,
    _batch_id,
    row_num
FROM CTE 
WHERE row_num = 1;