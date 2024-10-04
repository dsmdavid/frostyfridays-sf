-- depends on: {{ ref('challenge_109_01') }}
{{
  config(
    materialized = 'table'
 )
}}

{% if execute and var('ch109', var('run_all', false)) %}
-- set up variables needed

-- prepare user creation script
{% set sql %}

use role {{ target.role }};
use database {{ target.database }};
use schema {{ target.schema }};
create or replace procedure get_employee_performance_by_department(DEPARTMENT varchar)
RETURNS TABLE (
  EMP_ID int,
  EMP_NAME varchar, 
  PERFORMANCE_SCORE float,
  REVIEW_DATE date
)
LANGUAGE SQL 
EXECUTE AS CALLER
AS
$$
DECLARE
  res RESULTSET;
  sql1 varchar default ('SELECT EMP_ID, EMP_NAME, PERFORMANCE_SCORE, REVIEW_DATE FROM ' || '{{ ref('challenge_109_01') }}' || ' WHERE department = \'' || :DEPARTMENT || '\'');
BEGIN
  execute immediate sql1;
  res := (execute immediate sql1);
  RETURN TABLE(res);
END;
$$

;
{% endset %}
{% do run_query(sql) %}
{% endif %}

{% if var('ch109', var('run_all', false)) and not var('cleanup',false) %}

WITH
    outputs AS (
        SELECT *
        FROM TABLE(get_employee_performance_by_department('Sales'))
    )

SELECT * FROM outputs

{% else %}
    SELECT 'ch109 not enabled' AS challenge_status
{% endif %}


{% if execute 
    and var('ch109', var('run_all', false)) 
    and var('cleanup', false) %}
{% set sql %}
drop procedure if exists {{ target.database }}.{{ target.schema }}.get_employee_performance_by_department();
{% endset %}
{% do run_query(sql) %}
{% endif %}
