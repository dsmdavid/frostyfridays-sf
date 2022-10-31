{% macro init_challenge_10() %}
  {{ log('Starting challenge_10 pre-work', info=True)}}
  {% set table_name = 'challenge_10_insert'%}
  {% set xs_wh_name = 'wh_dvd_frosty_xsmall'%}
  {% set s_wh_name = 'wh_dvd_frosty_small'%}
  {% set stage_name = 'dvd_frosty_fridays_10' %}
  {% set whs = [
    {'name':'wh_dvd_frosty_xsmall','size':'XSMALL'},
    {'name':'wh_dvd_frosty_small','size':'XSMALL'}] 
    %}

  {% set initial_query %}
USE DATABASE {{ target.database }};
USE SCHEMA {{ target.schema }};
  -- Create the warehouses
use role sysadmin;
{% for wh in whs %}
create warehouse if not exists {{ wh['name'] }}
    with warehouse_size = {{wh['size']}}
    auto_suspend = 60;
grant usage on warehouse  {{ wh['name'] }} to role {{ target.role }};
{% endfor %}

use role {{ target.role }};

-- Create the table
create or replace table {{ table_name }}
(
    date_time datetime,
    trans_amount double
);
  {% endset %}
  {{ log('Query for challenge_10 created', info=True)}}
  {{ log(initial_query) }}
  {% do run_query(initial_query) %}
  {{ log('Query for challenge_10 ran', info=True)}}

  {% set stored_procedure_query %}
CREATE OR REPLACE PROCEDURE {{target.database}}.{{target.schema}}.ch10_dynamic_warehouse_data_load()
    RETURNS VARCHAR
    LANGUAGE SQL
    EXECUTE AS caller
AS
    $$
    DECLARE
        max_size INTEGER DEFAULT 10000;
        accumulator INTEGER DEFAULT 0;
        counter_xsmall INTEGER DEFAULT 0;
        counter_small INTEGER DEFAULT 0;
        current_xsmall INTEGER DEFAULT 0;
        current_small INTEGER DEFAULT 0;
        temp resultset DEFAULT (
                list @{{ stage_name }}
            );
        res resultset DEFAULT (
                SELECT
                    "name" AS NAME,
                    "size" AS SIZE
                FROM
                    TABLE(RESULT_SCAN(LAST_QUERY_ID())));
        cur1 CURSOR for res;
        warehouse_use VARCHAR;
        insert_statement VARCHAR;
        table_name VARCHAR DEFAULT '{{target.database}}.{{target.schema}}.{{table_name}}';

    BEGIN
        for row_variable IN cur1 DO 
            warehouse_use:= 'USE WAREHOUSE ' ||
                CASE
                    WHEN row_variable.size < :max_size THEN ' {{ xs_wh_name}}'
                    ELSE ' {{ s_wh_name }}'
                END || ';';
            temp:= (
                EXECUTE IMMEDIATE :warehouse_use
                );
            insert_statement:= 'COPY INTO ' || :table_name || ' FROM @{{ stage_name }} FILES= (' ||  '\'' || REGEXP_SUBSTR(row_variable.name,'[^/]+$') || '\');';
            temp:= (
                EXECUTE IMMEDIATE :insert_statement
                );
            accumulator:= accumulator + 1;
            current_xsmall := CASE WHEN row_variable.size < :max_size THEN 1 ELSE 0 END;
            current_small :=  CASE WHEN row_variable.size < :max_size THEN 0 ELSE 1 END;
            counter_xsmall := counter_xsmall + current_xsmall;
            counter_small := counter_small + current_small;
        END for;
    RETURN accumulator :: VARCHAR || ' files were ingested, ' || counter_xsmall::varchar || ' ingested with XSMALL, ' || counter_small::varchar || ' ingested with SMALL wh' ;
    
    END;
    $$

{% endset %}
  {{ log('Query for sp challenge_10 created', info=True)}}
  {{ log(stored_procedure_query)}}
  {% do run_query(stored_procedure_query) %}
  {{ log('Query for sp challenge_10 ran', info=True)}}

{% endmacro %}