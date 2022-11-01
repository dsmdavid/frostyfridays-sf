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


WITH staged AS (
    SELECT
        m.$1 AS milking_datetime,
        m.$2 AS cow_number,
        m.$3 AS fat_percentage,
        m.$4 AS farm_code,
        m.$5 AS centrifuge_start_time,
        m.$6 AS centrifuge_end_time,
        m.$7 AS centrifuge_kwph,
        m.$8 AS centrifuge_electricity_used,
        m.$9 AS centrifuge_processing_time,
        m.$10 AS task_used
    FROM @{{ stage_name }} (PATTERN => '.*milk_data.*[.]csv') AS m
)

SELECT * FROM staged
