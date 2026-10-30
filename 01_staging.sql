USE zion_challenge;

DROP TABLE IF EXISTS stg_cohort_9;
CREATE TABLE stg_cohort_9 AS
SELECT
    9                                                   AS cohort,
    reg_timestamp                                       AS reg_ts_raw,
    gender                                              AS gender_raw,
    program                                             AS program_raw,
    country                                             AS country_raw,
    heard_from                                          AS source_raw,
    CAST(NULL AS CHAR(100))                             AS occupation_raw,
    LEFT(REGEXP_REPLACE(IFNULL(phone, ''), '[^0-9]', ''), 4) AS dial_hint
FROM cohort_9;

DROP TABLE IF EXISTS stg_cohort_10;
CREATE TABLE stg_cohort_10 AS
SELECT
    10                                                  AS cohort,
    reg_timestamp                                       AS reg_ts_raw,
    gender                                              AS gender_raw,
    program                                             AS program_raw,
    country                                             AS country_raw,
    heard_from                                          AS source_raw,
    occupation                                          AS occupation_raw,
    LEFT(REGEXP_REPLACE(IFNULL(phone, ''), '[^0-9]', ''), 4) AS dial_hint
FROM cohort_10;

SELECT 'stg_cohort_9'  AS table_name, COUNT(*) AS row_count FROM stg_cohort_9
UNION ALL
SELECT 'stg_cohort_10', COUNT(*) FROM stg_cohort_10;
