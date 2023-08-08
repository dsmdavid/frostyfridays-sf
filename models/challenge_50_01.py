import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col

def sql_approach(session):
    dataframe = session.sql("SELECT * FROM TEST_DB.DVD_FROSTY_FRIDAYS.CHALLENGE_50 where last_name ='Deery'")
    return dataframe

def python_approach(session):
    tableName = 'TEST_DB.DVD_FROSTY_FRIDAYS.CHALLENGE_50'
    dataframe = session.table(tableName).filter(col("LAST_NAME") == 'Deery')
    return dataframe
    
def model(dbt, session: snowpark.Session): 
    # Your code goes here, inside the "main" handler.
    # dataframe = python_approach(session)
    dataframe = sql_approach(session)

    # Print a sample of the dataframe to standard output.
    dataframe.show()

    # Return value will appear in the Results tab.
    return dataframe
