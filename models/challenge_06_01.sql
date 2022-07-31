{{
  config(
    materialized = 'view'
 )
}}
{% set stage_name = 'dvd_frosty_fridays_06_explore' %}
{% set stage_additional_info = "url='s3://frostyfridaychallenges/challenge_6/' file_format=(type=csv FIELD_DELIMITER='\0')" %}

{%- if execute %}
  {{ create_stage(
        database = target.database,
        schema = target.schema,
        name = stage_name,
        additional_info = stage_additional_info) }}
{% else %}
  {{ log('nothing to do', info=True) }}
{% endif %}


select
  metadata$filename as file_name,
  metadata$file_row_number as rn,
  $1 as headers
from @{{ stage_name }}
where rn = 1
