{{
  config(
    materialized = 'view',
    )
}}
-- noqa: disable=L042
SELECT *
FROM (VALUES
    (
        'Superpig',
        'Ireland',
        'Saved head of Irish Farmer\'s Association from terrorist cell',
        'Super-Oinks',
        NULL,
        NULL
    ),
    (
        'Señor Mediocre',
        'Mexico',
        'Defeated corrupt convention of fruit lobbyists by telling anecdote that lasted 33 hours, with 16 tangents that lead to 17 resignations from the board',
        'Public speaking',
        'Stamp collecting',
        'Laser vision'
    ),
    (
        'The CLAW',
        'USA',
        'Horrifically violent duel to the death with mass murdering super villain accidentally created art installation last valued at $14,450,000 by Sotheby\'s',
        'Back scratching',
        'Extendable arms',
        NULL
    ),
    ('Il Segreto', 'Italy', NULL, NULL, NULL, NULL),
    (
        'Frosty Man',
        'UK',
        'Rescued a delegation of data engineers from a DevOps conference',
        'Knows, by memory, 15 definitions of an obscure codex known as "the data mesh"',
        'can copy and paste from StackOverflow with the blink of an eye',
        NULL
    )
      ) AS v (superhero_name,
    country_of_residence,
    notable_exploits,
    superpower,
    second_superpower,
    third_superpower)
