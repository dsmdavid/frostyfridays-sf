--depends on {{ ref('challenge_19') }}
{{
  config(
    materialized = 'view',
    )
}}

SELECT
    test_db.dvd_frosty_fridays.WORKING_DAYS('2020-11-2', '2020-11-6', false) AS excluding,
    test_db.dvd_frosty_fridays.WORKING_DAYS('2020-11-2', '2020-11-6', true) AS including
