{{
  config(
    materialized = 'view'
    )
}}

SELECT
    1 AS sale_id,
    PARSE_JSON('[1,3]') AS product_ids
UNION ALL
SELECT
    2 AS sale_id,
    PARSE_JSON('[2,4]') AS product_ids
