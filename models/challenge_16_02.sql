{{
  config(
    materialized = 'view',
    )
}}

WITH sample_ AS (
    SELECT result FROM {{ ref('challenge_16_01') }}
),

parsed AS (
    SELECT
        result:word::varchar AS word,
        result:url::varchar AS url,

        m.value:antonyms AS general_antonyms,
        m.value:synonyms AS general_synonyms,

        d.value:definition::varchar AS definition,
        d.value:example::varchar AS example_if_applicable,
        d.value:synonyms AS definitional_synonyms,
        d.value:antonyms AS definitional_antonyms
    FROM sample_,
        LATERAL flatten(result:definition, outer => true) AS r,
        LATERAL flatten(r.value:meanings, outer => true) AS m,
        LATERAL flatten(m.value:definitions, outer => true) AS d
)

SELECT * FROM parsed
