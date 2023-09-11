{{
  config(
    materialized = 'view',
    pre_hook=[],
    post_hook=["{{ ch61_post_hooks() }}"]
    )
}}


{% set stage_name = 'dvd_frosty_fridays_61' %}
{% set stage_additional_info = "url='s3://frostyfridaychallenges/challenge_61/' file_format=(type=csv skip_header=1)" %} -- noqa: L016


{% if execute and var('ch61', var('run_all', false)) %}
{{ create_stage(
        database = target.database,
        schema = target.schema,
        name = stage_name,
        additional_info = stage_additional_info) }}
{% endif %}

WITH
    raw_data AS (
        SELECT
            $1 AS brand,
            $2 AS url,
            $3 AS product_name,
            $4 AS category,
            $5 AS friendly_url,
            metadata$file_row_number AS rn
        FROM @{{ stage_name }}
        WHERE category IS NOT NULL
    ),

    clean_up AS (
        SELECT
            --brand,
            url,
            product_name,
            category,
            coalesce(
                brand,
                last_value(brand) IGNORE NULLS OVER (
                    ORDER BY rn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                )
            )
            AS brand,
            coalesce(url, friendly_url) AS friendly_url
        FROM raw_data
    ),

    inner_obj AS (
        SELECT
            -- create the {"ProductName":"Friendly_URL"}
            *,
            object_construct(product_name, friendly_url) AS inner_obj
        FROM clean_up
    ),

    brand_category AS (
        SELECT
            -- create the {"Brand":[ { Product_name:url,...}]}
            object_construct(brand, array_agg(inner_obj)) AS inner_obj,
            category,
            brand
        FROM inner_obj
        GROUP BY ALL
    ),

    categories AS (
        SELECT
            -- create the [{ brand1:{}, brand2:{},...] per category, also lowercase
            array_agg(inner_obj) AS inner_obj,
            lower(left(category, 1))
            || replace(
                substr(category, 2, length(category)), ' ', ''
            ) AS
            category
        FROM brand_category
        GROUP BY category
    )

SELECT object_agg(category, inner_obj) AS json_export
FROM categories

-- these are the contents of the posthook ch61_post_hooks()
-- leaving it here to keep all code in a single file.
{#
{% if execute and var('ch61', var('run_all', false)) %}

--create stage to drop the file into
{% set stage_name = 'dvd_ff_61_share'%}
{% set stage_additional_info = "  encryption = (type = 'SNOWFLAKE_SSE') directory = (enable = TRUE)" %} -- noqa: L016
{{ create_stage(
        database = target.database,
        schema = target.schema,
        name = stage_name,
        additional_info = stage_additional_info) }}

-- copy into stage
{% set file_name = 'ch61_output' %}
{% set copy_sql %}
    COPY INTO @{{ stage_name }}/{{ file_name }}
    FROM {{ this }}
    FILE_FORMAT = ( TYPE = JSON COMPRESSION=NONE)
    OVERWRITE=TRUE;
{% endset %}
{% do run_query(copy_sql) %}


-- get url
{% set getsigned_url__sql %}
    SELECT
        get_presigned_url(@{{ stage_name }}, '{{ file_name }}_0_0_0.json', 60)
{% endset %}

-- display the url in the logs
{% set results =  run_query(getsigned_url__sql) %}
{{ log('****\nPresigned_URL:', info=True) }}
{{ log(results.columns[0].values()[0], info=True) }}
{{ log('End of Presigned_URL\n****', info=True) }}
{% endif %}
#}