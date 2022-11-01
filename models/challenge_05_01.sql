{{
  config(
    materialized = 'view',
    pre_hook=["
create or replace function {{ target.database }}.{{ target.schema }}.timesthree(i int)
returns int
language python
runtime_version = '3.8'
handler = 'times_three_py'
as
$$
def times_three_py(i):
  return i*3
$$;"]
 )
}}

SELECT
    start_int,
    timesthree(start_int) AS times_three
FROM {{ ref('challenge_05') }}
