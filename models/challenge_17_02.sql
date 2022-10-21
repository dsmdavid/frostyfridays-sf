{{
  config(
    materialized = 'table',
    )
}}

--
with morethanthree as (
    select id 
    from {{ ref('challenge_17_01') }} 
    group by 1
    having count(*) > 3
),
boxes as (
    select 
        m.id,
        st_envelope(st_collect(child_coordinates)) as bounding_box
    from morethanthree as m
    left join {{ ref('challenge_17_01') }} as n 
        on m.id = n.id
    group by 1
    )
select 
ST_ASWKT(    st_collect(bounding_box) ) as multipolygon
from boxes
