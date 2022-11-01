{{
  config(
    materialized = 'view'
 )
}}
{% set stage_name = 'dvd_frosty_fridays_03' %}
{% set stage_additional_info = "url='s3://frostyfridaychallenges/challenge_3/' file_format=(type=csv)" %}

{%- if execute %}
{{ create_stage(
        database = target.database,
        schema = target.schema,
        name = stage_name,
        additional_info = stage_additional_info) }}

{% do run_query("list @" ~ stage_name  ) %}
{% set query_id_res = run_query("select last_query_id()") %}
{% set query_id = query_id_res.columns[0].values()[0] %}

{% else %}
  {% set query_id = 'dummy' %}
{% endif %}

WITH lq AS (
        SELECT * FROM table(
            result_scan('{{ query_id }}')
        )
),

kws AS (
    SELECT $1 AS kw
    FROM @{{ stage_name }}
    WHERE metadata$filename ILIKE '%keywords.csv'
)

SELECT lq.*
FROM lq
    CROSS JOIN kws
WHERE lq."name" ILIKE '%' || kws.kw || '%'
