{{
  config(
    materialized = 'view',
    )
}}

select
  object_construct_keep_null(*) as superhero_json
from {{ ref('challenge_14_01') }}