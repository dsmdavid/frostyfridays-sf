{% macro init_challenge_09() %}
    {% if execute and var('ch09', var('run_all', false)) %}
        {{ log('Starting challenge_09 pre-work', info=True)}}
  {% endif %}
  {% set table_name = 'data_to_be_masked' %}
  {% set roles = ['role_dvd_frosty_09_01', 'role_dvd_frosty_09_02'] %}
  {% set initial_query %}

USE ROLE {{ target.role }};
USE WAREHOUSE {{ target.warehouse }};
USE DATABASE {{ target.database }};
USE SCHEMA {{ target.schema }};
-- I wouldn't want to do this here, but....
USE ROLE accountadmin;
grant apply masking policy on account to role {{ target.role }};
USE ROLE {{ target.role }};
-- create source table
CREATE OR REPLACE TABLE {{ table_name }}(first_name varchar, last_name varchar,hero_name varchar);
INSERT INTO {{ table_name }} (first_name, last_name, hero_name) VALUES ('Eveleen', 'Danzelman','The Quiet Antman');
INSERT INTO {{ table_name }} (first_name, last_name, hero_name) VALUES ('Harlie', 'Filipowicz','The Yellow Vulture');
INSERT INTO {{ table_name }} (first_name, last_name, hero_name) VALUES ('Mozes', 'McWhin','The Broken Shaman');
INSERT INTO {{ table_name }} (first_name, last_name, hero_name) VALUES ('Horatio', 'Hamshere','The Quiet Charmer');
INSERT INTO {{ table_name }} (first_name, last_name, hero_name) VALUES ('Julianna', 'Pellington','Professor Ancient Spectacle');
INSERT INTO {{ table_name }} (first_name, last_name, hero_name) VALUES ('Grenville', 'Southouse','Fire Wonder');
INSERT INTO {{ table_name }} (first_name, last_name, hero_name) VALUES ('Analise', 'Beards','Purple Fighter');
INSERT INTO {{ table_name }} (first_name, last_name, hero_name) VALUES ('Darnell', 'Bims','Mister Majestic Mothman');
INSERT INTO {{ table_name }} (first_name, last_name, hero_name) VALUES ('Micky', 'Shillan','Switcher');
INSERT INTO {{ table_name }} (first_name, last_name, hero_name) VALUES ('Ware', 'Ledstone','Optimo');

use role securityadmin;
{% for role in roles %}
--Create Roles
create role if not exists {{ role }};
--Assign Roles to yourself with all needed privileges
grant role {{ role }} to role accountadmin;
grant role {{ role }} to role role_dvd_test;

grant USAGE  on warehouse {{ target.warehouse }} to role {{ role }};
grant usage on database {{ target.database }} to role {{ role }};
grant usage on schema {{ target.schema }} to role {{ role }};
grant usage on all schemas in database {{ target.database }} to role {{ role }};
grant select on all tables in database {{ target.database }} to role {{ role }};
grant create table on schema {{ target.schema }} to role {{ role }};
grant create view on schema {{ target.schema }} to role {{ role }};
{% endfor %}

-- Create Masking Policies
use role {{target.role}};
create masking policy if not exists {{ target.database }}.{{ target.schema}}.mp_last_name as (val string) returns string ->
  case
    when lower(current_role()) in ('role_dvd_frosty_09_02') then val
    else '*********'
  end;
create masking policy if not exists {{ target.database }}.{{ target.schema}}.mp_first_name as (val string) returns string ->
  case
    when lower(current_role()) in ({%- for role in roles -%}
    '{{ role }}'{%- if not loop.last -%},{%- endif -%}
    {%- endfor -%}) then val
    else '*********'
  end;

-- Create tags:
create tag if not exists tag_first_name;
create tag if not exists tag_last_name;

-- Assign tags to columns:
alter table {{ table_name }} modify column first_name
    set tag tag_first_name = 'True';
alter table {{ table_name }} modify column last_name
    set tag tag_last_name = 'True';

-- Assing policy masks to tags:
alter tag tag_first_name set
  masking policy mp_first_name;
alter tag tag_last_name set
  masking policy mp_last_name;
   
use role {{ target.role }};

{% endset %}

  {% if execute and var('ch09', var('run_all', false)) %}
    {{ log('Query for challenge_09 created', info=True)}}
    {{ log(initial_query, info = True)}}
    {% do run_query(initial_query) %}
    {{ log('Query for challenge_09 ran', info=True)}}
  {% endif %}

{% endmacro %}