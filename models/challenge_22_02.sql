{{ config(
    materialized = 'view',
    secure = 'true'
   ) 
}}  

WITH staged AS (
    SELECT
        uuid AS id,
        city,
        district
    FROM {{ ref('challenge_22_01') }}
)

SELECT *
FROM staged
