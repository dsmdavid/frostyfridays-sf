{{
  config(
    materialized = 'incremental'
 )
}}
-- select from query history
-- objects that use tags
-- when the tag is 'Level Super Secret A+++++++'
{%- set now = run_query('select current_timestamp()') %}
with base as (
select
    ah.query_id,
    boa.value:"objectName"::varchar as object_name,
    boa.value:"objectId" as object_id
from {{ source('account_usage', 'access_history') }} as ah, lateral flatten(BASE_OBJECTS_ACCESSED) as boa
),
final as (
select 
    tag_r.tag_name,
    tag_r.tag_value,
    base.object_name as table_name,
    query_h.role_name,
    min(base.query_id) as min_query_id
from base
left join {{ source('account_usage', 'tag_references') }} as tag_r
    on base.object_id = tag_r.object_id
left join {{ source('account_usage', 'query_history') }} as query_h
    on base.query_id = query_h.query_id
where tag_r.tag_value = 'Level Super Secret A+++++++'
group by 1,2,3,4
limit 100)
select
    *,
    {% if execute %}
    '{{ now.columns[0].values()[0] }}' as run_at
    {% endif %}
from final