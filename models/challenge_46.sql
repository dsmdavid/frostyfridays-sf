{{
  config(
    materialized = 'view',
    )
}}

WITH
    cart AS (
        SELECT
            1 AS cart_number,
            [5, 10, 15, 20] AS contents
        UNION ALL
        SELECT
            2 AS cart_number,
            [8, 9, 10, 11, 12, 13, 14] AS contents
    ),

    raw_input_remove AS (
        SELECT
            $$1	10	1
1	15	2
1	5	3
1	20	4
2	8	1
2	14	2
2	11	3
2	12	4
2	9	5
2	10	6
2	13	7$$
            AS text_input
    ),

    -- noqa: disable=ST06
    to_remove AS (
        SELECT
            split(r.value, '\t') AS value_,
            value_[0]::int AS cart_number,
            value_[1]::int AS content_to_remove,
            value_[2]::int AS order_to_remove_in
        FROM raw_input_remove,
            LATERAL flatten(input => split(text_input, '\n')) AS r
    ),

    removal AS (
        SELECT
            cart_number,
            contents AS current_cart_contents,
            NULL AS content_last_removed,
            1 AS step
        FROM cart
        UNION ALL
        SELECT
            r.cart_number,
            array_remove(
                r.current_cart_contents, tr.content_to_remove
            ) AS current_cart_contents,
            tr.content_to_remove AS content_last_removed,
            r.step + 1 AS step
        FROM removal AS r
            LEFT JOIN to_remove AS tr
                ON
                    r.cart_number = tr.cart_number
                    AND r.step = tr.order_to_remove_in
        WHERE tr.cart_number IS NOT NULL
    )

SELECT * FROM removal
ORDER BY cart_number, step
