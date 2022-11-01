{{
  config(
    materialized = 'view',
    )
}}
WITH base AS (
        SELECT * FROM {{ ref('challenge_14_01') }}
),

superpowers AS (
    SELECT
        country_of_residence,
        superhero_name,
        notable_exploits,
        array_construct_compact(
            superpower,
            second_superpower,
            third_superpower)
        AS superpowers
    FROM base
)

SELECT to_json(
    object_construct_keep_null(*)
    ) AS superhero_json
FROM superpowers
