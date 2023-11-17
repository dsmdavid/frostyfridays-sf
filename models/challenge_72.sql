{{
  config(
    materialized = 'table'
    )
}}
-- this file is just creating the file in the stage and the base table 
-- for challenge_72, instead of using the file in the original stage
{% if execute and var('ch72', var('run_all', false)) %}

{% set stage_name = 'dvd_frosty_fridays_72' %}
{% set stage_additional_info = "file_format=(type=csv field_delimiter=',')" %} -- noqa: L016
{{ create_stage(
        database = target.database,
        schema = target.schema,
        name = stage_name,
        additional_info = stage_additional_info) }}

{% set copy_query %}COPY INTO @{{ stage_name }}/execute_me.sql
FROM 
  (
    SELECT $$ INSERT INTO {{ this }} (EmployeeID, FirstName, LastName, DateOfBirth, Position) 
  VALUES 
  (1, 'John', 'Doe', '1985-07-24', 'Software Engineer'),
  (2, 'Jane', 'Smith', '1990-04-12', 'Project Manager'),
  (3, 'Emily', 'Jones', '1992-11-08', 'Graphic Designer'),
  (4, 'Michael', 'Brown', '1988-01-15', 'System Administrator')$$
  )
FILE_FORMAT = (TYPE = CSV
FIELD_DELIMITER = '\0'
RECORD_DELIMITER = ';'
COMPRESSION=NONE
)
OVERWRITE = TRUE
SINGLE = TRUE;
{% endset %}
{% do run_query(copy_query) %}

{% endif %}
-- create the skeleton of the table
SELECT
    1000 AS employeeid,
    'first_name'::varchar(100) AS firstname,
    'last_name'::varchar(100) AS lastname,
    '1900-01-01'::date AS dateofbirth,
    'current position'::varchar(100) AS position
WHERE
    employeeid IS NULL
