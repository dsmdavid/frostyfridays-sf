{{
  config(
    materialized = 'table',
    pre_hook =[
      "{{ log('running prehook in ch_20') }}"
    ]
 )
}}

{%- if execute and var('ch20', var('run_all', false)) %}
  {{ init_challenge_20() }}

  {% set query %}
    call {{ target.database }}.{{ target.schema }}.ch20_clone_with_copy_grants(
      '{{ target.database }}',
      '{{ target.schema }}',
      '{{ target.database }}',
      '{{ target.schema ~ "_cloned" }}',
      ''
    );
  {% endset %}
  {% do run_query(query) %}
{% endif %}
select 
  *, 
  current_timestamp() as run_at
from table(RESULT_SCAN(LAST_QUERY_ID()))
