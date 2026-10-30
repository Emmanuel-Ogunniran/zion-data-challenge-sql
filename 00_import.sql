CREATE DATABASE IF NOT EXISTS zion_challenge
    DEFAULT CHARACTER SET utf8mb4;
USE zion_challenge;

DROP TABLE IF EXISTS cohort_9;
CREATE TABLE cohort_9 (
    reg_timestamp TEXT,    
    name          TEXT,   
    email         TEXT, 
    phone         TEXT, 
    country       TEXT, 
    gender        TEXT, 
    program       TEXT, 
    heard_from    TEXT, 
    amount_paid   TEXT  
) DEFAULT CHARACTER SET utf8mb4;

DROP TABLE IF EXISTS cohort_10;
CREATE TABLE cohort_10 (
    reg_timestamp TEXT,   
    name          TEXT,   
    gender        TEXT,   
    email         TEXT,   
    phone         TEXT,   
    country       TEXT,   
    program       TEXT,   
    occupation    TEXT,   
    heard_from    TEXT    
) DEFAULT CHARACTER SET utf8mb4;

LOAD DATA LOCAL INFILE 'C:/path/to/cohort_9.csv'
INTO TABLE cohort_9
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/path/to/cohort_10.csv'
INTO TABLE cohort_10
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT 'cohort_9'  AS table_name, COUNT(*) AS row_count FROM cohort_9
UNION ALL
SELECT 'cohort_10', COUNT(*) FROM cohort_10;
