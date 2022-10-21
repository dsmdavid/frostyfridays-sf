-- depends on {{ ref('challenge_19_02') }}
{{
  config(
    materialized = 'view',
    )
}}

with base as (
    select 1 as id, '11/11/2020' as start_date, '9/3/2022' as end_date
union all 
select 2, '12/8/2020', '1/19/2022'
union all 
select 3, '12/24/2020', '1/15/2022'
union all 
select 4, '12/5/2020', '3/3/2022'
union all 
select 5, '12/24/2020', '6/20/2022'
union all 
select 6, '12/24/2020', '5/19/2022'
union all 
select 7, '12/31/2020', '5/6/2022'
union all 
select 8, '12/4/2020', '9/16/2022'
union all 
select 9, '11/27/2020', '4/14/2022'
union all 
select 10, '11/20/2020', '1/18/2022'
union all 
select 11, '12/1/2020', '3/31/2022'
union all 
select 12, '11/30/2020', '7/5/2022'
union all 
select 13, '11/28/2020', '6/19/2022'
union all 
select 14, '12/21/2020', '9/7/2022'
union all 
select 15, '12/13/2020', '8/15/2022'
union all 
select 16, '11/4/2020', '3/22/2022'
union all 
select 17, '12/24/2020', '8/29/2022'
union all 
select 18, '11/29/2020', '10/13/2022'
union all 
select 19, '12/10/2020', '7/31/2022'
union all 
select 20, '11/1/2020', '10/23/2021')

select 
    id,
    start_date, 
    end_date, 
    test_db.dvd_frosty_fridays.WORKING_DAYS(start_date, end_date, false) as excluding, 
    test_db.dvd_frosty_fridays.WORKING_DAYS(start_date, end_date, true) as including 
from base
