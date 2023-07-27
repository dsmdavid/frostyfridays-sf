{{
  config(
    materialized = 'incremental'
 )
}}
-- select from query history
-- objects that use tags
-- when the tag is 'Level Super Secret A+++++++'
{%- set now = run_query('select current_timestamp()') %}
WITH base AS (
    SELECT
        ah.query_id,
        boa.value:"objectName"::varchar AS object_name,
        boa.value:"objectId" AS object_id
    FROM
        {{ source('account_usage', 'access_history') }} AS ah,
        LATERAL flatten(base_objects_accessed) AS boa
),

final AS (
    SELECT
        tag_r.tag_name,
        tag_r.tag_value,
        base.object_name AS table_name,
        query_h.role_name,
        min(base.query_id) AS min_query_id
    FROM base
        LEFT JOIN {{ source('account_usage', 'tag_references') }} AS tag_r
            ON base.object_id = tag_r.object_id
        LEFT JOIN {{ source('account_usage', 'query_history') }} AS query_h
            ON base.query_id = query_h.query_id
    WHERE tag_r.tag_value = 'Level Super Secret A+++++++'
    GROUP BY 1, 2, 3, 4
    LIMIT 100
)

SELECT
    *,
    {%- if execute and var('ch07', var('run_all', false)) %}
    '{{ now.columns[0].values()[0] }}' AS run_at
    {% else %}
    1 AS dummy
    {% endif %}
FROM final
