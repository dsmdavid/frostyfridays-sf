{{
  config(
    materialized = 'table'
 )
}}

SELECT seq4() AS start_int
FROM table(generator(rowcount => 10))
