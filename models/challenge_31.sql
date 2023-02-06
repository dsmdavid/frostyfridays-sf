{{
  config(
    materialized = 'view',
    )
}}
-- noqa: disable=L016,L042
WITH source_data AS (
    SELECT
        t.$1 AS id,
        t.$2 AS hero_name,
        t.$3 AS villains_defeated
    FROM VALUES
        (1, 'Pigman', 5),
        (2, 'The OX', 10),
        (3, 'Zaranine', 4),
        (4, 'Frostus', 8),
        (5, 'Fridayus', 1),
        (6, 'SheFrost', 13),
        (7, 'Dezzin', 2.3),
        (8, 'Orn', 7),
        (9, 'Killder', 6),
        (10, 'PolarBeast', 11)
        AS t
)

SELECT
    min_by(hero_name, villains_defeated) AS worst_hero,
    max_by(hero_name, villains_defeated) AS best_hero
FROM source_data
