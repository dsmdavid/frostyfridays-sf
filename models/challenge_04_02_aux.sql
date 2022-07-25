{{
  config(
    materialized = 'view'
 )
}}

with temp as (
    select * from {{ ref('challenge_04_01') }}),
combined_keys as (
    select array_to_string(array_agg(keys),',') as all_keys from temp),
unique_keys as (
    select distinct t.value as key_name
    from combined_keys,
    lateral split_to_table(combined_keys.all_keys, ',') as t)
select 
'temp:monarchs:"' || key_name || '"]::'||
    case 
        when lower(key_name) in ('birth','date','end of reign','start of reign') then 'date'
    else 'varchar'
    end 
    || ' as ' || regexp_replace(upper(key_name),'[^A-Z]','_') || ','

    as select_


 from unique_keys