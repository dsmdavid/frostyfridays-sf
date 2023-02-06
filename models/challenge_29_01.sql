{{
  config(
    materialized = 'view'
 )
}}
{% set stage_name = 'dvd_frosty_fridays_29' %}
{% set stage_additional_info = "url='s3://frostyfridaychallenges/challenge_29/' file_format=(type=csv SKIP_HEADER =1)" %}

{%- if execute %}
{{ create_stage(
        database = target.database,
        schema = target.schema,
        name = stage_name,
        additional_info = stage_additional_info) }}
{% endif %}

--noqa: disable=L028
WITH staged AS (
    SELECT
        metadata$filename AS filename_,
        metadata$file_row_number AS row_,
        t.$1::int AS id,
        t.$2::varchar(100) AS first_name,
        t.$3::varchar(100) AS surname,
        t.$4::varchar(250) AS email,
        t.$5::datetime AS start_date
    FROM @{{ stage_name }} (PATTERN=> '.*start_dates.*') AS t
    ORDER BY 1, 2
)

SELECT * FROM staged
