{{
  config(
    materialized = 'table',
    post_hook=[" {{ ch15_create_udf() }}"]
    )
}}

select
    $1 as sale_date,
    $2 as price 
from values 
    ('2013-08-01'::date, 290000.00),
    ('2014-02-01'::date, 320000.00),
    ('2015-04-01'::date, 399999.99),
    ('2016-04-01'::date, 400000.00),
    ('2017-04-01'::date, 470000.00),
    ('2018-04-01'::date, 510000.00),
    ('2022-08-01'::date, 0.50),
    ('2022-02-01'::date, 1.00)