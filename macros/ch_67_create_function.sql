{% macro ch_67_create_function() %}
{% if execute and var("ch67", var("run_all", false)) %}
  {% set init_query %}
CREATE OR REPLACE FUNCTION {{ target.database }}.{{ target.schema }}.ch67_object(PATENT_TYPE VARCHAR, APPLICATION_DATE DATE, DOCUMENT_PUBLICATION_DATE DATE)
    RETURNS OBJECT
    AS 
    $$
    object_construct(
      'days_difference',
      datediff('day',application_date,document_publication_date),
      'inside_of_projection', 
      CASE 
        WHEN patent_type = 'Reissue' THEN iff(datediff('day',application_date,document_publication_date) <= 365,TRUE,FALSE)
        WHEN patent_type = 'Design' THEN iff(datediff('year',application_date,document_publication_date) <= 2,TRUE,FALSE)
      ELSE null
      END
      )
$$
  {% endset %}
  {% do run_query(init_query) %}
  {% else %}
{% endif %}

{% endmacro %}
