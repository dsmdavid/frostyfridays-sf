import os


snowflake_conn_prop = {
   "account": os.getenv('sf_account'),
   "user": os.getenv('sf_username'),
   "password": os.getenv('sf_pwd'),
   "role": "ACCOUNTADMIN",
   "database": "TEST_DB",
   "schema": "DVD_FROSTYFRIDAYS_SPARK",
   "warehouse": "sp_qs_wh",
}

# Snowflake Account Identifiers
# https://docs.snowflake.com/en/user-guide/admin-account-identifier.html#account-identifier-formats-by-cloud-platform-and-region
#  