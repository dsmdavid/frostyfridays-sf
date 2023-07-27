{{
  config(
    materialized = 'view',
    )
}}

{% if execute %}
{{ ch_48() }}
{% endif %}

SELECT
    '{{ var("ch48", var("run_all", false)) }}'::varchar AS is_ch_48,
    '{{ var("cleanup", false) }}'::varchar AS is_cleanup
