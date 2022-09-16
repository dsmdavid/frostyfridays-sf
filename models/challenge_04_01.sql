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


with input_ as (
select $1 as value from @{{stage_name}}),
temp as (
select 
    o_r.value:Era::varchar as era,
    h.index as house_index,
    h.value:"House"::varchar as house_name,
    m.index as monarch_index,
    m.value as monarchs,
    array_to_string(object_keys(monarchs),',') as keys
    from input_ as o_r,
    lateral flatten (o_r.value:Houses) as h
    ,   lateral flatten (h.value:Monarchs) as m
    )
    select * from temp
