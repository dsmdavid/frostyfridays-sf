{{
  config(
    materialized = 'view'
    )
}}

-- returns common categories in all products sold per sale

WITH
    sales AS (
        SELECT * FROM {{ ref('challenge_71_01_sales') }}
    ),

    cats AS (
        SELECT * FROM {{ ref('challenge_71_02_products') }}
    ),

    expanded_sales AS (
        SELECT
            s.sale_id,
            f.value,
            array_size(s.product_ids) AS n_products_in_sale
        FROM sales AS s, LATERAL flatten(s.product_ids) AS f
    ),

    assigned_cats AS (
        SELECT
            s.sale_id,
            s.n_products_in_sale,
            s.value,
            cats.product_categories,
            row_number() OVER (
                PARTITION BY s.sale_id ORDER BY s.value ASC
            ) AS sale_line_item
        FROM expanded_sales AS s
            LEFT JOIN cats
                ON s.value = cats.product_id
    ),

    -- recursive to use array_intersect for all possible sale_items
    common_items AS (
        SELECT
            sale_id,
            n_products_in_sale,
            value,
            product_categories,
            sale_line_item,
            product_categories AS common_categories,
            CASE
                WHEN sale_line_item = n_products_in_sale THEN common_categories
            END AS output
        FROM assigned_cats
        WHERE sale_line_item = 1

        UNION ALL
        SELECT
            ci.sale_id,
            ci.n_products_in_sale,
            ac.value,
            ac.product_categories,
            ac.sale_line_item,
            array_intersection(
                ci.common_categories, ac.product_categories
            ) AS common_categories,
            CASE
                WHEN
                    ac.sale_line_item = ci.n_products_in_sale
                    THEN
                        array_intersection(
                            ci.common_categories, ac.product_categories
                        )
            END AS output

        FROM common_items AS ci
            LEFT JOIN assigned_cats AS ac
        WHERE
            ci.sale_line_item + 1 = ac.sale_line_item
            AND ci.sale_id = ac.sale_id
            AND ac.sale_id IS NOT NULL
        {#  -- AND common_categories IS NOT NULL 
            -- stop the iterative if there're no common categories before reaching the end, 
            -- would need to redo the other answers #}

    )

SELECT
    sale_id,
    array_agg(product_categories) AS answer_in_the_prompt,
    array_union_agg(product_categories) AS all_categories_in_sale,
    array_unique_agg(output) AS categories_common_to_all_elements_in_sale
FROM common_items
GROUP BY 1
ORDER BY 1
