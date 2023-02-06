from snowflake.snowpark.functions import col
from snowflake.snowpark.functions import call_udf

from datetime import datetime

def model(dbt, session):
    dbt.config(materialized="table")
    df = dbt.ref("challenge_29_01")
    # dt = datetime.strptime('2022-04-01','%Y-%m-%d')
    # data = session.sql('SELECT id, first_name, surname, email, start_date, arbitrary_fy(start_date) as fiscal_year from challenge_29_01')
    data = df.select(
        col("id"),
        col("first_name"),
        col("surname"),
        col("email"),
        col("start_date"),
        call_udf('arbitrary_fy',col("start_date")).alias("fiscal_year")
        )
    

    return data.group_by("fiscal_year").agg(col("*"), "count")
    # return data