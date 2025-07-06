{{
  config(
    materialized = 'table'
 )
}}
{# macro init_challenge_140 used as run-operation 
to create the required tables and sample rows #}

{% if var('ch140', var('run_all', false)) %}
    WITH
        categories AS (
            SELECT array_agg(category_name) AS categories
            FROM
                {{ target.database }}.{{ target.schema }}.ch140_service_categories -- noqa: LT05
        ),

        line_items AS (
            SELECT *
            FROM
                {{ target.database }}.{{ target.schema }}.ch140_invoice_line_items -- noqa: LT05
        ),

        combined AS (
            SELECT
                line_items.*,
                categories.*
            FROM line_items
                CROSS JOIN categories
        ),

        classify_text AS (
            SELECT
                line_item_id,
                service_description,
                categories,
                SNOWFLAKE.CORTEX.CLASSIFY_TEXT(
                    service_description,
                    categories)['label']::varchar
                    AS classification

            FROM combined
        )

    SELECT * FROM classify_text
{% else %}
    SELECT
        'raw_data not created, use var ch140 to enable it.'
            AS output_
{% endif %}
