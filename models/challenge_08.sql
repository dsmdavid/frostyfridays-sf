{{
  config(
    materialized = 'view'
 )
}}
{% set stage_name = 'dvd_frosty_fridays_08' %}
{% set stage_additional_info = "url='s3://frostyfridaychallenges/challenge_8/' file_format=(type=csv SKIP_HEADER =1)" %}

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
        $2::timestamp AS payment_date,
        $3::varchar AS card_type,
        $4::int AS amount_spent
    FROM @{{ stage_name }}
)

SELECT * FROM staged
