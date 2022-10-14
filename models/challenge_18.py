# from sklearn.linear_model import LinearRegression
# from snowflake.snowpark.functions import udf
# from snowflake.snowpark.types import IntegerType, FloatType

def model(dbt, session):
    dbt.config(materialized="table")
    df = dbt.source("marketplace_economy_atlas","BEANIPA")

    pce_model = df.filter(df['"Table Name"'] == 'Price Indexes For Personal Consumption Expenditures By Major Type Of Product')
    pce_model = pce_model.filter(pce_model['"Indicator Name"'] == 'Personal consumption expenditures (PCE)')
    pce_model = pce_model.filter(pce_model['"Frequency"'] == 'A')
    pce_model = pce_model.filter(pce_model['"Date"'] >= '1980-01-01')

    # pd_df_pce_year = df_pce.select(year(col('"Date"')).alias('YEAR'), col('"Value"').alias('PCE') ).to_pandas()
    # x = pd_df_pce_year["YEAR"].to_numpy().reshape(-1,1)
    # y = pd_df_pce_year["PCE"].to_numpy()

    # model = LinearRegression().fit(x, y)

    # @udf(name="predict_pce_udf_sp",
    #     is_permanent=True,
    #     stage_location="@DVD_FROSTY_FRIDAYS",
    #     return_type=FloatType(),
    #     input_types=[IntegerType()],
    #     packages= ["pandas","scikit-learn"],
    #     replace=True,
    #     session=session)
    # def pce_forecast(target_year: int) -> float:
    #     return model.predict([[target_year]])[0].round(2).astype(float)

    return pce_model
