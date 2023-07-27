{% macro init_challenge_36() %}
{% set init_query %}
    USE SCHEMA {{ target.schema }};
    CREATE OR REPLACE TABLE ch36_table_1 (id INT);
    CREATE OR REPLACE VIEW ch36_view_1 AS (SELECT * FROM ch36_table_1);
    CREATE OR REPLACE TABLE ch36_table_2 (id INT);
    CREATE OR REPLACE VIEW ch36_view_2 AS (SELECT * FROM ch36_table_2);
    CREATE OR REPLACE TABLE ch36_table_6 (id INT);
    CREATE OR REPLACE VIEW ch36_view_6 AS (SELECT * FROM ch36_table_6);
    CREATE OR REPLACE TABLE ch36_table_5 (id INT);
    CREATE OR REPLACE VIEW ch36_view_5 AS (SELECT * FROM ch36_table_5);
    CREATE OR REPLACE TABLE ch36_table_4 (id INT);
    CREATE OR REPLACE VIEW ch36_view_4 AS (SELECT * FROM ch36_table_4);
    CREATE OR REPLACE TABLE ch36_table_3 (id INT);
    CREATE OR REPLACE VIEW ch36_view_3 AS (SELECT * FROM ch36_table_3);
    CREATE OR REPLACE VIEW my_union_view AS
    SELECT * FROM ch36_table_1
    UNION ALL
    SELECT * FROM ch36_table_2
    UNION ALL
    SELECT * FROM ch36_table_3
    UNION ALL
    SELECT * FROM ch36_table_4
    UNION ALL
    SELECT * FROM ch36_table_5
    UNION ALL
    SELECT * FROM ch36_table_6;
{% endset %}

{% if execute and var('ch36', false) %}
  {% do run_query(init_query) %}
  {{ log('Query for init challenge_36 ran', info=True)}}
{% else %}
  {{ log('Query for init challenge_36 did not run', info=True)}}
  {{ log(var('ch36',false), info=True) }}
{% endif %}

{% endmacro %}

{% macro clean_up_challenge_36() %}
{% set cleanup_sql %}
    USE SCHEMA {{ target.schema }};
    DROP TABLE IF EXISTS ch36_table_1;
    DROP VIEW IF EXISTS ch36_view_1;
    DROP TABLE IF EXISTS ch36_table_2;
    DROP VIEW IF EXISTS ch36_view_2;
    DROP TABLE IF EXISTS ch36_table_6;
    DROP VIEW IF EXISTS ch36_view_6;
    DROP TABLE IF EXISTS ch36_table_5;
    DROP VIEW IF EXISTS ch36_view_5;
    DROP TABLE IF EXISTS ch36_table_4;
    DROP VIEW IF EXISTS ch36_view_4;
    DROP TABLE IF EXISTS ch36_table_3;
    DROP VIEW IF EXISTS ch36_view_3;
    DROP VIEW IF EXISTS my_union_view;
{% endset %}
{% if execute and var('ch36', false) %}
  {% do run_query(cleanup_sql) %}
  {{ log('Clean up query for challenge_36 ran', info=True)}}
{% else %}
  {{ log('Clean up query for challenge_36 did not run', info=True)}}
  {{ log(var('ch36',false), info=True) }}
{% endif %}
{% endmacro %}
