{{
  config(
    materialized = 'table',
    post_hook = ["
    {% if var('ch39', false) %}
        CREATE OR REPLACE MASKING POLICY ch39_email_mask AS (val string) RETURNS string ->
        CASE
            WHEN CURRENT_ROLE() = '{{ target.role }}' THEN val
            ELSE '*********@' || split(val,'@')[1]
        END
  {% endif %}",
  "{% if var('ch39', false) %}
    ALTER TABLE {{ this }} MODIFY COLUMN email SET MASKING POLICY ch39_email_mask FORCE
   {% endif %}"]
    )
}}
SELECT
    1 AS id,
    'Jeff Jeffy' AS user_name,
    'jeff.jeffy121@gmail.com' AS email
UNION ALL
SELECT
    2,
    'Kyle Knight',
    'kyleisdabest@hotmail.com'
UNION ALL
SELECT
    3,
    'Spring Hall',
    'hall.yay@gmail.com'
UNION ALL
SELECT
    4,
    'Dr Holly Ray',
    'drdr@yahoo.com'
