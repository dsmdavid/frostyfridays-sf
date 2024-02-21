{% macro ch76_create_tasks() %}
{% if execute and var('ch75', var('run_all', false)) %}
    {% set sql_statement %}
    CREATE TABLE IF NOT EXISTS {{ target.database }}.{{ target.schema }}.ch75_task_table (stamp time, message varchar);

    CREATE OR REPLACE TASK {{ target.database }}.{{ target.schema }}.ch75_main_task
        WAREHOUSE = WAREHOUSE_DVD_TEST
        SCHEDULE = '1 minute'
        ALLOW_OVERLAPPING_EXECUTION = FALSE
        COMMENT = 'Task developed for frosty challenge 75, will fail often'
        AS 
        SELECT CASE
            WHEN RANDOM() <0 THEN 1/0
            ELSE 1
        END;

    CREATE OR REPLACE TASK {{ target.database }}.{{ target.schema }}.ch75_child_task 
        WAREHOUSE = WAREHOUSE_DVD_TEST
        FINALIZE =  {{ target.database }}.{{ target.schema }}.ch75_main_task
        AS
        INSERT INTO {{ target.database }}.{{ target.schema }}.ch75_task_table (stamp,message) VALUES(CURRENT_TIMESTAMP,'main_task succes!');
ALTER TASK {{ target.database }}.{{ target.schema }}.ch75_child_task resume;
ALTER TASK {{ target.database }}.{{ target.schema }}.ch75_main_task resume;

{% endset %}
{% do run_query(sql_statement) %}
{% endif %}

{% endmacro %}