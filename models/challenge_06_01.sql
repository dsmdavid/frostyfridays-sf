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
{% endif %}


SELECT
    metadata$filename AS file_name,
    metadata$file_row_number AS rn,
    $1 AS headers
FROM @{{ stage_name }}
WHERE rn = 1
