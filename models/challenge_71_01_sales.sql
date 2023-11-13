{{
  config(
    materialized = 'view'
    )
}}


-- Create the Sales table
{# CREATE OR REPLACE TABLE Sales (
    Sale_ID INT PRIMARY KEY,
    Product_IDs VARIANT --INT
);

-- Inserting sample sales data
INSERT INTO Sales (Sale_ID, Product_IDs) SELECT 1, PARSE_JSON('[1, 3]');-- Products A and C in the same sale
INSERT INTO Sales (Sale_ID, Product_IDs) SELECT 2, PARSE_JSON('[2, 4]');-- Products B and D in the same sale #}

SELECT
    1 AS sale_id,
    PARSE_JSON('[1,3]') AS product_ids
UNION ALL
SELECT
    2 AS sale_id,
    PARSE_JSON('[2,4]') AS product_ids
