{{
  config(
    materialized = 'view',
    )
}}


with constituencies as (
    select * from {{ ref('challenge_06_03b') }}
),
nation_or_region_name as (
    select * from {{ ref('challenge_06_02b') }}
),
final as (
    select
        nation_or_region_name.nation_or_region_name::varchar(50) as nation_or_region,
        count(*) as intersecting_constituencies
    from nation_or_region_name
    cross join constituencies
    where st_intersects(
        nation_or_region_name.polygon_,
        constituencies.polygon_
    )
    group by 1
)
select * from final
