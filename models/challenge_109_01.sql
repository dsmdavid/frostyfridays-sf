{{
  config(
    materialized = 'view'
 )
}}
-- noqa: disable=AL03,LT05,LT09
WITH
    raw_data AS (
        SELECT
            $1::int AS emp_id, $2::varchar AS emp_name, $3::varchar AS department, $4::float AS performance_score, $5::date AS review_date FROM VALUES
        (101, 'Alice Smith', 'Sales', 85.50, '2024-08-30'),
        (102, 'Bob Johnson', 'HR', 92.75, '2024-08-29'),
        (103, 'Charlie Davis', 'Sales', 88.00, '2024-08-28'),
        (104, 'Dana Lee', 'Engineering', 95.20, '2024-08-27'),
        (105, 'Eli White', 'HR', 78.90, '2024-08-26')
    )

SELECT * FROM raw_data
