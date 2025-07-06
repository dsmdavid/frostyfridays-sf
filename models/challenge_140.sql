{{
  config(
    materialized = 'table'
 )
}}
{# macro init_challenge_140 used as run-operation to create the required tables and sample rows #}

{% if var('ch140', var('run_all', false)) %}
    with categories as (
        select array_agg(category_name) as categories from {{ target.database }}.{{ target.schema }}.ch140_service_categories
    ),
    line_items as (
        select * from {{ target.database }}.{{ target.schema }}.ch140_invoice_line_items
    ),
    combined as (
        select * 
        from line_items
        cross join categories
    ),
    classify_text as (
        select 
            line_item_id,
            service_description,
            categories,
            SNOWFLAKE.CORTEX.CLASSIFY_TEXT( service_description , categories)['label']::varchar as classification

        from combined
    )
    select * from classify_text
{% else %}
    SELECT 'raw_data not created, use var ch140 to enable it.' AS output_
{% endif %}