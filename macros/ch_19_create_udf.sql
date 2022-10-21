{% macro ch19_create_udf() %}
{% if execute %}
    {% set sql_statement %}
create or replace function test_db.dvd_frosty_fridays.WORKING_DAYS(START_DATE STRING, END_DATE STRING, INCLUDE_UPPER BOOLEAN)
returns numeric(11, 2)
    as 
    $$
    SELECT count(*) 
    FROM test_db.dvd_frosty_fridays.challenge_19
    WHERE
        not is_holiday
        and date_day >= START_DATE::date
        and date_day < dateadd('day', CASE WHEN INCLUDE_UPPER THEN 1 ELSE 0 END, END_DATE::DATE)
    $$
;

    {% endset %}
    {% do run_query(sql_statement) %}
{% endif %}

{% endmacro %}