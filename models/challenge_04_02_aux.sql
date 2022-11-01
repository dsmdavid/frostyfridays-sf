{{
  config(
    materialized = 'view'
 )
}}

WITH temp AS (
    SELECT * FROM {{ ref('challenge_04_01') }}
),

combined_keys AS (
    SELECT array_to_string(array_agg(keys), ',') AS all_keys FROM temp
),

unique_keys AS (
    SELECT DISTINCT t.value AS key_name
    FROM combined_keys,
        LATERAL split_to_table(combined_keys.all_keys, ',') AS t
)

SELECT key_name FROM unique_keys
