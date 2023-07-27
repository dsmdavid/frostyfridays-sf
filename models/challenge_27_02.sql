{{
  config(
    materialized = 'view',
    )
}}

SELECT
  * EXCLUDE (milktype) RENAME(icecreambrandowner AS ice_cream_brand_owner)
FROM {{ ref('challenge_27_01') }}
