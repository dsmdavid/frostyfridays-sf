{% macro ch61_post_hooks() %}

{% if execute and var('ch61', var('run_all', false)) %}

--create stage to drop the file into
{% set stage_name = 'dvd_ff_61_share'%}
{% set stage_additional_info = "  encryption = (type = 'SNOWFLAKE_SSE') directory = (enable = TRUE)" %} -- noqa: disable=L016
{{ create_stage(
        database = target.database,
        schema = target.schema,
        name = stage_name,
        additional_info = stage_additional_info) }}



-- copy into stage
{% set file_name = 'ch61_output' %}
{% set copy_sql %}
COPY INTO @{{ stage_name }}/{{ file_name }}
from {{ this }}
FILE_FORMAT = ( TYPE = JSON COMPRESSION=NONE)
OVERWRITE=TRUE;
{% endset %}
{{ log(copy_sql, info=TRUE )}}
{% do run_query(copy_sql) %}


-- get url
{% set getsigned_url__sql %}
SELECT
    get_presigned_url(@{{ stage_name }}, '{{ file_name }}_0_0_0.json', 60)
{% endset %}
{{ log(getsigned_url__sql, info=TRUE )}}
{% set results =  run_query(getsigned_url__sql) %}
{{ log('****\nPresigned_URL:', info=True) }}
{{ log(results.columns[0].values()[0], info=True) }}
{{ log('End of Presigned_URL\n****', info=True) }}

SELECT 'HOOK_RUNNING' AS POST_HOOK_STATUS;
{% else %}
SELECT 'HOOK_NOT_RUNNING' AS POST_HOOK_STATUS;

{% endif %}


{% endmacro %} 