USE zion_challenge;

DROP TABLE IF EXISTS registrations;
CREATE TABLE registrations (
    reg_id           INT AUTO_INCREMENT PRIMARY KEY,
    cohort           TINYINT      NOT NULL,
    reg_ts           DATETIME(3)  NOT NULL,
    reg_date         DATE         NOT NULL,
    day_name         VARCHAR(10)  NOT NULL,
    gender           VARCHAR(30),
    program          VARCHAR(60),
    country          VARCHAR(60),
    source           VARCHAR(40),
    occupation_group VARCHAR(60)        
) DEFAULT CHARACTER SET utf8mb4;

INSERT INTO registrations
    (cohort, reg_ts, reg_date, day_name, gender, program, country, source, occupation_group)
SELECT cohort, reg_ts, DATE(reg_ts), DAYNAME(reg_ts), gender, program, country, source, occupation_group
FROM clean_cohort_9
UNION ALL
SELECT cohort, reg_ts, DATE(reg_ts), DAYNAME(reg_ts), gender, program, country, source, occupation_group
FROM clean_cohort_10;

SELECT cohort, COUNT(*) AS row_count FROM registrations GROUP BY cohort
UNION ALL
SELECT 0, COUNT(*) FROM registrations;
