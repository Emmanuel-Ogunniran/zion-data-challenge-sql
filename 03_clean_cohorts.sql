USE zion_challenge;

DROP TABLE IF EXISTS occupation_map;
CREATE TABLE occupation_map (
    occupation_key   VARCHAR(100) NOT NULL PRIMARY KEY,
    occupation_group VARCHAR(60)  NOT NULL
) DEFAULT CHARACTER SET utf8mb4;

INSERT INTO occupation_map (occupation_key, occupation_group) VALUES
    ('student', 'Student'),
    ('graduate', 'Student'),
    ('graduated', 'Student'),
    ('post graduate', 'Student'),
    ('intern', 'Student'),
    ('medical student', 'Student'),
    ('student/photographer', 'Student'),
    ('unemployed', 'Unemployed'),
    ('unemployment', 'Unemployed'),
    ('not employed', 'Unemployed'),
    ('data analyst', 'Data & Analytics'),
    ('bi analysis', 'Data & Analytics'),
    ('media data analyst', 'Data & Analytics'),
    ('statistician', 'Data & Analytics'),
    ('data officer', 'Data & Analytics'),
    ('data administrator', 'Data & Analytics'),
    ('quality analyst', 'Data & Analytics'),
    ('it', 'IT & Software'),
    ('it support', 'IT & Software'),
    ('it service desk support', 'IT & Software'),
    ('it specialist', 'IT & Software'),
    ('software developer', 'IT & Software'),
    ('software dev', 'IT & Software'),
    ('cybersecurity experts', 'IT & Software'),
    ('digital factory specialist', 'IT & Software'),
    ('banker', 'Finance & Accounting'),
    ('banking', 'Finance & Accounting'),
    ('auditor', 'Finance & Accounting'),
    ('accountant', 'Finance & Accounting'),
    ('accounting', 'Finance & Accounting'),
    ('financial analyst', 'Finance & Accounting'),
    ('finance analyst', 'Finance & Accounting'),
    ('underwriter', 'Finance & Accounting'),
    ('microfinance branch manager', 'Finance & Accounting'),
    ('cost controller', 'Finance & Accounting'),
    ('relationship manager', 'Finance & Accounting'),
    ('risk and compliance', 'Finance & Accounting'),
    ('economist', 'Finance & Accounting'),
    ('pharmacist', 'Healthcare'),
    ('healthcare professional', 'Healthcare'),
    ('nurse', 'Healthcare'),
    ('nursing', 'Healthcare'),
    ('doctor', 'Healthcare'),
    ('dentist', 'Healthcare'),
    ('carer', 'Healthcare'),
    ('medical laboratory scientist (corp member)', 'Healthcare'),
    ('teacher', 'Education'),
    ('lecturer', 'Education'),
    ('lecturing', 'Education'),
    ('educator', 'Education'),
    ('engineer', 'Engineering & Technical'),
    ('mechatronics engineering', 'Engineering & Technical'),
    ('engineering manager', 'Engineering & Technical'),
    ('mechanical engineer', 'Engineering & Technical'),
    ('mechanic', 'Engineering & Technical'),
    ('quantity surveyor', 'Engineering & Technical'),
    ('builder', 'Engineering & Technical'),
    ('quality officer', 'Engineering & Technical'),
    ('maritime officer', 'Engineering & Technical'),
    ('entrepreneur', 'Business Owner / Self-Employed'),
    ('enterpreneur', 'Business Owner / Self-Employed'),
    ('entrepreneur / crypto trader', 'Business Owner / Self-Employed'),
    ('business man', 'Business Owner / Self-Employed'),
    ('businessman', 'Business Owner / Self-Employed'),
    ('self employed', 'Business Owner / Self-Employed'),
    ('freelancer', 'Business Owner / Self-Employed'),
    ('freelance writer', 'Business Owner / Self-Employed'),
    ('a business owner and a corp member', 'Business Owner / Self-Employed'),
    ('trader', 'Business Owner / Self-Employed'),
    ('gadget dealer', 'Business Owner / Self-Employed'),
    ('customer service', 'Sales, Marketing & Customer Service'),
    ('customer support specialist', 'Sales, Marketing & Customer Service'),
    ('sale''s representative', 'Sales, Marketing & Customer Service'),
    ('sales executive', 'Sales, Marketing & Customer Service'),
    ('sales/ customer experience', 'Sales, Marketing & Customer Service'),
    ('marketing', 'Sales, Marketing & Customer Service'),
    ('travel agent', 'Sales, Marketing & Customer Service'),
    ('real estate', 'Sales, Marketing & Customer Service'),
    ('real estate agent', 'Sales, Marketing & Customer Service'),
    ('technical pre-sales consultant', 'Sales, Marketing & Customer Service'),
    ('administrative co-ordinator', 'Administration & Management'),
    ('administrative professionals', 'Administration & Management'),
    ('administrative assistant', 'Administration & Management'),
    ('regional administrate', 'Administration & Management'),
    ('manager', 'Administration & Management'),
    ('project manager', 'Administration & Management'),
    ('procurement manager', 'Administration & Management'),
    ('hr officer', 'Administration & Management'),
    ('security manager', 'Administration & Management'),
    ('product development', 'Administration & Management'),
    ('resource mobilisation officer', 'Administration & Management'),
    ('fleet and logistics supervisor', 'Administration & Management'),
    ('civil servant', 'Public Service, Legal & Security'),
    ('civil service', 'Public Service, Legal & Security'),
    ('lawyer', 'Public Service, Legal & Security'),
    ('advocate', 'Public Service, Legal & Security'),
    ('military', 'Public Service, Legal & Security'),
    ('baker', 'Other / Not Stated'),
    ('fashion designer', 'Other / Not Stated'),
    ('sommelier', 'Other / Not Stated'),
    ('event planner', 'Other / Not Stated'),
    ('porter', 'Other / Not Stated'),
    ('delivery', 'Other / Not Stated'),
    ('general worker', 'Other / Not Stated'),
    ('no', 'Other / Not Stated'),
    ('nil', 'Other / Not Stated'),
    ('kenya', 'Other / Not Stated'),
    ('nairobi', 'Other / Not Stated');

