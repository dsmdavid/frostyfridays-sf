
{% macro safe_drop_36(ch36, database, schema, table_name) %}
{{ log( 'Trying to drop object ***.***.' ~ table_name, info = True)}}

-- set queries:
{% set has_dependants_query %}
    SELECT EXISTS (SELECT 1 FROM SNOWFLAKE.ACCOUNT_USAGE.OBJECT_DEPENDENCIES
    WHERE REFERENCED_DATABASE = '{{ database }}'
    AND REFERENCED_SCHEMA = '{{ schema | upper }}'
    AND REFERENCED_OBJECT_NAME = '{{ table_name | upper }}');
{% endset %}

{% set get_object_type %}
    SELECT table_type FROM SNOWFLAKE.ACCOUNT_USAGE.TABLES
    WHERE TABLE_NAME = '{{ table_name | upper }}'
    AND TABLE_SCHEMA = '{{ schema | upper }}'
    AND table_catalog = '{{ database }}'
    AND deleted IS NULL
    LIMIT 1; --there should be 1 anyway
{% endset %}


{% if execute and var('ch36', false) %}
    {{ log('Running query for safe_drop challenge_36', info=True)}}

    {% set results_query = run_query(has_dependants_query) %}
    {% set has_dependants = results_query.columns[0].values()[0] %}
    {{ log('Does object have dependants? ' ~ has_dependants, info = True) }}

    {% if not has_dependants %}
    {{ log('No dependants found.\n Attempting to drop.', info = True) }}

    -- what type is this? Table? View?...
    {% set results_query = run_query(get_object_type) %}
    {% set table_type = results_query.columns[0].values()[0] %}
        {% if table_type == 'BASE TABLE' %}{% set table_type = 'TABLE' %} {% endif %}
    {% set drop_query %}
        DROP {{ table_type }} IF EXISTS {{ database }}.{{ schema }}. {{ table_name }};
    {% endset %}
    {% set results_query = run_query(drop_query) %}
    {{ log(results_query.columns[0].values()[0], info = True) }}
    {% else %}
    {{ log('Could not drop ' ~ database ~ '.' ~ schema ~ '.' ~ table_name ~ ' --there are objects depending on this.', info = True)}}
    {% endif %}
{% else %}
  {{ log('Query for safe_drop challenge_36 did not run', info=True)}}
  {{ log(var('ch36',false), info=True) }}
{% endif %}

{% endmacro %}