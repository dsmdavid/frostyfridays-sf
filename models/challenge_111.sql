{{
  config(
    materialized = 'view'
 )
}}
-- noqa: disable=AL03,LT05,LT09
WITH
    quotes AS (
        SELECT 'Better three hours too soon than a minute too late.' AS quote
        UNION ALL
        SELECT
            'My words fly up, my thoughts remain below. Words without thoughts never to heaven go.'
        UNION ALL
        SELECT 'Brevity is the soul of wit.'
        UNION ALL
        SELECT
            'Love looks not with the eyes, but with the mind; and therefore is winged Cupid painted blind'
        UNION ALL
        SELECT 'Suit the action to the word, the word to the action.'
        UNION ALL
        SELECT 'No legacy is so rich as honesty.'
        UNION ALL
        SELECT 'All that glitters is not gold.'
        UNION ALL
        SELECT 'Love all, trust a few, do wrong to none.'
        UNION ALL
        SELECT
            'Our doubts are traitors and make us lose the good we oft might win by fearing to attempt.'
        UNION ALL
        SELECT
            'Some are born great, some achieve greatness, and some have greatness thrust upon them'
        UNION ALL
        SELECT 'To be or not to be: that is the question'
        UNION ALL
        SELECT 'All the world’s a stage'
        UNION ALL
        SELECT 'What, my dear Lady Disdain! Are you yet living?'
        UNION ALL
        SELECT 'If music be the food of love, play on'
        UNION ALL
        SELECT 'I cannot tell what the dickens his name is'
        UNION ALL
        SELECT 'Shall I compare thee to a summer’s day?'
        UNION ALL
        SELECT 'What’s in a name? A rose by any name would smell as sweet'
        UNION ALL
        SELECT 'A horse! A horse! My kingdom for a horse!'
    )

SELECT
    quote,
    search(quote, 'love') AS is_this_love
FROM quotes
