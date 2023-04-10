{% macro ch_40_create_function() %}
{% if execute and var("ch40", var("run_all", false)) %}
  {% set init_query %}
CREATE OR REPLACE FUNCTION {{ target.database }}.{{ target.schema }}.ch40_revenue_europe()
    RETURNS NUMBER(38,6)
    MEMOIZABLE
    AS 
    $$
    SELECT
        sum(
            l.l_quantity * (l.l_extendedprice * (1 - l.l_discount))
        )
        AS revenue
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
    $$
  {% endset %}
  {% do run_query(init_query) %}
  {{ log('Memoizable function created', info=True)}}
{% endif %}

{% endmacro %}
