{{
  config(
    materialized = 'view',
    pre_hook=[],
    post_hook=[]
    )
}}
{# set stage and file formats #}
{% set stage_name = 'dvd_frosty_fridays_53' %}
{% set stage_additional_info = "file_format=(type=csv SKIP_HEADER =1
field_optionally_enclosed_by = '\"'
)" %} -- noqa: L016
{% set file_format_name = stage_name ~ '_csv' %}




{% if execute and var('ch53', var('run_all', false)) %}

    /* Create the stage, then the file format, then the actual model */
    {# create the stage #}
        {{ create_stage(
                database = target.database,
                schema = target.schema,
                name = stage_name,
                additional_info = stage_additional_info) }}

        {% set string_comment = "The stage has been created, but the file must be put into the stage outside dbt using something like:\n\tput 'file:///path/to/file/employees.csv' @stage_name;"
        %}
        {{ log( string_comment, info=True) }}
    {# Create a file format with a name so that we can use infer_schema 
        as it doesn't seem to accept the schema defined at the stage level
    #}
        {% set create_format_query %}
        create or replace file format {{ file_format_name }}
        field_optionally_enclosed_by = '"'
        skip_header = 1;
        {% endset %}
        {% set file_format_status = run_query(create_format_query) %}
        {{ log(file_format_status.columns[0].values()[0] , info=True) }}

    {# Actual query for the model #}
SELECT *
  FROM TABLE(
    INFER_SCHEMA(
      LOCATION=>'@{{ stage_name }}',
      FILE_FORMAT => '{{ stage_name ~ '_csv' }}'
      )
    )

    {% else %}
    SELECT 'Model needs to be ran with activation variables to be created, as there are dependencies in this code, e.g. `dbt run -s challenge_53 --vars `{"ch53":1}`' AS model_status  -- noqa: LT05

{% endif %}
