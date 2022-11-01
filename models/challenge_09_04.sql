-- depends on: {{ ref('challenge_09_00') }}
{{
  config(
    materialized = 'table',
    pre_hook=[" use role {{ target.role }};" ]
 )
}}
{% set roles = [1,2,3] %}
WITH -- noqa: L018
{%- for role in roles %}

    role_{{ role }} AS (
        SELECT
            *,
            'role_{{ role }}' AS role_
        FROM {{ ref('challenge_09_0' ~ (role|string)) }}

    ){% if not loop.last %}, {% endif %}-- noqa: L018
{%- endfor -%}

{%- for role in roles %}
SELECT * FROM role_{{ role }}
{%- if not loop.last %}
UNION ALL
{%- endif %}
{%- endfor %}

-- end block
