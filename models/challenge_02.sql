{{
  config(
    materialized = 'table'
 )
}}
{% set stage_name = 'dvd_frosty_fridays_02' %}
{% set stage_additional_info = "url='s3://frostyfridaychallenges/challenge_2' file_format=(type=PARQUET)" %}

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
        $1 AS v
    FROM @{{ stage_name }}
    ORDER BY 1, 2
)

SELECT
    v:city::string AS city,
    v:country::string AS country,
    v:country_code::string AS country_code,
    v:dept::string AS dept,
    v:education::string AS education,
    v:email::string AS email,
    v:employee_id::string AS employee_id,
    v:first_name::string AS first_name,
    v:job_title::string AS job_title,
    v:last_name::string AS last_name,
    v:payroll_iban::string AS payroll_iban,
    v:postcode::string AS postcode,
    v:street_name::string AS street_name,
    v:street_num::string AS street_num,
    v:time_zone::string AS time_zone,
    v:title::string AS title
FROM staged
