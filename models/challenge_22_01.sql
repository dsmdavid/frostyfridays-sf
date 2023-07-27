{{ config(
    materialized = 'table',
    post_hook = '{% do run_query("alter table " ~ this ~ " add row access policy " ~ target.database ~ "." ~ target.schema ~ ".rls_challenge_22 on (id)") %}'
   ) 
}}  --noqa: disable=L016
{{ log("alter table " ~ this ~ "add row access policy " ~ target.database ~ "." ~ target.schema ~ ".rls_challenge_22 on (id)", info=TRUE) }}

{% set stage_name = 'dvd_frosty_fridays_22' %}
{% set stage_additional_info = "url='s3://frostyfridaychallenges/challenge_22/' file_format=(  type = csv field_delimiter = ',' field_optionally_enclosed_by = '\"' skip_header = 1)" %} -- noqa: L016
{%- if execute and var('ch22', var('run_all', false)) %}
{{ init_challenge_22() }}

{{ create_stage( 
    database = target.database,
    schema = target.schema, 
    name = stage_name, 
    additional_info = stage_additional_info) }}
{% endif %}
WITH staged AS (
    SELECT
        t.$1::int AS id,
        t.$2::varchar(50) AS city,
        t.$3::int AS district,
        uuid_string() AS uuid
    FROM @{{ stage_name }} (PATTERN => '.*sales_areas.*') AS t
)

SELECT *
FROM staged
