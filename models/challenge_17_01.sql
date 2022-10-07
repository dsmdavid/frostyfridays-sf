{{
  config(
    materialized = 'table',
    )
}}

--
with brooklyn as (
    select name, geo
    from {{ source('marketplace_map', 'V_OSM_NY_BOUNDARY') }}
    where name ='Brooklyn'
),
nodes as (
    select 
        id,
        coordinates
    from {{ source('marketplace_map', 'V_OSM_NY_AMENITY_OTHERS') }}
),
central_points as (
    -- only nodes Inside brooklyn
    select
        nodes.id,
        nodes.coordinates
    from  nodes
    cross join brooklyn
    where st_dwithin(brooklyn.geo, nodes.coordinates, 0)
    ),
within_dist_brooklyn as (
  -- only nodes within 750 of Brooklyn's boundary
  -- to limit items in the next xjoin
    select
        nodes.id,
        nodes.coordinates
    from  nodes
    cross join brooklyn
    where st_dwithin(brooklyn.geo, nodes.coordinates, 750)
    ),
within_dist as (
    -- get all the points that are closer to the central point
    -- than the specified distance
    select
        central_points.id,
        central_points.coordinates,
        nodes.id as child_id,
        nodes.coordinates as child_coordinates,
        st_distance(central_points.coordinates, child_coordinates) as dist_meters

    from central_points
    left join within_dist_brooklyn as nodes on
        st_dwithin(nodes.coordinates, central_points.coordinates, 750)
)
select * from within_dist