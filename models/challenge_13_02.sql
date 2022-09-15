{{
  config(
    materialized = 'view',
)
}}

with base as (
  select * from {{ ref('challenge_13_01') }}
)

select
  product,
  stock_amount,
  coalesce(stock_amount, lag(stock_amount) ignore nulls over (partition by product order by date_of_check asc )) as stock_amount_filled_out,
  date_of_check
from base
order by product, date_of_check asc