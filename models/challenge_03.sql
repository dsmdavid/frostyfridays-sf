{{
  config(
    materialized = 'view'
 )
}}
{% set stage_name = 'dvd_frosty_fridays_03' %}
{% set stage_additional_info = "url='s3://frostyfridaychallenges/challenge_3/' file_format=(type=csv)" %}

{%- if execute %}
  {{ create_stage(
        database = target.database,
        schema = target.schema,
        name = stage_name,
        additional_info = stage_additional_info) }}
    
  {% do run_query("list @" ~ stage_name  ) %}
  {% set query_id_res = run_query("select last_query_id()") %}
  {% set query_id = query_id_res.columns[0].values()[0] %}

{% else %}
  {% set query_id = 'dummy' %}
{% endif %}

with lq as (
  select * from table(
    result_scan('{{ query_id }}')
    )
),
kws as (
  select $1 as kw
  from @{{stage_name}}
  where metadata$filename ilike '%keywords.csv')
select lq.* 
from lq 
cross join kws
where lq."name" ilike '%'||kws.kw||'%'

