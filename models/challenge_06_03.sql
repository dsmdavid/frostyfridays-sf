-- depends_on: {{ ref('challenge_06_01') }}
{{
  config(
    materialized = 'table'
 )
}}
{% set stage_name = 'dvd_frosty_fridays_06' %}
{% set stage_additional_info = "url='s3://frostyfridaychallenges/challenge_6/' file_format=(type=csv SKIP_HEADER =1 FIELD_OPTIONALLY_ENCLOSED_BY='\"')" %}

{%- if execute %}
{{ create_stage(
        database = target.database,
        schema = target.schema,
        name = stage_name,
        additional_info = stage_additional_info) }}

{% set query %}
    select headers from {{ ref('challenge_06_01') }}
    where file_name ilike '%westminster%'
  {% endset %}
{% set results_query = run_query(query) %}
{% set results = results_query.columns[0].values()[0].split(',') %}
{{ log(results, info = True) }}
{% endif %}


SELECT
    {% for item in results %}
    ${{ loop.index }}::varchar(50) AS {{ item }}{% if not loop.last %}, {% endif %}
    {% endfor %}
FROM @{{ stage_name }}
WHERE metadata$filename ILIKE '%westminster%'
