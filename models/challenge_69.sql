{{
  config(
    materialized = 'view',
    )
}}

WITH
    input_data AS (
        SELECT
            $1 AS string_1,
            $2 AS string_2
        FROM
            VALUES
            ('The cat sat on the', 'The cat sat on thee'),
            ('Rainbows appear after rain', 'Rainbows appears after rain'),
            (
                'She loves chocolate chip cookies',
                'She love chocolate chip cookies'
            ),
            ('Birds fly high in the', 'Birds flies high in the'),
            ('The sun sets in the', 'The sun set in the'),
            ('I really like that song', 'I really liked that song'),
            ('Dogs are truly best friends', 'Dogs are truly best friend'),
            ('Books are a source of', 'Book are a source of'),
            ('The moon shines at night', 'The moons shine at night'),
            ('Walking is good for health', 'Walking is good for the health'),
            ('Children love to play', 'Children love to play'),
            ('Music is a universal language', 'Music is a universal language'),
            ('Winter is coming soon', 'Winter is coming soon'),
            ('Happiness is a choice', 'Happiness is a choice'),
            ('Travel broadens the mind', 'Travel broadens the mind'),
            ('Dogs are our closest companions', 'Cats are solitary creatures'),
            (
                'Books are portals to new worlds',
                'Movies depict various realities'
            ),
            (
                'The moon shines brightly at night',
                'The sun blazes hotly at noon'
            ),
            (
                'Walking is beneficial for health',
                'Running can be hard on knees'
            ),
            ('Children love to play outside', 'Children love to play'),
            (
                'Music transcends cultural boundaries',
                'Music is a universal language'
            ),
            ('Winter is cold and snowy', 'Winter is coming soon'),
            ('Happiness comes from within', 'Happiness is a choice'),
            ('Traveling opens up perspectives', 'Travel broadens the mind')
    )

SELECT
    string_1,
    string_2,
    jarowinkler_similarity(string_1, string_2) AS jarowinkler,
    editdistance(string_1, string_2, 10) AS levenshtein_distance,
    div0null(
        levenshtein_distance,
        greatest(
            1, length(string_1), length(string_2)
        )
    ) AS levenshtein_distance_normalized

FROM input_data
ORDER BY jarowinkler DESC
