{{
  config(
    materialized = 'view',
    )
}}

select 
    e_data ,
    n_counter
from (select 'user@domain' as e_data, 1 as n_counter)