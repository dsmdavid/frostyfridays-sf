{{
  config(
    materialized = 'view',
    )
}}
{% set query_text %}
select distinct b.value:"@"::string AS ATTRIBUTE
from {{ ref('challenge_49_01') }},
lateral flatten(xml_content:"$") as books,
lateral flatten(books.value:"$") as b
{% endset %}
{% if execute %}
    {% set attributes_output = run_query(query_text) %}
    {% set attributes = attributes_output.columns[0].values() %}
{% else %}
{% set attributes = ('placeholder') %}
{% endif %}
WITH
    flattened AS (
        SELECT
            f.xml_content:"@"::string AS catalogue,
            books.index AS book_index,
            book.value:"$"::string AS item,
            book.value:"@"::string AS item_type
        FROM {{ ref('challenge_49_01') }} AS f,
            LATERAL flatten(f.xml_content:"$") AS books,
            LATERAL flatten(books.value:"$") AS book
    )

SELECT *
FROM flattened
    PIVOT (min(item) FOR item_type IN {{ attributes }}) AS p
    (
        collection,
        book_index,
        {%- for attribute in attributes %}
            {{ attribute }}{%- if not loop.last -%},{%- endif -%}
        {% endfor %}
    )
