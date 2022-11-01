-- depends on {{ ref('challenge_19_02') }}
{{
  config(
    materialized = 'view',
    )
}}

WITH base AS (
    SELECT
        1 AS id,
        '11/11/2020' AS start_date,
        '9/3/2022' AS end_date
    UNION ALL
    SELECT
        2,
        '12/8/2020',
        '1/19/2022'
    UNION ALL
    SELECT
        3,
        '12/24/2020',
        '1/15/2022'
    UNION ALL
    SELECT
        4,
        '12/5/2020',
        '3/3/2022'
    UNION ALL
    SELECT
        5,
        '12/24/2020',
        '6/20/2022'
    UNION ALL
    SELECT
        6,
        '12/24/2020',
        '5/19/2022'
    UNION ALL
    SELECT
        7,
        '12/31/2020',
        '5/6/2022'
    UNION ALL
    SELECT
        8,
        '12/4/2020',
        '9/16/2022'
    UNION ALL
    SELECT
        9,
        '11/27/2020',
        '4/14/2022'
    UNION ALL
    SELECT
        10,
        '11/20/2020',
        '1/18/2022'
    UNION ALL
    SELECT
        11,
        '12/1/2020',
        '3/31/2022'
    UNION ALL
    SELECT
        12,
        '11/30/2020',
        '7/5/2022'
    UNION ALL
    SELECT
        13,
        '11/28/2020',
        '6/19/2022'
    UNION ALL
    SELECT
        14,
        '12/21/2020',
        '9/7/2022'
    UNION ALL
    SELECT
        15,
        '12/13/2020',
        '8/15/2022'
    UNION ALL
    SELECT
        16,
        '11/4/2020',
        '3/22/2022'
    UNION ALL
    SELECT
        17,
        '12/24/2020',
        '8/29/2022'
    UNION ALL
    SELECT
        18,
        '11/29/2020',
        '10/13/2022'
    UNION ALL
    SELECT
        19,
        '12/10/2020',
        '7/31/2022'
    UNION ALL
    SELECT
        20,
        '11/1/2020',
        '10/23/2021'
)

SELECT
    id,
    start_date,
    end_date,
    test_db.dvd_frosty_fridays.WORKING_DAYS(start_date, end_date, false) AS excluding,
    test_db.dvd_frosty_fridays.WORKING_DAYS(start_date, end_date, true) AS including
FROM base
