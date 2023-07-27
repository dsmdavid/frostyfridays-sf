{{
  config(
    materialized = 'incremental',
    unique_key = 'id'
    )
}}
WITH base AS (
    SELECT
        1 AS id,
        1 AS employee_id,
        100.00 AS sale_amount
    UNION ALL
    SELECT
        2 AS id,
        1 AS employee_id,
        200.00 AS sale_amount
    UNION ALL
    SELECT
        3 AS id,
        2 AS employee_id,
        150.00 AS sale_amount
)

SELECT * FROM base
WHERE
    {% if var('ch38_init', false) %}
  1=2
{% else %}
        true
    {% endif %}
