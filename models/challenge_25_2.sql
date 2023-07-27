{{
  config(
    materialized = 'view',
    schema='dvd_frosty_friday_curated'
 )
}}

-- get columns
{% set sql %}
SELECT
  listagg(DISTINCT array_to_string(object_keys(r.value),'|')) AS keys_str
FROM {{ ref('challenge_25_1') }},
LATERAL flatten(result_:weather, OUTER => true) AS r
{% endset %}

{%- if execute and var('ch25', var('run_all', false)) %}
{% set results = run_query(sql) %}
{% do results.print_table() %}
{% set results_list = results.columns[0].values()[0] %}
{% else %}
{% set results = '' %}
{% set results_list = '' %}
{% endif %}

WITH base AS (
    SELECT * FROM {{ ref('challenge_25_1') }}
),

tabular AS (
    SELECT
        -- noqa: disable=L008
        r.value AS array_,
        {%- if results_list %}
{%- for item in results_list.split('|') %}
        r.value['{{ item }}']{{ '::timestamp' if item == 'timestamp' }} AS {{ item }},
{%- endfor %}
{% endif -%}
        current_date() AS processed_at
    FROM base,
        LATERAL flatten(result_:weather, OUTER => true) AS r
)

SELECT * FROM tabular
