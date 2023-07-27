{% macro ch11_create_tasks() %}
{% if execute and var('ch11', var('run_all', false)) %}
    {% set sql_statement %}
    CREATE OR REPLACE TASK dvd_frosty_whole_milk_updates
        WAREHOUSE = WAREHOUSE_DVD_TEST
        SCHEDULE = '1400 minutes'
        ALLOW_OVERLAPPING_EXECUTION = FALSE
        COMMENT = 'Task developed for frosty challenge 11, whole milk'
        AS 
        update  "TEST_DB"."DVD_FROSTY_FRIDAYS"."CHALLENGE_11"
    set
        CENTRIFUGE_START_TIME = null,
        CENTRIFUGE_END_TIME = null,
        CENTRIFUGE_KWPH = null,
        TASK_USED = SYSTEM$CURRENT_USER_TASK_NAME() || ' at ' || sysdate()::string

    where FAT_PERCENTAGE = 3;

CREATE OR REPLACE TASK dvd_frosty_skim_milk_updates
    WAREHOUSE = WAREHOUSE_DVD_TEST
    COMMENT = 'Task developed for frosty challenge 11, skim milk'
    AFTER dvd_frosty_whole_milk_updates
    AS 
    update  "TEST_DB"."DVD_FROSTY_FRIDAYS"."CHALLENGE_11"
    set
        CENTRIFUGE_PROCESSING_TIME = timestampdiff('seconds', CENTRIFUGE_START_TIME::timestamp, CENTRIFUGE_END_TIME::timestamp),
        TASK_USED = SYSTEM$CURRENT_USER_TASK_NAME() || ' at ' || sysdate()::string

    where FAT_PERCENTAGE != 3;
    alter task dvd_frosty_skim_milk_updates resume;
{% endset %}
{% do run_query(sql_statement) %}
{% endif %}

{% endmacro %}