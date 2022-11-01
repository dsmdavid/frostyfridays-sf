{{
  config(
    materialized = 'view',
)
}}

WITH base AS (
        SELECT * FROM {{ ref('challenge_13_01') }}
)

SELECT
    product,
    stock_amount,
    coalesce(
        stock_amount,
        lag(stock_amount) IGNORE NULLS OVER (PARTITION BY product ORDER BY date_of_check ASC)
    ) AS stock_amount_filled_out,
    date_of_check
FROM base
ORDER BY product, date_of_check ASC
