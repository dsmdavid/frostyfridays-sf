{{
  config(
    materialized = 'view'
 )
}}

with temp as (
    select * from {{ ref('challenge_04_01') }})
select 
    row_number() over (order by temp.monarchs['Birth'] asc ) as id,
    temp.monarch_index+1 as inter_house_id,
    temp.era,
    temp.house_name,
    temp.monarchs['Name']::varchar as NAME,
    temp.monarchs['Start of Reign']::date as START_OF_REIGN,
    regexp_replace(temp.monarchs['Age at Time of Death']::varchar,'[^0-9]','')::number
     as AGE_AT_TIME_OF_DEATH_YEARS,
    temp.monarchs['Birth']::date as BIRTH,
    temp.monarchs['Burial Place']::varchar as BURIAL_PLACE,
    coalesce(temp.monarchs:"Consort\/Queen Consort"[0]::varchar,temp.monarchs:"Consort\/Queen Consort"::varchar) as CONSORT__QUEEN_CONSORT_1,
    temp.monarchs:"Consort\/Queen Consort"[1]::varchar as CONSORT__QUEEN_CONSORT_2,
    temp.monarchs:"Consort\/Queen Consort"[2]::varchar as CONSORT__QUEEN_CONSORT_3,
    temp.monarchs['Death']::varchar as DEATH,
    temp.monarchs['Duration']::varchar as DURATION,
    temp.monarchs['End of Reign']::date as END_OF_REIGN,
    coalesce(temp.monarchs['Nickname'][0]::varchar,temp.monarchs['Nickname']::varchar) as NICKNAME_1,
    temp.monarchs['Nickname'][1]::varchar as NICKNAME_2,
    temp.monarchs['Nickname'][2]::varchar as NICKNAME_3,
    temp.monarchs['Place of Birth']::varchar as PLACE_OF_BIRTH,
    temp.monarchs['Place of Death']::varchar as PLACE_OF_DEATH
from temp