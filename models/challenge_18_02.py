def model(dbt,session):
    dbt.config(materialized="table")
    df = session.sql("select predict_pce_udf_sp(2021)")

    return df