{{
  config(
    materialized = 'view',
 )
}}
--noqa: disable=L057
WITH covid AS (
    SELECT * FROM {{ source('marketplace_covid19_starschema', 'ECDC_GLOBAL') }}
    WHERE last_reported_flag
),

daily_weather AS (
    SELECT * FROM {{ source('marketplace_daily_wheather', 'NOAACD2019R') }}
),

daily_temps AS (
    SELECT * FROM daily_weather
    WHERE "Indicator Name" = 'Mean temperature (Fahrenheit)'
          AND "Measure Name" = 'Value'
),

final AS (

    SELECT
        c.country_region AS country,
        c.date,

        d."Indicator Name",
        d."Value"
    FROM covid AS c
        LEFT JOIN daily_temps AS d
            ON --c.iso3166_1 = d."Country"
                c.country_region = d."Country Name"
                AND c.date = d."Date"
    QUALIFY row_number() OVER (PARTITION BY c.country_region ORDER BY d."Stations Name" DESC) = 1
)

SELECT * FROM final
ORDER BY country ASC
