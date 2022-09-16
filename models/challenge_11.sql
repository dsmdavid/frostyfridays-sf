{{
  config(
    materialized = 'table',
    post_hook=[" {{ ch11_create_tasks() }}",
              "execute task dvd_frosty_whole_milk_updates;",
              "alter task dvd_frosty_whole_milk_updates suspend;" ]
 )
}}
{% set stage_name = 'dvd_frosty_fridays_11' %}
{% set stage_additional_info = "url='s3://frostyfridaychallenges/challenge_11/' file_format=(type=csv SKIP_HEADER =1)" %}

{%- if execute %}
  {{ create_stage(
        database = target.database,
        schema = target.schema,
        name = stage_name,
        additional_info = stage_additional_info) }}
{% endif %}


with staged as (
select
        m.$1 as milking_datetime,
        m.$2 as cow_number,
        m.$3 as fat_percentage,
        m.$4 as farm_code,
        m.$5 as centrifuge_start_time,
        m.$6 as centrifuge_end_time,
        m.$7 as centrifuge_kwph,
        m.$8 as centrifuge_electricity_used,
        m.$9 as centrifuge_processing_time,
        m.$10 as task_used
from  @{{stage_name}} (pattern => '.*milk_data.*[.]csv') m

)
select * from staged