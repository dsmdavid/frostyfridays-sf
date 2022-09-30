{{
  config(
    materialized = 'view',
    )
}}

with sample_ as (
select result from {{ ref('challenge_16_01') }}
),
parsed as (
select 
    result:word::varchar as word,
    result:url::varchar as url,

    m.value:antonyms as general_antonyms,
    m.value:synonyms as general_synonyms,

    d.value:definition::varchar as definition,
    d.value:example::varchar as example_if_applicable,
    d.value:synonyms as definitional_synonyms,
    d.value:antonyms as definitional_antonyms
    from sample_
    , lateral flatten(result:definition, outer => true) as r
    , lateral flatten(r.value:meanings, outer => true) as m
    , lateral flatten(m.value:definitions, outer => true) as d
)
select * from parsed
