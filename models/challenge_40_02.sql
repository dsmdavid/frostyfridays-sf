-- depends_on: {{ ref('challenge_40') }}
{{
  config(
    materialized = 'table'
    )
}}
SELECT
    {{ target.database }}.{{ target.schema }}.ch40_revenue_europe() AS revenue,
    'should have been used already' AS source_
