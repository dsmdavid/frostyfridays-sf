{{
  config(
    materialized = 'view',
    pre_hook=[ '{{ ch76_create_tasks() }}'],

    )
}}

SELECT 1 AS dummy
