{% macro sp_challenge_10() %}
  {{ log('Starting challenge_10 sp', info=True)}}
  {% set table_name = 'challenge_10_insert'%}
  {% set initial_query %}
USE DATABASE {{ target.database }};
USE SCHEMA {{ target.schema }};
  -- Create the warehouses
create warehouse if not exists wh_dvd_frosty_xsmall
    with warehouse_size = XSMALL
    auto_suspend = 60;
    
create warehouse if not exists wh_dvd_frosty_small 
    with warehouse_size = XSMALL
    auto_suspend = 60;

-- Create the table
create or replace table {{ table_name }}
(
    date_time datetime,
    trans_amount double
);
  {% endset %}
  {{ log('Query for challenge_10 created', info=True)}}

{% do run_query(initial_query) %}
  {{ log('Query for challenge_10 ran', info=True)}}


{% endmacro %}