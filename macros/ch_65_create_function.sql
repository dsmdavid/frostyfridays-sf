{% macro ch_65_create_function() %}
{% if execute and var("ch65", var("run_all", false)) %}
  {% set init_query %}
CREATE OR REPLACE FUNCTION {{ target.database }}.{{ target.schema }}.ch65_thumbs(PATENT_TYPE VARCHAR, APPLICATION_DATE DATE, DOCUMENT_PUBLICATION_DATE DATE)
    RETURNS VARCHAR
    AS 
    $$
    CASE 
        WHEN patent_type = 'Reissue' THEN iff(datediff('day',application_date,document_publication_date) <= 365,'👍','👎')
        WHEN patent_type = 'Design' THEN iff(datediff('year',application_date,document_publication_date) <= 2,'👍','👎')
        ELSE null
    END
$$
  {% endset %}
  {% do run_query(init_query) %}
  {% else %}
{% endif %}

{% endmacro %}
