{{
  config(
    materialized = 'view'
 )
}}
{% set stage_name = 'dvd_frosty_fridays_16' %}
{% set stage_additional_info = "url='s3://frostyfridaychallenges/challenge_16/' file_format=dvd_frosty_fridays_json" %}

{%- if execute %}
  {% set sql %}
  create or replace file format dvd_frosty_fridays_json
    type = json
    strip_outer_array = TRUE
  {% endset %}
  {% do run_query(sql) %}

  {{ create_stage(
        database = target.database,
        schema = target.schema,
        name = stage_name,
        additional_info = stage_additional_info) }}
{% endif %}


with staged as (
    select 
      metadata$filename as filename_,
      metadata$file_row_number as row_,
      t.$1 as result 
      from @{{stage_name}} 
       (pattern=>'.*week16.*')
       as t
    order by 1,2
)
select * from staged