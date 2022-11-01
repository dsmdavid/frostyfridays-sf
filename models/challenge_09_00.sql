{{
  config(
    materialized = 'table',
    pre_hook=[ '{{ init_challenge_09() }}'],
    post_hook=['use role {{ target.role }};']
 )
}}

SELECT 'dummy'::varchar AS dummy
