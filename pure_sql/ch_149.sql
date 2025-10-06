
CALL gen_timeseries('2025-04-01'::DATE, 7, 'WIDGETS', 123) ->> 
    SELECT 
        r.value:date::date AS ts_date,
        r.value:category::varchar AS category,
        r.value:value::float AS value,
        r.value:moving_avg::float AS moving_avg,
        r.value:day_index::int AS day_index,
        -- r.*
    FROM $1 AS s, 
    LATERAL FLATTEN(input=>try_parse_json((s.gen_timeseries)):rows ) AS r
;
