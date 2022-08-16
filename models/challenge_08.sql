{{
  config(
    materialized = 'view'
 )
}}
{% set stage_name = 'dvd_frosty_fridays_08' %}
{% set stage_additional_info = "url='s3://frostyfridaychallenges/challenge_8/' file_format=(type=csv SKIP_HEADER =1)" %}

{%- if execute %}
  {{ create_stage(
        database = target.database,
        schema = target.schema,
        name = stage_name,
        additional_info = stage_additional_info) }}
{% endif %}


with staged as (
    select 
      metadata$filename as filename_,
      metadata$file_row_number as row_,
      $2::timestamp as payment_date,
      $3::varchar as	card_type,
      $4::int as amount_spent
    from @{{stage_name}}
)
select * from staged