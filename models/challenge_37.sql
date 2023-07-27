{{
  config(
    materialized = 'view'
 )
}}
/* Set stage name & stage */
{% set stage_name = 'dvd_frosty_fridays_37' %}
{% set stage_additional_info = "url='s3://frostyfridaychallenges/challenge_37/' 
  DIRECTORY = (
    ENABLE=TRUE
    AUTO_REFRESH = false
    REFRESH_ON_CREATE =  TRUE
  )
  STORAGE_INTEGRATION = dvd_frosty_ch37
  COMMENT = 'storage integration used for frosty_friday_challenges'
  " %} -- noqa: L016

/* Create the integration and the stage only
when the variable for this challenge (or the `run_all_`)
are set
*/
{% if execute and var('ch37', var('run_all', false)) %}
{% set init_integration %}
create or replace storage integration dvd_frosty_ch37
  type = external_stage
  storage_provider = 's3'
  storage_aws_role_arn = 'arn:aws:iam::184545621756:role/week37'
  enabled = true
  storage_allowed_locations = ('s3://frostyfridaychallenges/challenge_37/');
{% endset %}
{% if var('init', var('run_all', false)) %}
{% do run_query(init_integration) %}
{% endif %}
{{ create_stage(
        database = target.database,
        schema = target.schema,
        name = stage_name,
        additional_info = stage_additional_info) }}
{% endif %}

SELECT
    relative_path,
    size,
    file_url,
    build_scoped_file_url(@dvd_frosty_fridays_37, relative_path) AS scoped,
    build_stage_file_url(@dvd_frosty_fridays_37, relative_path) AS staged,
    get_presigned_url(@dvd_frosty_fridays_37, relative_path, 60) AS pre_signed
FROM directory(@dvd_frosty_fridays_37)
