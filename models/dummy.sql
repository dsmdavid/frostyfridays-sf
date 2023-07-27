{{
  config(
    materialized = 'table',
    full_refresh = True
    )
}}
select 1 as dummy