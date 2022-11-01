{{
  config(
    materialized = 'view'
 )
}}
{% set stage_name = 'dvd_frosty_fridays_04' %}
{% set stage_additional_info = "url='s3://frostyfridaychallenges/challenge_4/' file_format=(type=json strip_outer_array=True)" %}

{%- if execute %}
{{ create_stage(
        database = target.database,
        schema = target.schema,
        name = stage_name,
        additional_info = stage_additional_info) }}
{% endif %}


WITH input_ AS (
    SELECT $1 AS value FROM @{{ stage_name }}
),

temp AS (
    SELECT
        o_r.value:Era::varchar AS era,
        h.index AS house_index,
        h.value:"House"::varchar AS house_name,
        m.index AS monarch_index,
        m.value AS monarchs,
        array_to_string(object_keys(monarchs), ',') AS keys
    FROM input_ AS o_r,
        LATERAL flatten(o_r.value:Houses) AS h,
        LATERAL flatten(h.value:Monarchs) AS m
)

SELECT * FROM temp
