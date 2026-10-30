USE zion_challenge;

DROP TABLE IF EXISTS country_map;
CREATE TABLE country_map (
    raw_key      VARCHAR(100) NOT NULL PRIMARY KEY,
    country_name VARCHAR(60)  NULL,
    resolve_by   ENUM('text', 'dial_code', 'unknown') NOT NULL
) DEFAULT CHARACTER SET utf8mb4;

INSERT INTO country_map (raw_key, country_name, resolve_by) VALUES
    ('nigeria', 'Nigeria', 'text'),
    ('nigerian', 'Nigeria', 'text'),
    ('nigera', 'Nigeria', 'text'),
    ('nigeria l', 'Nigeria', 'text'),
    ('nigerianl', 'Nigeria', 'text'),
    ('nigeria nigeria', 'Nigeria', 'text'),
    ('nigeria ekiti state', 'Nigeria', 'text'),
    ('ng', 'Nigeria', 'text'),
    ('kenya', 'Kenya', 'text'),
    ('kebya', 'Kenya', 'text'),
    ('ghana', 'Ghana', 'text'),
    ('south africa', 'South Africa', 'text'),
    ('south african', 'South Africa', 'text'),
    ('south aftrica', 'South Africa', 'text'),
    ('rsa', 'South Africa', 'text'),
    ('uganda', 'Uganda', 'text'),
    ('uk', 'United Kingdom', 'text'),
    ('united kingdom', 'United Kingdom', 'text'),
    ('us', 'United States', 'text'),
    ('usa', 'United States', 'text'),
    ('united states', 'United States', 'text'),
    ('zimbabwe', 'Zimbabwe', 'text'),
    ('canada', 'Canada', 'text'),
    ('india', 'India', 'text'),
    ('malawi', 'Malawi', 'text'),
    ('ethiopia', 'Ethiopia', 'text'),
    ('cameroon', 'Cameroon', 'text'),
    ('zambia', 'Zambia', 'text'),
    ('tanzania', 'Tanzania', 'text'),
    ('tanzania,dar es salaam', 'Tanzania', 'text'),
    ('rwanda', 'Rwanda', 'text'),
    ('namibia', 'Namibia', 'text'),
    ('sierra leone', 'Sierra Leone', 'text'),
    ('botswana', 'Botswana', 'text'),
    ('botswana africa', 'Botswana', 'text'),
    ('jamaica', 'Jamaica', 'text'),
    ('somalia', 'Somalia', 'text'),
    ('south sudan', 'South Sudan', 'text'),
    ('mozambique', 'Mozambique', 'text'),
    ('china', 'China', 'text'),
    ('gambia', 'Gambia', 'text'),
    ('benin republic', 'Benin', 'text'),
    ('senegal', 'Senegal', 'text'),
    ('españa', 'Spain', 'text'),
    ('ivory coast', 'Ivory Coast', 'text'),
    ('cote d ivoire', 'Ivory Coast', 'text'),
    ('côte d’ivoire', 'Ivory Coast', 'text'),
    ('democratic republic of the congo', 'DR Congo', 'text'),
    ('peru', 'Peru', 'text'),
    ('saudi arabia', 'Saudi Arabia', 'text'),
    ('egypt', 'Egypt', 'text'),
    ('colombia', 'Colombia', 'text'),
    ('netherlands', 'Netherlands', 'text'),
    ('germany', 'Germany', 'text'),
    ('kuwait', 'Kuwait', 'text'),
    ('turkey', 'Turkey', 'text'),
    ('brazil', 'Brazil', 'text'),
    ('lesotho', 'Lesotho', 'text'),
    ('sweden', 'Sweden', 'text'),
    ('ireland', 'Ireland', 'text'),
    ('liberia', 'Liberia', 'text'),
    ('nige', NULL, 'dial_code'),
    ('niger', NULL, 'dial_code'),
    ('nig', NULL, 'dial_code'),
    ('sout', NULL, 'dial_code'),
    ('nam', NULL, 'dial_code'),
    ('ghan', NULL, 'dial_code'),
    ('sa', NULL, 'dial_code'),
    ('belarus (nigerian)', NULL, 'dial_code'),
    ('nigeria, russia.', NULL, 'dial_code'),
    ('+27 81 313 5587', NULL, 'dial_code'),
    ('8 056 132997', NULL, 'dial_code'),
    ('+2348133105464', NULL, 'dial_code'),
    ('e.g.', 'Unknown', 'unknown'),
    ('u', 'Unknown', 'unknown');

DROP TABLE IF EXISTS dial_code_map;
CREATE TABLE dial_code_map (
    dial_prefix  VARCHAR(4)  NOT NULL PRIMARY KEY,
    country_name VARCHAR(60) NOT NULL
) DEFAULT CHARACTER SET utf8mb4;

INSERT INTO dial_code_map (dial_prefix, country_name) VALUES
    ('234', 'Nigeria'),
    ('233', 'Ghana'),
    ('27',  'South Africa'),
    ('264', 'Namibia'),
    ('375', 'Belarus');

SELECT DISTINCT TRIM(s.country_raw) AS unmapped_value
FROM (
    SELECT country_raw FROM stg_cohort_9
    UNION ALL
    SELECT country_raw FROM stg_cohort_10
) AS s
LEFT JOIN country_map AS m ON m.raw_key = TRIM(s.country_raw)
WHERE m.raw_key IS NULL;
