{{
  config(
    materialized = 'view',
    )
}}
--noqa: disable=L042
WITH prep AS (
    SELECT
        t.$1 AS code,
        t.$2 AS code_parent,
        t.$3 AS valid_to,
        t.$4 AS valid_from,
        t.$5::boolean AS is_lowest_level
    FROM VALUES
        ('CC0193', 'EBGABA', '9999-01-01 00:00:00.000', '1950-01-01 00:00:00.000', 1, 7),
        ('CC0194', 'EBGABA', '9999-01-01 00:00:00.000', '1950-01-01 00:00:00.000', 1, 7),
        ('EBGABA', 'EBGAB', '9999-01-01 00:00:00.000', '1950-01-01 00:00:00.000', 0, 7),
        ('EBGAB', 'EBGA', '9999-01-01 00:00:00.000', '1950-01-01 00:00:00.000', 0, 7),
        ('EBGA', 'EBG', '9999-01-01 00:00:00.000', '1950-01-01 00:00:00.000', 0, 7),
        ('EBG', 'EB', '9999-01-01 00:00:00.000', '1950-01-01 00:00:00.000', 0, 7),
        ('EB', 'ZZ', '9999-01-01 00:00:00.000', '1950-01-01 00:00:00.000', 0, 7),
        ('ZZ', NULL, '9999-01-01 00:00:00.000', '1950-01-01 00:00:00.000', 0, 7),
        ('7050307', 'CC', '9999-01-01 00:00:00.000', '1950-01-01 00:00:00.000', 1, 3),
        ('CC', 'A1', '9999-01-01 00:00:00.000', '1950-01-01 00:00:00.000', 0, 3),
        ('A1', NULL, '9999-01-01 00:00:00.000', '1950-01-01 00:00:00.000', 0, 3) AS t
),

base AS (
    SELECT *
    FROM prep
    WHERE sysdate() >= valid_from
          AND sysdate() <= valid_to
),

hierarchies AS (
    SELECT
        code,
        code_parent,
        level,
        CONNECT_BY_ROOT code AS root_code
    FROM base
        START WITH is_lowest_level
        CONNECT BY
        code = PRIOR code_parent
    ORDER BY root_code, level
),

max_levels AS (SELECT
    root_code,
    max(level) AS max_level
    FROM hierarchies GROUP BY root_code
),

sorted AS (
    SELECT
        h.root_code,
        m.max_level - h.level + 1 AS level,
        h.code
    FROM hierarchies AS h
        LEFT JOIN max_levels AS m
            ON h.root_code = m.root_code
),

levels AS (
    SELECT row_number() OVER (ORDER BY null) AS level
    FROM table(generator(rowcount => 7))
),

filled AS (
    SELECT
        h.root_code,
        l.level,
        coalesce(
            s.code,
            last_value(s.code) IGNORE NULLS OVER (PARTITION BY h.root_code ORDER BY l.level ASC)
        ) AS filled_in_code
    FROM levels AS l
        CROSS JOIN max_levels AS h
        LEFT JOIN sorted AS s
            ON l.level = s.level
                AND h.root_code = s.root_code

)

SELECT *
FROM filled
    PIVOT(min(filled_in_code) FOR level IN (1, 2, 3, 4, 5, 6, 7))
    AS p
ORDER BY root_code
