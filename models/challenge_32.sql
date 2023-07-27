{{
  config(
    materialized = 'view',
    pre_hook=[ '{{ init_challenge_32() }}'],
    post_hook=['{{ clean_up_32() }}']
    )
}}

SELECT * FROM {{ source('snowflake', 'session_policies') }}
WHERE schema = '{{ target.schema | upper }}'
    AND database = '{{ target.database | upper }}'
    AND name ILIKE '%ff%'
