{{
  config(
    materialized = 'view',
    post_hook = ["{{ ch19_create_udf() }}"]
    )
}}

with backbone as (
{{ dbt_utils.date_spine(
    datepart="day",
    start_date="to_date('01/01/2000', 'mm/dd/yyyy')",
    end_date="CURRENT_DATE()"
   )
}}
)
select 
    date_day,
    year(date_day) as year_,
    monthname(date_day) as month_short,
    to_char(date_day, 'MMMM') as month_long,
    dayofmonth(date_day) as day_of_month,
    dayofweek(date_day) as day_of_week,
    dayname(date_day) as day_name_short,
    dayofyear(date_day) as day_of_year,
    week(date_day) as week_number,
    false as is_holiday

from date_backbone
