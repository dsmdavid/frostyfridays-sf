{{
  config(
    materialized = 'view',
    )
}}

SELECT
    e.id,
    e.name,
    e.department,
    s.sale_amount
FROM {{ ref('challenge_38_01_employees') }} AS e
    INNER JOIN {{ ref('challenge_38_02_sales') }} AS s ON e.id = s.employee_id
