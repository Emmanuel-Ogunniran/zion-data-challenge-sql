# Zion Tech Hub Data Challenge: SQL Cleaning and Analysis

A MySQL rebuild of my analysis for the Zion Tech Hub Data Challenge (1st runner-up). The goal of the challenge was to turn registration data from two cohorts into a recommendation for how to split a first ad budget and grow the community.

This repository shows the data work end to end in SQL: cleaning two messy exports, combining them, and reproducing the headline findings from my strategy deck.

## The data

- **Cohort 9:** 1,147 registrations (6 Nov 2025 to 4 Feb 2026)
- **Cohort 10:** 171 registrations (6 May to 4 Jun 2026)
- **Total:** 1,318 registrations

The raw exports are **not included** because they contain personal data (already partly truncated by the organizers). To reproduce the results, import the two exports as tables named `cohort_9` and `cohort_10`, with every column stored as text.

## How to run

Run the files in order, in MySQL 8:

| File | What it does |
|---|---|
| `01_staging.sql` | Copies only the needed columns into staging tables with consistent names. Names, emails and phone numbers are not carried forward. |
| `02_country_lookup.sql` | Standardises the free-text country field through a mapping table. |
| `03_clean_cohorts.sql` | Builds one clean table per cohort: parsed timestamps, trimmed text, fixed label casing, grouped occupations. |
| `04_union.sql` | Combines both cohorts into a single `registrations` table and checks the row counts. |
| `05_analysis.sql` | Rebuilds the key findings from the deck. |

## Data quality issues found and how I handled them

- **Two file encodings and column layouts.** The cohorts use different column names and order, and different timestamp formats (12-hour with a 2-digit year vs 24-hour with a 4-digit year). Each is parsed with its own format, and the union lists columns explicitly.
- **Country field.** 462 rows had stray spaces, and there were typos and truncations ("Nige", "Niger", "Kebya", "Ghan"). I mapped them through a lookup table and checked ambiguous ones against the phone dial code. Five values that could not be resolved safely are labelled `Unknown`.
- **Truncated identity fields.** Emails, names and phone numbers are truncated in the source, so there is no reliable person ID. Matching on email alone would flag 251 "duplicates" in Cohort 9, most of them different people. **I therefore did not deduplicate**, and I used `UNION ALL` so no rows are dropped.
- **Labels kept separate on purpose.** "Data Science and AI" (Cohort 9) and "Data Science and ML" (Cohort 10) are different tracks. "WhatsApp" and "WhatsApp Community" are also kept separate.
- **Occupation (Cohort 10 only).** 109 free-text values are grouped into 13 categories. The grouping is a judgment call and is easy to change in `03_clean_cohorts.sql`.

## Key findings reproduced in SQL

| Finding | Result |
|---|---|
| X (Twitter) share of registrations | 62.60% in Cohort 9, rising to 86.55% in Cohort 10 |
| WhatsApp share | 18.31% in Cohort 9; WhatsApp Community 2.92% in Cohort 10 |
| Busiest two-day window | 40.9% of Cohort 9, 73.7% of Cohort 10 |
| Registrations on Thursday and Friday | 54.0% |
| Largest country | Nigeria, 58.0% of all registrations |

## Limitations

- The two cohorts had registration windows of very different length (about 90 days vs about 30 days), so raw counts are not directly comparable.
- These findings describe patterns in the data. They do not prove that a channel or day causes registrations.
- Occupation was collected for Cohort 10 only.
- Because identities are truncated, this analysis cannot track people who registered for both cohorts.

## Tools

MySQL 8 (CTEs, window functions, `STR_TO_DATE`, `CASE` logic, mapping tables).

## Author

[Your name] | [LinkedIn link] | [Email]
