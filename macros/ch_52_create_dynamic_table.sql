{% macro ch_52_create_dynamic_table() %}
{% set init_query %}
CREATE DYNAMIC TABLE IF NOT EXISTS challenge_52_02
 TARGET_LAG = '20 minutes'
  WAREHOUSE = {{ target.warehouse }}
  AS
    SELECT
    payload:address::varchar AS address,
    payload:email::varchar AS email,
    payload:id AS id,
    payload:name::varchar AS name,
    payload:transactionValue AS transaction_value,
    ingested_at
from {{ target.database}}.{{ target.schema }}.challenge_52_01;
{% endset %}
{% if execute and var('ch52', var('run_all', false)) %}
  {% do run_query(init_query) %}
  {{ log('Query for dynamic table challenge_52 ran', info=True)}}
{% endif %}

{% endmacro %}


{% macro clean_up_52() %}
{% set cleanup_query %}
    USE DATABASE {{ target.database }};
    USE SCHEMA {{ target.schema }};
    DROP DYNAMIC TABLE IF EXISTS challenge_52_02;
{% endset %}
{% if execute and var('ch52', var('run_all', false) and var('cleanup', false)) %}
  {% do run_query(cleanup_query) %}
  -- dropping dynamic table
{% endif %}
{% endmacro %}
