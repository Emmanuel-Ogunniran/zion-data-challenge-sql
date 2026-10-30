USE zion_challenge;

SELECT
    cohort,
    source,
    COUNT(*)                                                         AS registrations,
    ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY cohort), 2) AS pct_of_cohort
FROM registrations
GROUP BY cohort, source
ORDER BY cohort, registrations DESC;

WITH daily AS (
    SELECT cohort, reg_date, COUNT(*) AS n
    FROM registrations
    GROUP BY cohort, reg_date
),
windows AS (
    SELECT
        d.cohort,
        d.reg_date                            AS window_start,
        d.n + COALESCE(nx.n, 0)               AS window_total
    FROM daily AS d
    LEFT JOIN daily AS nx
           ON nx.cohort = d.cohort
          AND nx.reg_date = DATE_ADD(d.reg_date, INTERVAL 1 DAY)
),
ranked AS (
    SELECT
        w.*,
        ROW_NUMBER() OVER (PARTITION BY w.cohort ORDER BY w.window_total DESC, w.window_start) AS rn
    FROM windows AS w
)
SELECT
    r.cohort,
    r.window_start,
    DATE_ADD(r.window_start, INTERVAL 1 DAY)                 AS window_end,
    r.window_total                                            AS registrations_in_window,
    ROUND(100 * r.window_total / t.total, 1)                  AS pct_of_cohort
FROM ranked AS r
JOIN (SELECT cohort, COUNT(*) AS total FROM registrations GROUP BY cohort) AS t
  ON t.cohort = r.cohort
WHERE r.rn = 1
ORDER BY r.cohort;

SELECT
    day_name,
    COUNT(*)                                          AS registrations,
    ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)  AS pct_of_all
FROM registrations
GROUP BY day_name
ORDER BY registrations DESC;

SELECT ROUND(100 * AVG(day_name IN ('Thursday', 'Friday')), 1) AS pct_thu_fri_all_cohorts
FROM registrations;

SELECT
    country,
    COUNT(*)                                          AS registrations,
    ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)  AS pct_of_all
FROM registrations
GROUP BY country
ORDER BY registrations DESC
LIMIT 10;

SELECT
    cohort,
    program,
    COUNT(*)                                                         AS registrations,
    ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY cohort), 1) AS pct_of_cohort
FROM registrations
GROUP BY cohort, program
ORDER BY cohort, registrations DESC;

SELECT
    occupation_group,
    COUNT(*)                                          AS registrations,
    ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)  AS pct_of_cohort_10
FROM registrations
WHERE cohort = 10
GROUP BY occupation_group
ORDER BY registrations DESC;

SELECT COUNT(*) - COUNT(DISTINCT LOWER(TRIM(email))) AS repeated_email_rows_cohort_9
FROM zion_challenge.cohort_9;
