{{
  config(
    materialized = 'view'
    )
}}

SELECT
    1 AS product_id,
    'Product A' AS product_name,
    ARRAY_CONSTRUCT('Electronics', 'Gadgets') AS product_categories
UNION ALL
SELECT
    2 AS product_id,
    'Product B' AS product_name,
    ARRAY_CONSTRUCT('Clothing', 'Accessories') AS product_categories
UNION ALL
SELECT
    3 AS product_id,
    'Product C' AS product_name,
    ARRAY_CONSTRUCT('Electronics', 'Appliances') AS product_categories
UNION ALL
SELECT
    4 AS product_id,
    'Product D' AS product_name,
    ARRAY_CONSTRUCT('Clothing') AS product_categories
