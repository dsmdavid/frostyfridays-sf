{{
  config(
    materialized = 'view',
    )
}}
{% set attributes = ('title','author','year','publisher') %}

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
