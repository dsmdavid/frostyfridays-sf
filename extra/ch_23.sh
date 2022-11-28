#!bin/bash
# run the below line once the variables have been set
# export db_name=YOUR_DB_NAME
# export schema_name=YOUR_SCHEMA_NAME
# export warehouse_name=YOUR_WAREHOUSE_NAME

snowsql -c il -f ./ch_23.sql -D stage_name=dvd_frosty_fridays_23 -D db_name=$sf_frosty_db_name -D schema_name=$sf_frosty_schema -D warehouse_name=$sf_frosty_wh_name