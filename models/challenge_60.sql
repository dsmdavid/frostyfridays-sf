{{
  config(
    materialized = 'view',
    )
}}
WITH
    input_ AS (
        SELECT $1 AS full_name FROM --noqa: RF04
            VALUES
            ('John Smith'),
            ('Jon Smyth'),
            ('Jane Doe'),
            ('Jan Do'),
            ('Michael Johnson'),
            ('Mike Johnson'),
            ('Sarah Williams'),
            ('Sara Williams'),
            ('Robert Brown'),
            ('Roberto Brown'),
            ('Emily White'),
            ('Emilie Whyte'),
            ('David Lee'),
            ('Davey Li')
    ),

    prep AS (
        SELECT
            full_name,
            row_number() OVER (ORDER BY NULL) AS row_id
        FROM input_
    )

SELECT
    n.row_id AS row_to_check,
    c.row_id AS row_checked_against,

    n.full_name AS name_to_check,
    c.full_name AS name_checked_against,

    soundex(name_to_check) = soundex(name_checked_against) AS sound_similar

FROM prep AS n
    CROSS JOIN prep AS c
WHERE c.row_id > n.row_id
ORDER BY 1, 2
