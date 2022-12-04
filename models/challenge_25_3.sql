{{
  config(
    materialized = 'view',
 )
}}

WITH base AS (
    SELECT * FROM {{ ref('challenge_25_2') }}
),

final AS (
    SELECT
        date(timestamp::timestamp) AS date_,
        array_agg(DISTINCT icon) AS array_icon,
        avg(temperature) AS avg_temperature,
        sum(precipitation) AS total_precipitation,
        avg(wind_speed) AS avg_wind_speed,
        avg(relative_humidity) AS avg_humidity
    FROM base
    GROUP BY 1
    ORDER BY 1 DESC
)

SELECT * FROM final
