{% macro ch_70_prep() %}
{% if execute and var("ch70", var("run_all", false)) %}
  {% set init_query %}
    ALTER SESSION SET QUERY_TAG = '{{ 'ff_challenge_' ~ invocation_id }}';
    /* Random queries without common pattern */
    SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;
    SELECT COUNT(*) FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER WHERE C_NATIONKEY = 15;
    SELECT C_NAME FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER WHERE C_PHONE = '19-144-468-5416';


    /* First set of queries following the same pattern. Pattern = All columns from customers with one WHERE-condition for C_MKTSEGMENT. */
    SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER WHERE C_MKTSEGMENT = 'BUILDING';
    SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER WHERE C_MKTSEGMENT = 'AUTOMOBILE';
    SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER WHERE C_MKTSEGMENT = 'MACHINERY';
    SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER WHERE C_MKTSEGMENT = 'HOUSEHOLD';
    SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER WHERE C_MKTSEGMENT = 'BUILDING';
    SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER WHERE C_MKTSEGMENT = 'BUILDING';


    /*Second set of queries following the same pattern. Pattern= C_NAME and C_NATIONKEY from customers with two WHERE-conditions for C_MKTSEGMENT and C_NATIONKEY. */
    SELECT C_NAME, C_NATIONKEY FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER WHERE C_MKTSEGMENT = 'BUILDING' AND C_NATIONKEY = 21;
    SELECT C_NAME, C_NATIONKEY FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER WHERE C_MKTSEGMENT = 'MACHINERY' AND C_NATIONKEY = 9;
    ALTER SESSION UNSET QUERY_TAG;
  {% endset %}
  {% do run_query(init_query) %}
  {% else %}
{% endif %}

{% endmacro %}
