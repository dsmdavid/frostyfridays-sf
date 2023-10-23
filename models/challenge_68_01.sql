{{
  config(
    materialized = 'view',
    )
}}

-- this is a step needed to bring the data 

-- creating the stage
{% set stage_name = 'dvd_frosty_fridays_68_raw' %}
{% set stage_additional_info = "url = 's3://frostyfridaychallenges/challenge_68/' file_format = (type = json strip_outer_array=True)" %}  --noqa: LT05
{% if execute and var('ch68', var('run_all', false)) %}
{{ create_stage(
        database = target.database,
        schema = target.schema,
        name = stage_name,
        additional_info = stage_additional_info) }}
{% endif %}

{% if execute and var('ch68', var('run_all', false)) %}
    with input_ as (
        select $1 as val from @{{ stage_name }}
        )
        select 
            val:country::varchar as country,
            val:pop2023::number as population
        from input_
{% else %}
    SELECT 'raw_data not created, use var ch68 to enable it.' AS output_
{% endif %}
