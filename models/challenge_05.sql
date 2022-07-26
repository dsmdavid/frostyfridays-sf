{{
  config(
    materialized = 'table'
 )
}}

select seq4() as start_int
from table(generator(rowcount => 10)) v