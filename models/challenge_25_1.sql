{{
  config(
    materialized = 'table',
    schema='dvd_frosty_friday_lz'
 )
}}
{% set stage_name = 'dvd_frosty_fridays_25' %}
{% set stage_additional_info = "url='s3://frostyfridaychallenges/challenge_25/' file_format=(type=JSON STRIP_OUTER_ARRAY = TRUE)" %}

{%- if execute %}
{{ create_stage(
        database = target.database,
        schema = target.schema,
        name = stage_name,
        additional_info = stage_additional_info) }}
{% endif %}


WITH staged AS (
    SELECT
        metadata$filename AS filename_,
        metadata$file_row_number AS row_,
        $1 AS result_
    FROM @{{ stage_name }}
    ORDER BY 1, 2
)

SELECT * FROM staged
