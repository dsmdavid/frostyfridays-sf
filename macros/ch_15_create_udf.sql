{% macro ch15_create_udf() %}
{% if execute and var('ch15', var('run_all', false)) %}
    {% set sql_statement %}
create or replace function udf_set_bins(
    VALUE_ DOUBLE,
    BIN_UPPERBOUNDS ARRAY
)
returns int
language python
runtime_version = '3.8'
handler = 'set_bin'
as
$$
def set_bin(number: float, bins: list) -> int:
    '''
    Given a number and an array of upper bounds for bins,
    returns which bin the number belongs to'''
    test = list(filter(lambda x: x<=number, bins))
    if not test:
        # there's no upperbound threshold lower than the number
        # provided, so let's return 0
        return 0
    else:
        return len(test)
$$

    {% endset %}
    {% do run_query(sql_statement) %}
{% endif %}

{% endmacro %}