{% macro init_challenge_22() %}
{% if execute %}
  {% set init_query %}
use role securityadmin;
create role if not exists role_dvd_frosty_fridays_01;
create role if not exists role_dvd_frosty_fridays_02;
grant role role_dvd_frosty_fridays_01 to role sysadmin;
grant role role_dvd_frosty_fridays_02 to role sysadmin;
grant role {{target.role}} to role role_dvd_frosty_fridays_01;
grant role {{target.role}} to role role_dvd_frosty_fridays_02;
use role {{target.role}};

create row access policy if not exists {{target.database}}.{{target.schema}}.rls_challenge_22 
 AS (id number) returns boolean ->
    CASE
        WHEN lower(current_role()) IN ('role_dvd_frosty_fridays_01', 'sysadmin', '{{target.role}}')
        and id % 2 = 1 THEN TRUE
        WHEN lower(current_role()) IN ('role_dvd_frosty_fridays_02', 'sysadmin', '{{target.role}}')
        and id % 2 = 0 THEN TRUE
    ELSE 
        FALSE
    END;

{% endset %}
  {{ log('Query for sp challenge_22 created', info=True)}}
  {{ log(init_query)}}
  {% do run_query(init_query) %}
  {{ log('Query for sp challenge_22 ran', info=True)}}

{% endif%}

{% endmacro %}