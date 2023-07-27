{% macro my_vars_parsing_macro() -%}
    {% set my_value = var('a',var('b',var('c','Oh no!'))) %}
    {{ return(my_value) }}
{%- endmacro %}