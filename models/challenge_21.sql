{{
  config(
    materialized = 'view',
    )
}}
-- noqa: disable=L042
WITH raw_input AS (
    SELECT * FROM VALUES ('The Impossible Guard', '++', '-', '-', '-', '-', '-', '-', '+'),
        ('The Clever Daggers', '-', '+', '-', '-', '-', '-', '-', '++'),
        ('The Quick Jackal', '+', '-', '++', '-', '-', '-', '-', '-'),
        ('The Steel Spy', '-', '++', '-', '-', '+', '-', '-', '-'),
        ('Agent Thundering Sage', '++', '+', '-', '-', '-', '-', '-', '-'),
        ('Mister Unarmed Genius', '-', '-', '-', '-', '-', '-', '-', '-'),
        ('Doctor Galactic Spectacle', '-', '-', '-', '++', '-', '-', '-', '+'),
        ('Master Rapid Illusionist', '-', '-', '-', '-', '++', '-', '+', '-'),
        ('Galactic Gargoyle', '+', '-', '-', '-', '-', '-', '++', '-'),
        (
            'Alley Cat', '-', '++', '-', '-', '-', '-', '-', '+'
        ) AS v (
            hero_name,
            flight,
            laser_eyes,
            invisibility,
            invincibility,
            psychic,
            magic,
            super_speed,
            super_strength
        )
    ),


    input AS (
        SELECT
            row_number() OVER (ORDER BY null) AS rn,
            *
        FROM raw_input
    ),

    superpowers AS (
        SELECT * FROM input
            UNPIVOT(
                superpower FOR power IN(
                    flight,
                    laser_eyes,
                    invisibility,
                    invincibility,
                    psychic,
                    magic,
                    super_speed,
                    super_strength
                )
            )
        WHERE superpower != '-'
    ),

    pivoted AS (
        SELECT
            hero_name,
            "'++'" AS main_power, --noqa: L057
            "'+'" AS secondary_power, --noqa: L057
            rn
        FROM superpowers
            PIVOT(listagg(power) FOR superpower IN ('++', '+'))
    )

SELECT * FROM pivoted
ORDER BY rn
