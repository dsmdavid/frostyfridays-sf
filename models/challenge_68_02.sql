-- depends on {{ ref('challenge_68_01') }}
{{
  config(
    materialized = 'view',
    )
}}

-- this is a placeholder file to create the streamlit application.
-- steps:
-- 1. create the stage.
-- 2. create the main.py file.
-- 3. dump the main.py file in the stage.
-- 4. create the streamlit object.

-- creating the stage
{% set stage_name = 'dvd_frosty_fridays_68' %}

{% if execute and var('ch68', var('run_all', false)) %}
{{ create_stage(
        database = target.database,
        schema = target.schema,
        name = stage_name,
        additional_info = stage_additional_info) }}
{% endif %}
-- creating the main.py contents
{% set file_contents %}
$$
# Import python packages
import streamlit as st
from snowflake.snowpark.context import get_active_session

session = get_active_session()

# Write directly to the app
st.title("Spanish speaking countries 🇪🇸")
st.write(
    """This is a sample streamlit app built as part of the [Frosty Fridays Challenges](https://frostyfriday.org/blog/2023/10/20/week-68-intermediate/)
    """
)

df_table = session.table("CHALLENGE_68_01")
st.bar_chart(df_table, x= 'COUNTRY', y = 'POPULATION')
$$
{% endset %}

-- copying the main.py file
{% set file_name = 'main.py' %}
{% set copy_query %}
COPY INTO @{{ stage_name }}/{{ file_name }}
   FROM
    (
        SELECT {{ file_contents }}
    )
    FILE_FORMAT = (
            TYPE = CSV
            COMPRESSION =  NONE
            RECORD_DELIMITER = NONE
            FIELD_DELIMITER =  NONE
            FILE_EXTENSION = 'py'
            ESCAPE = NONE
            ESCAPE_UNENCLOSED_FIELD = NONE
            DATE_FORMAT =AUTO
            TIME_FORMAT =  AUTO
            TIMESTAMP_FORMAT = AUTO
            BINARY_FORMAT = UTF8
            FIELD_OPTIONALLY_ENCLOSED_BY =  NONE
            EMPTY_FIELD_AS_NULL = TRUE 
            )

    OVERWRITE = TRUE 
    SINGLE = TRUE 
    INCLUDE_QUERY_ID = FALSE
    DETAILED_OUTPUT = TRUE 
{% endset %}

{% if execute and var('ch68', var('run_all', false)) %}
{% do run_query(copy_query) %}
{% endif %}

-- create the streamlit object
{% set streamlit_query %}
    create or replace streamlit dvd_streamlit_ff68
    root_location = '@{{ target.database }}.{{ target.schema }}.{{ stage_name | upper }}'
    main_file = '/{{ file_name }}'
    query_warehouse = {{ target.warehouse }};
{% endset %}
{% if execute and var('ch68', var('run_all', false)) %}
{% do run_query(streamlit_query) %}
{% endif %}

{% if execute and var('ch68', var('run_all', false)) %}
    SELECT 'streamlit created' AS output_
{% else %}
    SELECT 'streamlit not created, use var ch68 to enable it.' AS output_
{% endif %}
