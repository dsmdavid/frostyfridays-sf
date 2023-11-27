{{
  config(
    materialized = 'view',
    )
}}

WITH
    raw_ AS (
        SELECT * FROM
            (
                VALUES
                -- The Research & Development department is the top level.
                ('Research & Development', 1, NULL),
                ('Product Development', 11, 1),
                ('Software Design', 111, 11),
                ('Product Testing', 112, 11),
                ('Human Resources', 2, 1),
                ('Recruitment', 21, 2),
                ('Employee Relations', 22, 2)
            ) AS v (department_name, department_id, head_department_id)
    )

SELECT
    *,
    ltrim(sys_connect_by_path(department_name, ' -> '), ' ->') AS path
FROM raw_
    START WITH head_department_id IS NULL
    CONNECT BY
    head_department_id = PRIOR department_id
ORDER BY department_id
