{{
  config(
    materialized = 'view',
    )
}}

WITH prep AS (
    SELECT
        *,
        (longitude || ' ' || latitude)::varchar(25) AS point_text,
        max(sequence_num::int) OVER (PARTITION BY
            constituency,
            part
        ) AS n_seq
    FROM {{ ref('challenge_06_03') }}
),

-- ST_MAKEPOLYGON: A GEOGRAPHY object that represents a LineString
-- in which the last point is the same as the first (i.e. a loop).
-- --> therefore, the first point must be added at the end.
all_points AS (
    SELECT
        *,
        sequence_num::int AS new_seq
    FROM prep
    UNION ALL
    SELECT
        *,
        n_seq + 1 AS new_seq
    FROM prep
    WHERE sequence_num::int = 0
),

polygons AS (
    SELECT
        constituency::varchar(50) AS constituency,
        part,
        listagg(point_text, ',') AS agg_points,
        st_makepolygon(
            to_geography('LINESTRING(' || agg_points || ')')) AS polygon_

    FROM all_points
    WHERE 1 = 1
    GROUP BY 1, 2
),

final AS (
    SELECT
        constituency,
        st_collect(polygon_) AS polygon_
    FROM polygons
    GROUP BY 1
)

SELECT * FROM final
