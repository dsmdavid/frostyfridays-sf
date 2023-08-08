{% macro ch_48() %}
{# use it like:
# to create the objects
dbt run -s challenge_48 --vars '{"ch48": "value", "email_to_send":"value"}
# to drop the objects
dbt run -s challenge_48 --vars '{"ch48": "value", "email_to_send":"value", "cleanup":true}'
#}
{% set notification_integration_name = 'notification_frosty_friday_48' %}
{% set alert_name = 'alert_frosty_friday_48' %}
{% set email_to_send = var("email_to_send",'') %}
{% set alert_interval_value = '10' %}
{% set alert_interval_unit = 'MINUTE' %}

{% set create_notification_statement %}
create notification integration if not exists {{ notification_integration_name }}
  type = email 
  enabled = true 
  allowed_recipients = ('{{ email_to_send }}')
  comment = "Notification integration for Frosty Friday";
{% endset %}
{% set drop_notification_statement %}
drop notification integration if exists {{ notification_integration_name }};
{% endset %}


{% set create_alert_statement %}
create or replace alert {{ alert_name }}
  warehouse = {{ target.warehouse }}
  schedule = '{{ alert_interval_value }} {{ alert_interval_unit }}'
  IF (
    EXISTS (
      select * from table(snowflake.information_schema.query_history())
      where
            -- running queries:
            ( execution_status = 'RUNNING ' AND start_time < current_timestamp() - INTERVAL '{{ alert_interval_value }} {{ alert_interval_unit }}S')
            OR 
            -- queries that finished since the last time we checked
            (
            end_time >= current_timestamp() - interval '{{ alert_interval_value }} {{ alert_interval_unit }}S'
            and 
            datediff('{{ alert_interval_unit }}S', start_time, end_time) >= {{ alert_interval_value }}
            )

    )
  )
  THEN 
    call system$send_email(
      '{{ notification_integration_name }}',
      '{{ email_to_send }}',
      'Long running query detected',
      'Oh, oh... a long running query was detected at ' || to_varchar(current_timestamp()) 
    )
  ;
  alter alert {{ alert_name }} resume;

{% endset %}
{% set drop_alert_statement %}
alter alert {{ alert_name }} suspend;
drop alert if exists {{ alert_name }};
{% endset %}

{% if execute and var("ch48", var("run_all", false)) and not var("cleanup", false) %}
  {{ log('Running query to create ff48 objects', info=True)}}
  {% do run_query(create_notification_statement) %}
  {% do run_query(create_alert_statement) %}

{% elif execute and var("ch48", var("run_all", false)) and var("cleanup", false) %}
  {{ log('Running query to destroy ff48 objects', info=True)}}
  {% do run_query(drop_notification_statement) %}
  {% do run_query(drop_alert_statement) %}
{% else %}
  {{ log('Nothing to do for ff48')}}

{% endif %}

{% endmacro %}
