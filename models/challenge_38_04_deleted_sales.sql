-- depends on: {{ ref("challenge_38_03_employee_sales") }}
-- depends_on: {{ ref('challenge_38_01_employees') }}
{{
  config(
    materialized = 'incremental',
    unique_key = ['id','name', 'METADATA$ROW_ID', 'METADATA$ACTION'],
    pre_hook = ['{{ ch_38_delete_entries() }}']
    )
}}
-- create the stream the first time
{% if var('ch38_init', false) %}
{% set init_sql %}
CREATE OR REPLACE STREAM ch38_stream_view
  ON VIEW {{ ref('challenge_38_03_employee_sales') }}
  COMMENT = 'Stream created for FF_Ch_38';
{% endset %}
{% do run_query(init_sql) %}
{% endif %}

SELECT * FROM ch38_stream_view
WHERE "METADATA$ACTION" = 'DELETE' --noqa: disable=L057
