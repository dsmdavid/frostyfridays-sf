--- depends on  {{ ref('challenge_65') }}
{{-
  config(
    materialized = 'view',
    pre_hook = '{{ ch_67_create_function() }}'

 )
-}}


{%- if execute and var('ch67', var('run_all', false)) -%}
-- start
WITH
    input_ AS (
    SELECT
        * EXCLUDE func_icon,
        ch67_object(patent_type, application_date, document_publication_date) AS object_as_output,
        object_as_output['inside_of_projection'] as inside_of_projection
    FROM {{ ref('challenge_65') }}
)

    SELECT * FROM input_
{%- else -%}
    SELECT 'var_ch_67_not_enabled' AS cause
{% endif %}
