{{
  config(
    materialized = 'view'
 )
}} --noqa: disable=L016
{% set stage_name = 'dvd_frosty_fridays_16' %}
{% set stage_additional_info = "url='s3://frostyfridaychallenges/challenge_16/' file_format=dvd_frosty_fridays_json" %} -- noqa: L016

{%- if execute and var('ch16', var('run_all', false)) %}
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
-- noqa: disable=L028
WITH staged AS (
    SELECT
        metadata$filename AS filename_,
        metadata$file_row_number AS row_,
        t.$1 AS result
    FROM @{{ stage_name }} (PATTERN=> '.*week16.*') AS t
    ORDER BY 1, 2
)

SELECT * FROM staged
