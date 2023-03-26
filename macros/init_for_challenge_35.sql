{% macro init_challenge_35() %}

{% set stage_name = 'dvd_frosty_fridays_35' %}
{% set stage_additional_info = "url='s3://frostyfridaychallenges/challenge_35/' file_format=(type=csv SKIP_HEADER =1  field_optionally_enclosed_by = '\"')" %}
{% set create_sql %}
  CREATE EXTERNAL TABLE IF NOT EXISTS CHALLENGE_35_01 (
    month DATE AS (
      REGEXP_REPLACE(
        metadata$filename,
        $$.*?(\d{4})/(\d{2}).*?$$,
        '\\1-\\2-01'
        )::DATE
      ),
    id INT AS (value:c1::INT),
    drug_name VARCHAR AS  (value:c2::VARCHAR),
    amount_sold NUMBER AS (value:c3::NUMBER))
    LOCATION=@{{ stage_name }}
    AUTO_REFRESH = TRUE
    FILE_FORMAT = (TYPE=CSV SKIP_HEADER =1
        FIELD_OPTIONALLY_ENCLOSED_BY = '"')
{% endset %}
{%- if execute %}
  {{ create_stage(
          database = target.database,
          schema = target.schema,
          name = stage_name,
          additional_info = stage_additional_info) }}
  {% do run_query(create_sql) %}
{% endif %}

{% endmacro %}