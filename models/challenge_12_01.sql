{{
  config(
    materialized = 'view',
)
}}

  {% if execute %}
  {% set schema_name = 'world_bank_metadata' %}
  {% set second_schema_name = 'world_bank_economic_indicators' %}
  {% set third_schema_name = 'world_bank_social_indiactors' %}
  {% set sql %}
    create schema if not exists {{ target.database }}.{{ schema_name }};
    create or replace table {{ target.database }}.{{ schema_name }}.country_metadata
    (
        country_code varchar(3),
        region string,
        income_group string
    );
    create schema if not exists {{ target.database }}.{{ second_schema_name }};
    create or replace table {{ target.database }}.{{ second_schema_name }}.gdp
    (
        country_name string,
        country_code varchar(3),
        year int,
        gdp_usd double
    );
    create table {{ target.database }}.{{ second_schema_name }}.gov_expenditure
    (
        country_name string,
        country_code varchar(3),
        year int,
        gov_expenditure_pct_gdp double
    );
    create schema if not exists {{ target.database }}.{{ third_schema_name }};
    create or replace table {{ target.database }}.{{ third_schema_name }}.life_expectancy
    (
        country_name string,
        country_code varchar(3),
        year int,
        life_expectancy float
    );
    create or replace table {{ target.database }}.{{ third_schema_name }}.adult_literacy_rate
    (
        country_name string,
        country_code varchar(3),
        year int,
        adult_literacy_rate float
    );
    create or replace table {{ target.database }}.{{ third_schema_name }}.progression_to_secondary_school
    (
        country_name string,
        country_code varchar(3),
        year int,
        progression_to_secondary_school float
    );
  {% endset %}

  {% do run_query(sql) %}

{% endif %}

select 1 as dummy