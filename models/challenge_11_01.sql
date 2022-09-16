{{
  config(
    materialized = 'view'
  )
}}
with base as (
  select * from {{ ref('challenge_11') }}
)
select
  task_used,
  count(*) as n_rows
from base
group by 1
order by 2 desc