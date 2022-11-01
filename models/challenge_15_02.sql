{{
  config(
    materialized = 'view',
    )
}}
{% set arrays= [
    [1,310000,400000,500000],
    [210000,350000],
    [250000,290001,320000,360000,410000,470001]
]
%}
SELECT
    sale_date,
    price,
    {% for arr in arrays %}
    {{ target.schema }}.udf_set_bins(
        price, {{ arr }}
    ) AS bucket_set_{{ loop.index }}{% if not loop.last %}, {% endif %}
    {%- endfor %}
FROM {{ ref('challenge_15_01') }}
