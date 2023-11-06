{{
  config(
    materialized = 'view',
    pre_hook = '{{ ch_70_prep() }}'
    )
}}

{% set query_tag_filter = 'ff_challenge_' ~ invocation_id %}

SELECT
    query_parameterized_hash,
    min(query_text) AS sample_query,
    count(*) AS n_queries,
    sum(total_elapsed_time) AS total_elapsed_time

FROM table(information_schema.query_history())
WHERE
    query_tag = '{{ query_tag_filter }}'
    AND query_text NOT ILIKE '%information_schema%'
    AND query_text NOT ILIKE '%alter session%'

GROUP BY query_parameterized_hash
ORDER BY n_queries DESC