DROP TABLE IF EXISTS clean_cohort_9;
CREATE TABLE clean_cohort_9 AS
SELECT
    s.cohort,
    CASE WHEN s.reg_ts_raw LIKE '%.%'
         THEN STR_TO_DATE(TRIM(s.reg_ts_raw), '%Y-%m-%d %H:%i:%s.%f')
         ELSE STR_TO_DATE(TRIM(s.reg_ts_raw), '%Y-%m-%d %H:%i:%s')
    END                                       AS reg_ts,
    TRIM(s.gender_raw)                                         AS gender,
    CASE LOWER(TRIM(s.program_raw))
        WHEN 'data science and ai' THEN 'Data Science and AI'
        WHEN 'data science and ml' THEN 'Data Science and ML'
        ELSE TRIM(s.program_raw)
    END                                                        AS program,
    CASE
        WHEN m.resolve_by = 'text'      THEN m.country_name
        WHEN m.resolve_by = 'dial_code' THEN COALESCE(d.country_name, 'Unknown')
        ELSE 'Unknown'
    END                                                        AS country,
    CASE LOWER(TRIM(s.source_raw))
        WHEN 'x (twitter)'         THEN 'X (Twitter)'
        WHEN 'linkedin'            THEN 'LinkedIn'
        WHEN 'whatsapp'            THEN 'WhatsApp'
        WHEN 'whatsapp community'  THEN 'WhatsApp Community'
        ELSE TRIM(s.source_raw)
    END                                                        AS source,
    CAST(NULL AS CHAR(60))                                     AS occupation_group
FROM stg_cohort_9 AS s
LEFT JOIN country_map   AS m ON m.raw_key = TRIM(s.country_raw)
LEFT JOIN dial_code_map AS d ON m.resolve_by = 'dial_code'
                            AND s.dial_hint LIKE CONCAT(d.dial_prefix, '%');

DROP TABLE IF EXISTS clean_cohort_10;
CREATE TABLE clean_cohort_10 AS
SELECT
    s.cohort,
    CASE WHEN s.reg_ts_raw LIKE '%.%'
         THEN STR_TO_DATE(TRIM(s.reg_ts_raw), '%Y-%m-%d %H:%i:%s.%f')
         ELSE STR_TO_DATE(TRIM(s.reg_ts_raw), '%Y-%m-%d %H:%i:%s')
    END                                       AS reg_ts,
    TRIM(s.gender_raw)                                         AS gender,
    CASE LOWER(TRIM(s.program_raw))
        WHEN 'data science and ai' THEN 'Data Science and AI'
        WHEN 'data science and ml' THEN 'Data Science and ML'
        ELSE TRIM(s.program_raw)
    END                                                        AS program,
    CASE
        WHEN m.resolve_by = 'text'      THEN m.country_name
        WHEN m.resolve_by = 'dial_code' THEN COALESCE(d.country_name, 'Unknown')
        ELSE 'Unknown'
    END                                                        AS country,
    CASE LOWER(TRIM(s.source_raw))
        WHEN 'x (twitter)'         THEN 'X (Twitter)'
        WHEN 'linkedin'            THEN 'LinkedIn'
        WHEN 'whatsapp'            THEN 'WhatsApp'
        WHEN 'whatsapp community'  THEN 'WhatsApp Community'
        ELSE TRIM(s.source_raw)
    END                                                        AS source,
    COALESCE(o.occupation_group, 'Other / Not Stated')         AS occupation_group
FROM stg_cohort_10 AS s
LEFT JOIN country_map    AS m ON m.raw_key = TRIM(s.country_raw)
LEFT JOIN dial_code_map  AS d ON m.resolve_by = 'dial_code'
                             AND s.dial_hint LIKE CONCAT(d.dial_prefix, '%')
LEFT JOIN occupation_map AS o ON o.occupation_key = TRIM(s.occupation_raw);

SELECT 'clean_cohort_9' AS table_name, COUNT(*) AS row_count FROM clean_cohort_9
UNION ALL
SELECT 'clean_cohort_10', COUNT(*) FROM clean_cohort_10;

SELECT 9 AS cohort, COUNT(*) AS unparsed FROM clean_cohort_9  WHERE reg_ts IS NULL
UNION ALL
SELECT 10,          COUNT(*)           FROM clean_cohort_10 WHERE reg_ts IS NULL;

SELECT cohort, country, COUNT(*) AS n FROM clean_cohort_9  WHERE country = 'Unknown' GROUP BY cohort, country
UNION ALL
SELECT cohort, country, COUNT(*)       FROM clean_cohort_10 WHERE country = 'Unknown' GROUP BY cohort, country;
