from unicodedata import name
import snowflake.connector
import os
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives.asymmetric import dsa
from cryptography.hazmat.primitives import serialization

SF_USER = os.getenv('dvd_sf_user')
SF_PWD = os.getenv('dvd_sf_passphrase')
SF_KEY_PATH = os.getenv('dvd_key_path','/root/.ssh/rsa_key_david_sf.p8')
SF_ACCOUNT = os.getenv('dvd_sf_account')
SF_DATABASE = os.getenv('dvd_sf_db')
SF_SCHEMA = os.getenv('dvd_sf_schema')
SF_WAREHOUSE = os.getenv('dvd_sf_wh')
SF_ROLE = os.getenv('dvd_sf_role')


def get_ctx():

    with open(SF_KEY_PATH, "rb") as key:
        p_key= serialization.load_pem_private_key(
            key.read(),
            password=SF_PWD.encode(),
            backend=default_backend()
        )

    pkb = p_key.private_bytes(
        encoding=serialization.Encoding.DER,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.NoEncryption())

    ctx = snowflake.connector.connect(
        user=SF_USER,
        account=SF_ACCOUNT,
        private_key=pkb,
        warehouse=SF_WAREHOUSE,
        database=SF_DATABASE,
        schema=SF_SCHEMA,
        role = SF_ROLE
        )

    return ctx

if __name__ == '__main__':
    ctx = get_ctx()
    query = """
SELECT * FROM TEST_DB.DVD_FROSTY_FRIDAYS.CHALLENGE_08;
"""
    cur = ctx.cursor().execute(query)
    print(cur)

