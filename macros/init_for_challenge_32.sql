{% macro init_challenge_32() %}
{% set combs = {'8_min_UI':{'ui':8,'prog':240},
               '10_min_programmatic':{'ui':240,'prog':8}
               }%}
{% if execute %}
  {% set init_query %}
    {% for item_key, item_value in combs.items() %}
      create session policy if not exists {{target.schema}}.session_policy_ff_{{item_key}}
        session_ui_idle_timeout_mins = {{ item_value['ui'] }}
        session_idle_timeout_mins = {{ item_value['prog'] }}
        comment = 'Session policy for the ff_Challenge_32 -- {{ item_key }}'
      ;
      create user if not exists dvd_ff_{{ item_key }} ;
      alter user dvd_ff_{{ item_key }} set session policy {{ target.database }}.{{ target.schema }}.session_policy_ff_{{item_key}};
{% endfor %}

{% endset %}
  {{ log('Query for sp challenge_32 created', info=True)}}
  {{ log(init_query)}}
  {% do run_query(init_query) %}

  {{ log('Query for sp challenge_32 ran', info=True)}}

{% endif%}

{% endmacro %}

{% macro clean_up_32() %}

{% set combs = {'8_min_UI':{'ui':8,'prog':240},
               '10_min_programmatic':{'ui':240,'prog':8}
               }%}

{% if execute %}
  {% set init_query %}
  {% for item_key, item_value in combs.items() %}
  drop user if exists dvd_ff_{{ item_key }} ;
  drop session policy if exists  {{target.schema}}.session_policy_ff_{{item_key}};
{% endfor %}

{% endset %}
  {{ log('Query for clean up sp challenge_32 created', info=True)}}
  {{ log(init_query)}}
  {% do run_query(init_query) %}

  {{ log('Query for clean up sp challenge_32 ran', info=True)}}

{% endif%}

  {% endmacro %}