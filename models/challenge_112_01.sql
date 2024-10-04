{{
  config(
    materialized = 'view'
 )
}}
-- noqa: disable=AL03
WITH
    raw_data AS (
        SELECT
            'Americas' AS region,
            'Atlanta' AS city,
            '2024-10-03' AS event_date,
            TO_GEOGRAPHY('POINT(-84.3880 33.7490)') AS geo_point
        UNION ALL
        SELECT
            'Americas',
            'Bogotá',
            '2024-10-30',
            TO_GEOGRAPHY('POINT(-74.0721 4.7110)')
        UNION ALL
        SELECT
            'Americas',
            'Chicago',
            '2024-11-04',
            TO_GEOGRAPHY('POINT(-87.6298 41.8781)')
        UNION ALL
        SELECT
            'Americas',
            'Dallas',
            '2024-10-01',
            TO_GEOGRAPHY('POINT(-96.7970 32.7767)')
        UNION ALL
        SELECT
            'Americas',
            'Mexico City',
            '2024-10-24',
            TO_GEOGRAPHY('POINT(-99.1332 19.4326)')
        UNION ALL
        SELECT
            'Americas',
            'New York City',
            '2024-10-15',
            TO_GEOGRAPHY('POINT(-74.0060 40.7128)')
        UNION ALL
        SELECT
            'Americas',
            'São Paulo',
            '2024-10-08',
            TO_GEOGRAPHY('POINT(-46.6333 -23.5505)')
        UNION ALL
        SELECT
            'Americas',
            'Toronto',
            '2024-10-21',
            TO_GEOGRAPHY('POINT(-79.347015 43.651070)')

        UNION ALL
        SELECT
            'EMEA',
            'Amsterdam',
            '2024-10-03',
            TO_GEOGRAPHY('POINT(4.9041 52.3676)')
        UNION ALL
        SELECT
            'EMEA',
            'Berlin',
            '2024-10-16',
            TO_GEOGRAPHY('POINT(13.4050 52.5200)')
        UNION ALL
        SELECT
            'EMEA',
            'London',
            '2024-10-10',
            TO_GEOGRAPHY('POINT(-0.1278 51.5074)')
        UNION ALL
        SELECT
            'EMEA',
            'Paris',
            '2024-10-01',
            TO_GEOGRAPHY('POINT(2.3522 48.8566)')
        UNION ALL
        SELECT
            'EMEA',
            'Stockholm',
            '2024-10-17',
            TO_GEOGRAPHY('POINT(18.0686 59.3293)')

        UNION ALL
        SELECT
            'APJ',
            'Kuala Lumpur',
            '2024-10-23',
            TO_GEOGRAPHY('POINT(101.6869 3.1390)')
        UNION ALL
        SELECT
            'APJ',
            'Mumbai',
            '2024-10-04',
            TO_GEOGRAPHY('POINT(72.8777 19.0760)')
        UNION ALL
        SELECT
            'APJ',
            'Auckland',
            '2024-10-24',
            TO_GEOGRAPHY('POINT(174.7633 -36.8485)')
        UNION ALL
        SELECT
            'APJ',
            'Manila',
            '2024-10-02',
            TO_GEOGRAPHY('POINT(120.9842 14.5995)')
        UNION ALL
        SELECT
            'APJ',
            'Sydney',
            '2024-10-29',
            TO_GEOGRAPHY('POINT(151.2093 -33.8688)')
    ),
    /* had to read this to learn how to sort the vertices
    https://blogs.sas.com/content/iml/2021/11/17/order-vertices-convex-polygon.html --noqa: disable=LT05
    the tl;dr is
    find the centroid of the polygon,
    sort asc by angle formed between point, centroid, and reference point
    */

    get_centroids AS (
        SELECT
            region,
            ST_CENTROID(ST_COLLECT(geo_point)) AS centroid,
            ST_X(centroid) AS centroid_longitude,
            ST_Y(centroid) AS centroid_latitude
        FROM raw_data
        GROUP BY region
    ),

    get_angles AS (
        SELECT
            points.*,
            ST_AZIMUTH(points.geo_point, get_centroids.centroid) AS angle
        FROM raw_data AS points
            LEFT JOIN get_centroids
                ON points.region = get_centroids.region
    ),

    loop_points AS (
        SELECT
            *,
            ROW_NUMBER()
                OVER (PARTITION BY region ORDER BY angle)
                AS point_position
        FROM get_angles
        UNION ALL
        SELECT
            *,
            999 AS point_position
        FROM get_angles
        QUALIFY ROW_NUMBER() OVER (PARTITION BY region ORDER BY angle) = 1
    ),

    get_polygon AS (
        SELECT
            region,
            ST_MAKEPOLYGON(
                TO_GEOGRAPHY(
                    'LINESTRING('
                    || LISTAGG(ST_X(geo_point) || ' ' || ST_Y(geo_point), ',')
                    WITHIN GROUP (ORDER BY point_position)
                    || ')'
                )
            ) AS polygon

        FROM loop_points
        GROUP BY region
    )

SELECT ST_COLLECT(polygon) AS geography_collection FROM get_polygon
