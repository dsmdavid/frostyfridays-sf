import re
import streamlit as st
import pandas as pd
from sf_utils import get_ctx
from snowflake.connector.pandas_tools import write_pandas

# Secrets coming from env variables
ctx = get_ctx()

@st.cache
def get_tables(schema_name):
    query_str = f"select table_name from TEST_DB.INFORMATION_SCHEMA.TABLES where table_schema = '{schema_name}';"
    cur = ctx.cursor().execute(query_str)
    table_names = pd.DataFrame.from_records(iter(cur), columns=[x[0] for x in cur.description])
    return table_names

def upload_file(df, schema, table_name):
    response = write_pandas(
                    conn = ctx,
                    df = df,
                    table_name = table_name.upper(),
                    database = 'TEST_DB',
                    schema= schema,
                    quote_identifiers=False
                    )
    return response
def create_sidebar():
    instructions = [
        "Select one of the available schemas",
        "Then select one of the available tables",
        "Use the file uploader to select a file",
        "Check the preview of the data to confirm it looks as you expect it too",
        "Then click in the upload file button",
        "You should now see a successful message with the number of rows inserted"
        ]
    with st.sidebar:
        st.image('http://frostyfridaychallenges.s3.amazonaws.com/challenge_12/logo.png')
        st.write("# Instructions")
        for instruction in instructions:
            st.write(f'· {instruction}')


def app_creation():
    st.title('CSV uploader')
    create_sidebar()
    schema = st.radio(
    "Select schema",
    ('world_bank_metadata'.upper(),
     'world_bank_economic_indicators'.upper(),
     'world_bank_social_indiactors'.upper()))
    table = st.radio(
        "Select Table:",
        get_tables(schema)['TABLE_NAME']
    )
    # table_names = get_tables(schema)['TABLE_NAME'].unique().tolist()
    # st.write(table_names)
    uploaded_file = st.file_uploader("Choose a file", key='file_uploader')
    if uploaded_file:
        dataframe = pd.read_csv(uploaded_file)
        preview_placeholder = st.empty()
        with preview_placeholder.container():
            st.write('This is a preview of the data you are about to upload:')
            st.write(dataframe.head())
        if st.button('Click to upload'):
            with st.spinner('Uploading file...'):
                response = upload_file(dataframe, schema, table)
                if response[0]:
                    preview_placeholder.write('')
                    st.write(f'File successfully uploaded, {response[2]} rows were inserted ')
app_creation() # The function above is now invoked.