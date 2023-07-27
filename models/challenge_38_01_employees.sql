{{
  config(
    materialized = 'incremental',
    unique_key = 'id'
    )
}}

WITH base AS (
    SELECT
        1 AS id,
        'Alice' AS name, --noqa: disable=L029
        'Sales' AS department
    UNION ALL
    SELECT
        2 AS id,
        'Bob' AS name, --noqa: disable=L029
        'Marketing' AS marketing
)

SELECT * FROM base
WHERE

    {% if var('ch38_init', false) %}
  1=2
{% else %}
        true
    {% endif %}
