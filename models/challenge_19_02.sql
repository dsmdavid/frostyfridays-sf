--depends on {{ ref('challenge_19')}}
{{
  config(
    materialized = 'view',
    )
}}

select 
    test_db.dvd_frosty_fridays.WORKING_DAYS('2020-11-2', '2020-11-6', false) as excluding,
    test_db.dvd_frosty_fridays.WORKING_DAYS('2020-11-2', '2020-11-6', TRUE) as including
