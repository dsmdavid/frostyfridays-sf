
import streamlit as st
import pandas as pd
from sf_utils_snowpark import get_ctx
import snowflake.snowpark as snowpark
import emoji

# Secrets coming from env variables
ctx = get_ctx()

@st.cache
def get_query(param):
    # From instructions:
    # Schemas, tables, views and grants should be on the account level
    # (i.e. not per database etc…)
    prep = 'ON' if param.lower() == 'grants' else 'IN'
    query_str = f"SHOW {param} {prep} ACCOUNT"
    # cur = ctx.cursor().execute(query_str)
    output = pd.DataFrame(data=ctx.sql(query_str).collect())
    return output

def create_sidebar():
    options = """‘None’
‘Shares’
‘Roles’
‘Grants’
‘Users’
‘Warehouses’
‘Databases’
‘Schemas’
‘Tables’
‘Views’""".replace("‘","").replace("’","").split('\n')

    with st.sidebar:
        st.image('https://frostyfriday.org/wp-content/uploads/2022/11/ff_logo_trans.png')
        selected_option = st.selectbox(label="Select what account info you'd like to see", options=options)
        st.markdown(f'''<div style="line-height: 15em;"><span style="text-align: justify;   line-height: 1.2em; vertical-align: bottom;">Built with streamlit {st.__version__}\n<span>
         <p>Snowpark {snowpark.__version__}</p></div>''', unsafe_allow_html=True)
    return selected_option

def app_creation():
    st.title('Snowflake Account Info App')
    st.write(f"Use this app to quickly see high-level info about your {emoji.emojize(':snowflake:')} account")
    selected_option = create_sidebar()

    if selected_option != 'None':
        table = get_query(selected_option)
        st.dataframe(table)
    else:
        st.write("Choose one option from the dropdown on the left")

app_creation() # The function above is now invoked.