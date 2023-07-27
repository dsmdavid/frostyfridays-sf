{{
  config(
    materialized = 'table',
    )
}}

SELECT
    1::int AS icecream_id,
    'strawberry'::varchar(15) AS icecream_flavour,
    'Jimmy Ice'::varchar(50) AS icecream_manufacturer,
    'Ice Co.'::varchar(50) AS icecream_brand,
    'Food Brand Inc.'::varchar(50) AS icecreambrandowner,
    'normal'::varchar(15) AS milktype,
    'Midwest'::varchar(50) AS region_of_origin,
    7.99::number AS recomendad_price,
    5::number AS wholesale_price
UNION ALL
SELECT
    2,
    'vanilla',
    'Kelly Cream Company',
    'Ice Co.',
    'Food Brand Inc.',
    'dna-modified',
    'Northeast',
    3.99,
    2.5
UNION ALL
SELECT
    3,
    'chocolate',
    'ChoccyCream',
    'Ice Co.',
    'Food Brand Inc.',
    'normal',
    'Midwest',
    8.99,
    5.5
