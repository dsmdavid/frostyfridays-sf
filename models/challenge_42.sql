{% set sql_txt %}
{% set prefix = var('ch_42_prefix', 'ch_42dbt') %}
{% set qualify_name = target.database ~ '.' ~ target.schema ~ '.' ~ prefix %}
{% set children = [
    {'name': 'JOAN',
     'frequency': 3,
     'awake' : 2},
     {'name': 'MAGGY',
     'frequency': 5,
     'awake' : 1},
    {'name': 'JASON',
     'frequency': 13,
     'awake' : 1}   
     ] %}

{% if not  var('cleanup', false) %}
CREATE OR REPLACE PROCEDURE {{ qualify_name }}_awake(
        MAX_MINUTES INTEGER)
    RETURNS VARCHAR
    LANGUAGE SQL
    EXECUTE AS caller
AS
    DECLARE
        stay_awake INTEGER DEFAULT (:MAX_MINUTES);
    BEGIN
        -- Wait for the specified number of minutes.
        CALL SYSTEM$WAIT(:stay_awake, 'MINUTES');
        RETURN 'Ran for ' || :stay_awake || ' minutes';
    END
    ;

CREATE OR REPLACE PROCEDURE {{ qualify_name }}_dad_start()
    RETURNS VARCHAR
    LANGUAGE SQL
    EXECUTE AS caller
AS
    BEGIN
    -- clean up tasks if exist
    {% for child in children %}
    drop task if exists {{ qualify_name }}_child_{{ child['name'] }};
    {% endfor %}

    -- recreate the children
    {% for child in children %}

    create task {{ qualify_name }}_child_{{ child['name'] }}
        WAREHOUSE = '{{ target.warehouse }}'
        SCHEDULE = '{{ child["frequency"] }} MINUTE'
        ALLOW_OVERLAPPING_EXECUTION= FALSE
    AS
        CALL {{ qualify_name }}_awake({{ child["awake"] }});
{% endfor %}
    -- resume all the children
    {% for child in children %}
    ALTER TASK {{ qualify_name }}_child_{{ child['name'] }} RESUME;
    {% endfor %}
    -- resume the dad
    ALTER TASK {{ qualify_name }}_dad_finishing_task RESUME;    
    ALTER TASK {{ qualify_name }}_dad_watching_task RESUME;
    END
    ;

--
CREATE OR REPLACE PROCEDURE {{ qualify_name }}_dad_watcher()
    RETURNS VARCHAR
    LANGUAGE SQL
    EXECUTE AS caller
AS
    DECLARE
        -- are there three children awake at the same time?
        query_check STRING DEFAULT (
    'with th as (
        select * from table(information_schema.task_history())
        where name ilike \'{{ prefix }}_child_%\'
    ),
    cross_join as (
        select th2.name as orig_task_name, th.*, th2.query_id as grouping_query
        from th
        cross join th as th2
        -- overlapping tasks
        where th.query_start_time >= th2.query_start_time
        and th.query_start_time  <= th2.completed_time
    ),
    concurrent as (
        select grouping_query,
            count(distinct name)
        from cross_join
        group by 1
        having count(distinct name) = 3
    )
    select count(*) >0 as need_to_finish from concurrent;');
        res resultset;
        output boolean;
    BEGIN
        -- Wait for the specified number of minutes.
        res := (EXECUTE IMMEDIATE query_check);
        let c1 cursor for res;
        open c1;
        FETCH c1 INTO output;
        if (output)
            then 
                -- we need to stop all downstream
                EXECUTE IMMEDIATE 'CALL system$set_return_value(\'TRUE\')';
            else 
                -- we need to continue
                EXECUTE IMMEDIATE 'CALL system$set_return_value(\'FALSE\')';
        end if;        
    END
    ;


CREATE OR REPLACE PROCEDURE {{ qualify_name }}_dad_stop()
    RETURNS VARCHAR
    LANGUAGE SQL
    EXECUTE AS caller
AS
    DECLARE
        query_check resultset DEFAULT (EXECUTE IMMEDIATE 'call system$get_predecessor_return_value()');
        c1 cursor for query_check;
        output varchar;
        STATUS varchar;
        time_now timestamp default (select current_timestamp());
    BEGIN
        open c1;
        FETCH c1 INTO status;

        IF (STATUS = 'TRUE')
            THEN
            --stop all tasks
                {% for child in children %}
                ALTER TASK {{ qualify_name }}_{{ child['name'] }} SUSPEND;
                {% endfor %}
                ALTER TASK {{ qualify_name }}_dad_watching_task SUSPEND;
                ALTER TASK {{ qualify_name }}_dad_finishing_task SUSPEND;
                output := 'SUCCESS at ' || time_now::varchar;
                EXECUTE IMMEDIATE 'CALL system$set_return_value(\'TRUE\')';
        ELSE
            output := 'continue at ' ||  time_now::varchar;
            EXECUTE IMMEDIATE 'CALL system$set_return_value(\'FALSE\')';
            -- do nothing
        END IF;
        return output;
    END
    ;


create or replace task {{ qualify_name }}_dad_watching_task
        WAREHOUSE = '{{ target.warehouse }}'
        SCHEDULE = '1 MINUTE'
        ALLOW_OVERLAPPING_EXECUTION= FALSE
    AS
        CALL {{ qualify_name }}_dad_watcher();

create or replace task {{ qualify_name }}_dad_finishing_task
        WAREHOUSE = '{{ target.warehouse }}'
        AFTER {{ qualify_name }}_dad_watching_task
    AS
        CALL {{ qualify_name }}_dad_stop();


-- set up everything in motion:
CALL {{ qualify_name }}_dad_start();


{% else %}
-- cleaning up
    {% for child in children %}
    alter task {{ qualify_name }}_child_{{ child['name'] }} SUSPEND;
    drop task if exists {{ qualify_name }}_child_{{ child['name'] }};
    {% endfor %}
    alter task {{ qualify_name }}_dad_watching_task SUSPEND;
    alter task {{ qualify_name }}_dad_finishing_task SUSPEND;
    drop task if exists {{ qualify_name }}_dad_watching_task;
    drop task if exists {{ qualify_name }}_dad_finishing_task;
    drop PROCEDURE if exists {{ qualify_name }}_awake(INTEGER);
    drop PROCEDURE if exists {{ qualify_name }}_dad_start();
    drop PROCEDURE if exists {{ qualify_name }}_dad_stop();
    drop PROCEDURE if exists {{ qualify_name }}_dad_watcher();

{% endif %}

{% endset %}

{{ sql_txt }}
