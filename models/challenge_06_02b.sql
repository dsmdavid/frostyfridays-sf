{{
  config(
    materialized = 'view',
    )
}}


with prep as (
    select
        *,
        (longitude || ' ' || latitude)::varchar(25) as point_text,
        max(sequence_num::int) over (partition by
             nation_or_region_name,
             part
             ) as n_seq
    from {{ ref('challenge_06_02') }}
),
-- ST_MAKEPOLYGON: A GEOGRAPHY object that represents a LineString
-- in which the last point is the same as the first (i.e. a loop).
-- --> therefore, the first point must be added at the end.
all_points as (
select
    *,
    sequence_num::int as new_seq from prep
union all
    select
    *,
    n_seq+1 as new_seq 
    from prep
    where sequence_num::int = 0
),
polygons as (
    select 
    nation_or_region_name::varchar(50) as nation_or_region_name,
    part,
    listagg(point_text,',') as agg_points,
    st_makepolygon(
    to_geography('LINESTRING(' || agg_points || ')')) as polygon_

    from all_points
    where 1 =1 
    group by 1,2),
final as (
    select 
        nation_or_region_name,
        st_collect(polygon_) as polygon_
from polygons
group by 1
)
select * from final