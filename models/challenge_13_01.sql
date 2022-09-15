{{ config(
  materialized = 'view',
) }}

WITH temp AS (

  SELECT
    'Superhero capes' AS product,
    1 AS stock_amount,
    '2022-01-01' AS date_of_check
  UNION ALL
  SELECT
    'Superhero capes',
    1,
    '2022-01-01'
  UNION ALL
  SELECT
    'Superhero capes',
    2,
    '2022-01-02'
  UNION ALL
  SELECT
    'Superhero capes',
    NULL,
    '2022-02-01'
  UNION ALL
  SELECT
    'Superhero capes',
    NULL,
    '2022-03-01'
  UNION ALL
  SELECT
    'Superhero masks',
    5,
    '2022-01-01'
  UNION ALL
  SELECT
    'Superhero masks',
    NULL,
    '2022-02-13'
  UNION ALL
  SELECT
    'Superhero pants',
    6,
    '2022-01-01'
  UNION ALL
  SELECT
    'Superhero pants',
    NULL,
    '2022-01-01'
  UNION ALL
  SELECT
    'Superhero pants',
    3,
    '2022-04-01'
  UNION ALL
  SELECT
    'Superhero pants',
    2,
    '2022-07-01'
  UNION ALL
  SELECT
    'Superhero pants',
    NULL,
    '2022-01-01'
  UNION ALL
  SELECT
    'Superhero pants',
    3,
    '2022-05-01'
  UNION ALL
  SELECT
    'Superhero pants',
    NULL,
    '2022-10-01'
  UNION ALL
  SELECT
    'Superhero masks',
    10,
    '2022-11-01'
  UNION ALL
  SELECT
    'Superhero masks',
    NULL,
    '2022-02-14'
  UNION ALL
  SELECT
    'Superhero masks',
    NULL,
    '2022-02-15'
  UNION ALL
  SELECT
    'Superhero masks',
    NULL,
    '2022-02-13'
)
SELECT
  ROW_NUMBER() over (partition by null order by null) AS id,*
FROM
  temp
