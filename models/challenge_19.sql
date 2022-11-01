{{
  config(
    materialized = 'view',
    post_hook = ["{{ ch19_create_udf() }}"]
    )
}}

WITH backbone AS (
{{ dbt_utils.date_spine(
    datepart="day",
    start_date="to_date('01/01/2000', 'mm/dd/yyyy')",
    end_date="CURRENT_DATE()"
   )
}}
)

SELECT
    date_day,
    year(date_day) AS year_,
    monthname(date_day) AS month_short,
    to_char(date_day, 'MMMM') AS month_long,
    dayofmonth(date_day) AS day_of_month,
    dayofweek(date_day) AS day_of_week,
    dayname(date_day) AS day_name_short,
    dayofyear(date_day) AS day_of_year,
    week(date_day) AS week_number,
    false AS is_holiday

FROM date_backbone
