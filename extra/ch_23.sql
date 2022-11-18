/*
# run the below line once the variables have been set
# export db_name=YOUR_DB_NAME
# export schema_name=YOUR_SCHEMA_NAME
# export warehouse_name=YOUR_WAREHOUSE_NAME

# line to run:
# snowsql -c il -f ./ch_23.sql -D stage_name=dvd_frosty_fridays_23 -D db_name=$sf_frosty_db_name -D schema_name=$sf_frosty_schema -D warehouse_name=$sf_frosty_wh_name
*/

!set variable_substitution=true;
!define STAGE_NAME = &stage_name;
!define DB_NAME = &db_name;
!define SCHEMA_NAME = &schema_name;
!define WAREHOUSE_NAME = &warehouse_name;

use database identifier('&DB_NAME');
use schema identifier('&SCHEMA_NAME');
use warehouse identifier('&WAREHOUSE_NAME');
create or replace stage identifier('&STAGE_NAME')
    file_format=(type=csv SKIP_HEADER =1 FIELD_OPTIONALLY_ENCLOSED_BY='\"') ;
put 'file:///Users/davidsm/Data/bulk_data/*1.csv' @&STAGE_NAME;
select 
    $1 as id,
    $2 as first_name,
    $3 as last_name,
    $4 as email,
    $5 as gender,
    $6 as ip_address,
    metadata$filename as file_name

from @&STAGE_NAME
limit 10;
