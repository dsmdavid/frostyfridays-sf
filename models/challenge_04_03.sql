-- depends_on: {{ ref('challenge_04_02_aux') }}
{{
  config(
    materialized = 'view'
 )
}}
{% call statement('unique_keys', fetch_result=True) %}
  select key_name
  from {{ ref('challenge_04_02_aux') }}
{% endcall %}
{% set unique_keys = load_result('unique_keys') %}

WITH temp AS (
        SELECT * FROM {{ ref('challenge_04_01') }}
    ),

    prep AS (
        SELECT
            row_number() OVER (ORDER BY temp.monarchs['Birth'] ASC) AS id,
            temp.monarch_index + 1 AS inter_house_id,
            temp.era,
            temp.house_name, -- block below
    {%- if execute -%}
    {%- for key_name in unique_keys['data'] -%}
    {%- if key_name[0] not in ('Consort\/Queen Consort','Nickname') -%}
    temp.monarchs:"{{ key_name[0] }}"::
      {%- if key_name[0] | lower in ('birth','date','end of reign','start of reign') -%}
      date
      {%- else -%}
      varchar
      {%- endif %} as {{ modules.re.sub('[^a-zA-Z]','_',key_name[0] | upper ) }},
    {%- else %}
    coalesce(temp.monarchs:"{{ key_name[0] }}"[0]::varchar, temp.monarchs:"{{ key_name[0] }}"::varchar) as {{ modules.re.sub('[^a-zA-Z]','_',key_name[0] | upper ) }}_01,
    temp.monarchs:"{{ key_name[0] }}"[1]::varchar as {{ modules.re.sub('[^a-zA-Z]','_',key_name[0] | upper ) }}_02,
    temp.monarchs:"{{ key_name[0] }}"[2]::varchar as {{ modules.re.sub('[^a-zA-Z]','_',key_name[0] | upper ) }}_03,
    {%- endif %}
    {%- endfor %}
{%- endif %}

            1 AS dummy
        FROM temp
    )

SELECT * FROM prep
