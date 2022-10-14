import os
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives.asymmetric import dsa
from cryptography.hazmat.primitives import serialization

def retrieve_pk(path_to_p8:str, passphrase:str):
   with open(path_to_p8, "rb") as key:
      p_key= serialization.load_pem_private_key(
         key.read(),
         password=passphrase.encode(),
         backend=default_backend()
      )

   pkb = p_key.private_bytes(
      encoding=serialization.Encoding.DER,
      format=serialization.PrivateFormat.PKCS8,
      encryption_algorithm=serialization.NoEncryption())
   return pkb


snowflake_conn_prop = {
   # "account": os.getenv('sf_account'),
   # "user": os.getenv('sf_username'),
   # "password": os.getenv('sf_pwd'),
   "account": os.getenv('dvd_frosty_sf_account'),
   "user": os.getenv('dvd_frosty_user'),
   "password": os.getenv('sf_pwd'),
   "role": os.getenv('dvd_frosty_role'),
   "database": os.getenv('dvd_frosty_db'),
   "schema": os.getenv('dvd_frosty_wh'),
   "warehouse": os.getenv('dvd_frosty_wh'),
   "private_key": retrieve_pk(
         os.getenv('dvd_frosty_local_path_to_key'),
         os.getenv('dvd_frosty_passphrase'))
}


# Snowflake Account Identifiers
# https://docs.snowflake.com/en/user-guide/admin-account-identifier.html#account-identifier-formats-by-cloud-platform-and-region
#  