{{
  config(
    materialized = 'view',
    )
}}

WITH prep_1 AS (SELECT
    'user@domain' AS e_data,
    1 AS n_counter
)

SELECT
    e_data, -- s
    n_counter
FROM prep_1
