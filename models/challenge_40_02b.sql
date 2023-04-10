-- depends_on: {{ ref('challenge_40_b') }}
{{
  config(
    materialized = 'table',
    )
}}
    SELECT
        sum(
            l.l_quantity * (l.l_extendedprice * (1 - l.l_discount))
        )
        AS revenue,
        'second_query' AS source_
    FROM {{ source('snowflake_sample_data', 'lineitem') }} AS l
        INNER JOIN {{ source('snowflake_sample_data', 'orders') }} AS o
            ON l.l_orderkey = o.o_orderkey
        INNER JOIN {{ source('snowflake_sample_data', 'customer') }} AS c
            ON o.o_custkey = c.c_custkey
        INNER JOIN {{ source('snowflake_sample_data', 'nation') }} AS n
            ON c.c_nationkey = n.n_nationkey
        INNER JOIN {{ source('snowflake_sample_data', 'region') }} AS r
            ON n.n_regionkey = r.r_regionkey
    WHERE r.r_name = 'EUROPE'
