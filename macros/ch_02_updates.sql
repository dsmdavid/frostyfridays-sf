{% macro ch02updates() %}

{% set sql_statement %}
UPDATE challenge_02 SET COUNTRY = 'Japan' WHERE EMPLOYEE_ID = 8;
UPDATE challenge_02 SET LAST_NAME = 'Forester' WHERE EMPLOYEE_ID = 22;
UPDATE challenge_02 SET DEPT = 'Marketing' WHERE EMPLOYEE_ID = 25;
UPDATE challenge_02 SET TITLE = 'Ms' WHERE EMPLOYEE_ID = 32;
UPDATE challenge_02 SET JOB_TITLE = 'Senior Financial Analyst' WHERE EMPLOYEE_ID = 68;
{% endset %}
{% do run_query(sql_statement) %}
{% endmacro %}