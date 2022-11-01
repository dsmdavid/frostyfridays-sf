{{
  config(
    materialized = 'view'
  )
}}
WITH base AS (
        SELECT * FROM {{ ref('challenge_11') }}
)

SELECT
    task_used,
    count(*) AS n_rows
FROM base
GROUP BY 1
ORDER BY 2 DESC
