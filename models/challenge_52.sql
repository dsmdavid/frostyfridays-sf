{{
  config(
    materialized = 'view',
    pre_hook=[
        "{{ init_for_challenge_52() }}",
        "{{ ch_52_create_dynamic_table() }}"
    ],
    post_hook=["{{ clean_up_52() }}"]
    )
}}
{% if execute and var('ch52', var('run_all', false)) %}
select * from {{ target.database }}.{{ target.schema }}.challenge_52_02
{% else %}
    SELECT 'Please, run this model with "var ch52 or run_all"' AS table_status
{% endif %}

-- either wait for 20 min (hardcoded refresh time)
-- or run ' alter dynamic table challenge_52_02 refresh;'
