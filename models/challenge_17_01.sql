{{
  config(
    materialized = 'table',
    )
}}

--
WITH brooklyn AS (
    SELECT
        name,
        geo
    FROM {{ source('marketplace_map', 'V_OSM_NY_BOUNDARY') }}
    WHERE name = 'Brooklyn'
),

nodes AS (
    SELECT
        id,
        coordinates
    FROM {{ source('marketplace_map', 'V_OSM_NY_AMENITY_OTHERS') }}
),

central_points AS (
    -- only nodes Inside brooklyn
    SELECT
        nodes.id,
        nodes.coordinates
    FROM nodes
        CROSS JOIN brooklyn
    WHERE st_dwithin(brooklyn.geo, nodes.coordinates, 0)
),

within_dist_brooklyn AS (
    -- only nodes within 750 of Brooklyn's boundary
    -- to limit items in the next xjoin
    SELECT
        nodes.id,
        nodes.coordinates
    FROM nodes
        CROSS JOIN brooklyn
    WHERE st_dwithin(brooklyn.geo, nodes.coordinates, 750)
),

within_dist AS (
    -- get all the points that are closer to the central point
    -- than the specified distance
    SELECT
        central_points.id,
        central_points.coordinates,
        nodes.id AS child_id,
        nodes.coordinates AS child_coordinates,
        st_distance(central_points.coordinates, child_coordinates) AS dist_meters

    FROM central_points
        LEFT JOIN within_dist_brooklyn AS nodes ON
            st_dwithin(nodes.coordinates, central_points.coordinates, 750)
)

SELECT * FROM within_dist
