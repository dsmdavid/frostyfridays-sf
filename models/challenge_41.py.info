# This is the content of the Snowsight window
# The Snowpark package is required for Python Worksheets. 
# You can add more packages by selecting them using the Packages control and then importing them.

import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col

def main(session: snowpark.Session): 
    # Your code goes here, inside the "main" handler.
    statement1 = 'We Love Frosty Friday'
    statement2 = 'Python Worksheets Are Cool'
    statements = list(zip(statement1.split(),statement2.split()))

    dataframe = session.create_dataframe(statements, schema=["STATEMENT1", "STATEMENT2"])

    # Print a sample of the dataframe to standard output.
    dataframe.show()

    # Return value will appear in the Results tab.
    return dataframe