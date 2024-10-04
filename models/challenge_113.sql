{{
  config(
    materialized = 'table'
 )
}}

{% if execute and var('ch113', var('run_all', false)) %}
-- set up variables needed
{% set default_role= 'role_dvd_ch113_rw' %}
{% set role_with_snowflake_share_access = 'role_dvd_ch133_snowflake' %}
{% set ro_role = 'role_dvd_ch113_ro' %}
{% set default_db = env_var('default_db', 'test_db') %}
{% set users_1 = [
  'dvd_ch113_1_01',
  'dvd_ch113_1_02',
  'dvd_ch113_1_03',
  'dvd_ch113_1_04',
  'dvd_ch113_1_05'] %}
{% set users_2 = ['dvd_ch113_2_01'] %}
{% set users_3 = ['dvd_ch113_3_01'] %}
{% set users_4 = ['dvd_ch113_4_01'] %}
-- prepare user creation script
{% set sql %}
use role securityadmin;
create role if not exists {{ default_role }};
grant usage, create schema on database {{ default_db }} to role {{ default_role }};
grant role {{ default_role }} to role sysadmin;

create role if not exists {{ role_with_snowflake_share_access }};
grant role imported_privileges_admin to role {{ role_with_snowflake_share_access }};-- the imported_privileges_admin is managed elsewhere
grant role {{ default_role }} to role {{ role_with_snowflake_share_access }};
grant role {{ role_with_snowflake_share_access }} to role sysadmin;


-- scenario 1
{# create 5 users, SSO enabled, rw to specific db #}
{% for user in users_1 %}
  create user if not exists {{ user }}
    default_role = {{ default_role }}
    type = PERSON
  ;
  grant role {{ default_role }} to user {{ user }};
  {% endfor %}

-- scenario 2
{# service account, Key-pair, ingestion #}
{% for user in users_2 %}
{% if env_var('test_rsa_key',false) %}
  create user if not exists {{ user }}
    default_role = {{ default_role }}
    type = service
    rsa_public_key = '{{ env_var('test_rsa_key') }}'
  ;
  grant role {{ default_role }} to user {{ user }};
  {% endif %}
{% endfor %}
-- scenario 3
{% for user in users_3 %}
{# legacy-service, user-pwd #}
{% if env_var('legacy_password',false) %}

  create user if not exists {{ user }}
    default_role = {{ default_role }}
    type = legacy_service
    password = '{{ env_var('legacy_password','') }}'
  ;
  grant role {{ default_role }} to user {{ user }};
  {% endif %}
{% endfor %}
-- scenario 4
{% for user in users_4 %}
{% if env_var('test_rsa_key',false) %}
  create user if not exists {{ user }}
    default_role = {{ role_with_snowflake_share_access }}
    type = service
    rsa_public_key = '{{ env_var('test_rsa_key') }}'
  ;
  grant role {{ role_with_snowflake_share_access }} to user {{ user }};
  {% endif %}
  {% endfor %}
{# service account, key-pair, no-mfa #}

-- get the view with the users created
use role {{ target.role }};
use database {{ target.database }};
use schema {{ target.schema }};
create or replace procedure get_users()
RETURNS TABLE (
  name varchar, 
  has_password BOOLean,
  has_rsa_public_key Boolean
)
LANGUAGE SQL 
EXECUTE AS CALLER
AS
$$
DECLARE
  res RESULTSET;
  sql1 varchar default 'SHOW USERS LIKE \'DVD_CH113%\';';
  sql2 varchar default 'SELECT "name"::varchar as NAME, "has_password"::boolean as HAS_PASSWORD, "has_rsa_public_key"::boolean as HAS_RSA_PUBLIC_KEY FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))';
BEGIN
  execute immediate sql1;
  res := (execute immediate sql2);
  RETURN TABLE(res);
END;
$$

;
{% endset %}
{% do run_query(sql) %}
{% endif %}

{% if var('ch113', var('run_all', false)) %}

WITH
    users AS (
        SELECT *
        FROM TABLE(GET_USERS())
    )

SELECT * FROM users

{% else %}
SELECT 'ch113 not enabled' as CHALLENGE_STATUS
{% endif %}


{% if execute 
    and var('ch113', var('run_all', false)) 
    and var('cleanup', false) %}
{% set all_users = users_1 + users_2 + users_3 %}
{{ log('Cleaning up', info=True) }}
{{ log('>> The table will error as objects needed have been dropped.', info=True) }} 
{{ log('>> This is expected', info=True) }}

{% set sql %}
use role securityadmin;
{% for user in all_users %}
drop user  if exists {{ user }};
{% endfor %}
use role {{ target.role }};
drop procedure if exists {{ target.database }}.{{ target.schema }}.get_users();
{% endset %}
{% do run_query(sql) %}
{% endif %}
