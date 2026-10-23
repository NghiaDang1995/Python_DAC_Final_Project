CREATE TABLE silver.SCR08_Territory_Mapping AS 
WITH CTE AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(territory_id), TRIM(version) 
            ORDER BY ingestion_at DESC
        ) AS row_num
    FROM bronze."SCR08_Territory_Mapping"
)
SELECT 
    index,
    NULLIF(TRIM(territory_id), '')                         AS territory_id,
    NULLIF(TRIM(employee_id), '')                          AS employee_id,
    NULLIF(TRIM(customer_id), '')                          AS customer_id,
    NULLIF(TRIM(region), '')                               AS region,
    NULLIF(TRIM(team), '')                                 AS team,   
    -- effective_date chuyển sang DATE
    NULLIF(TRIM(effective_date), '')::DATE                 AS effective_date,
    -- expiry_date chuyển sang DATE
    NULLIF(TRIM(expiry_date), '')::DATE                    AS expiry_date,
    NULLIF(TRIM(version), '')                              AS version,
    ingestion_at,
    NULLIF(TRIM(_source_file), '')                         AS _source_file,
    NULLIF(TRIM(_source_platform), '')                     AS _source_platform,
    _batch_id,
    row_num
FROM CTE 
WHERE row_num = 1;