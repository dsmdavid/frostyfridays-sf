{{
  config(
    materialized = 'table',
    )
}}

--
WITH morethanthree AS (
    SELECT id
    FROM {{ ref('challenge_17_01') }}
    GROUP BY 1
    HAVING count(*) > 3
),

boxes AS (
    SELECT
        m.id,
        st_envelope(st_collect(child_coordinates)) AS bounding_box
    FROM morethanthree AS m
        LEFT JOIN {{ ref('challenge_17_01') }} AS n
            ON m.id = n.id
    GROUP BY 1
)

SELECT st_aswkt(st_collect(bounding_box)) AS multipolygon
FROM boxes
