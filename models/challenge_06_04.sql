{{
  config(
    materialized = 'view',
    )
}}


WITH constituencies AS (
    SELECT * FROM {{ ref('challenge_06_03b') }}
),

nation_or_region_name AS (
    SELECT * FROM {{ ref('challenge_06_02b') }}
),

final AS (
    SELECT
        nation_or_region_name.nation_or_region_name::varchar(50) AS nation_or_region,
        count(*) AS intersecting_constituencies
    FROM nation_or_region_name
        CROSS JOIN constituencies
    WHERE st_intersects(
        nation_or_region_name.polygon_,
        constituencies.polygon_
    )
    GROUP BY 1
)

SELECT * FROM final
