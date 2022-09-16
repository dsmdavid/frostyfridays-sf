{{
  config(
    materialized = 'view',
    )
}}
with base as (
  select * from {{ ref('challenge_14_01') }}
),
superpowers as (
   select 
    country_of_residence,
    superhero_name,
    notable_exploits,
    array_construct_compact( superpower,
    second_superpower,
    third_superpower) as superpowers
   from base
)
select
  to_json(
    object_construct_keep_null(*)
   ) as superhero_json
from superpowers