{{
  config(
    materialized = 'view'
 )
}}
{% set stage_name = 'dvd_frosty_fridays' %}
{% set stage_additional_info = "url='s3://frostyfridaychallenges/challenge_1/' file_format=(type=csv SKIP_HEADER =1)" %} -- noqa: L016

{% if execute and var('ch01', var('run_all', false)) %}
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
