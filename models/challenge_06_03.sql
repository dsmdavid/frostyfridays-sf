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
  {{ log(results, info = True)}}
{% else %}
  {{ log('nothing to do _ ch_06', info=True) }}
{% endif %}


select
  {% for item in results %}
  ${{ loop.index }}::varchar(50) as {{ item }}{% if not loop.last %},{% endif %}
  {% endfor %}
from @{{ stage_name }}
where metadata$filename ilike '%westminster%'