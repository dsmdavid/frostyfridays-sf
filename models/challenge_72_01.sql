{{
  config(
    materialized = 'view'
    )
}}


{% if execute and var('ch72', var('run_all', false)) %}
{% set stage_name = 'dvd_frosty_fridays_72' %}
{% set exec_query = 'EXECUTE IMMEDIATE FROM @' ~ stage_name ~ '/execute_me.sql;' %}
{% do run_query(exec_query) %}
{% endif %}
SELECT * FROM {{ ref('challenge_72') }}
