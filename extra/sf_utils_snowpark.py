from unicodedata import name
from snowflake.snowpark.session import Session
import os
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives.asymmetric import dsa
from cryptography.hazmat.primitives import serialization

SF_USER = os.getenv('dvd_sf_user')
SF_PWD = os.getenv('dvd_sf_passphrase')
SF_KEY_PATH = os.getenv('dvd_key_path',os.getenv('dvd_frosty_local_path_to_key','/root/.ssh/rsa_key_david_sf.p8'))
SF_ACCOUNT = os.getenv('dvd_sf_account')
SF_DATABASE = os.getenv('dvd_sf_db')
SF_SCHEMA = os.getenv('dvd_sf_schema')
SF_WAREHOUSE = os.getenv('dvd_frosty_wh','WAREHOUSE_DVD_TEST')
SF_ROLE = os.getenv('dvd_sf_role')

def get_pkb(path):
    with open(path, "rb") as key:
        p_key= serialization.load_pem_private_key(
            key.read(),
            password=SF_PWD.encode(),
            backend=default_backend()
        )

    pkb = p_key.private_bytes(
        encoding=serialization.Encoding.DER,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.NoEncryption())
    return pkb
def get_ctx():
    connection_parameters = {
        'user': SF_USER,
        'account': SF_ACCOUNT,
        'private_key': get_pkb(SF_KEY_PATH),
        'warehouse': SF_WAREHOUSE,
        'database': SF_DATABASE,
        'schema': SF_SCHEMA,
        'role': SF_ROLE
    }
    session = Session.builder.configs(connection_parameters).create()

    return session

CONN_PARAM = {
   "account": SF_ACCOUNT,
   "user": SF_USER,
   "warehouse": SF_WAREHOUSE,
   "role": SF_ROLE,
   "database": SF_DATABASE,
   "schema": SF_SCHEMA,
   "private_key": get_pkb(SF_KEY_PATH)
}

if __name__ == '__main__':
    print(CONN_PARAM)
#     ctx = get_ctx()

#     query = """
# SELECT * FROM TEST_DB.DVD_FROSTY_FRIDAYS.CHALLENGE_08;
# """
#     cur = ctx.cursor().execute(query)
#     print(cur)

