{{
  config(
    materialized = 'table'
 )
}}
{% set stage_name = 'dvd_frosty_fridays_10' %}
{% set stage_additional_info = "url='s3://frostyfridaychallenges/challenge_10/' file_format=(type=csv SKIP_HEADER =1)" %}

{%- if execute %}
  {{ create_stage(
        database = target.database,
        schema = target.schema,
        name = stage_name,
        additional_info = stage_additional_info) }}
{% endif %}

{% if execute %}
  {{ init_challenge_10() }}

  {% set query %}
    call ch10_dynamic_warehouse_data_load();
  {% endset %}
  {% do run_query(query) %}
{% endif %}
select 
  *, 
  current_timestamp() as ingested_at
from table(RESULT_SCAN(LAST_QUERY_ID()))
