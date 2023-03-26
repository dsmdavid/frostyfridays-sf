{{
  config(
    materialized = 'view',
    pre_hook=[ '{{ init_challenge_35() }}']
    )
}}

SELECT * FROM challenge_35_01
