 -- depends_on: {{ ref('challenge_38_01_employees') }}
{% macro ch_38_delete_entries() %}
{% if execute and var('ch38_update', false) %}
  {% set init_query %}
  delete from {{ ref('challenge_38_01_employees') }}
  where id = 1;
  {% endset %}
  {% do run_query(init_query) %}
  {{ log('Deleting rows for CH38 ran', info=True)}}
{% endif %}

{% endmacro %}
