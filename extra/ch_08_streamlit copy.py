import streamlit as st
import pandas as pd
from sf_utils import get_ctx

# Secrets coming from env variables
ctx = get_ctx()

query = """
select date_trunc('week', payment_date) as payment_week, card_type, sum(amount_spent) as amount_spent
from  TEST_DB.DVD_FROSTY_FRIDAYS.CHALLENGE_08
group by 1,2;"""

@st.cache # This keeps a cache in place so the query isn't constantly re-run.
def load_data():
    """
    Returns a dataframe with the dates as the index
    """
    cur = ctx.cursor().execute(query)
    payments_df = pd.DataFrame.from_records(iter(cur), columns=[x[0] for x in cur.description])
    payments_df['PAYMENT_WEEK'] = pd.to_datetime(payments_df['PAYMENT_WEEK'])

    payments_df = payments_df.set_index('PAYMENT_WEEK') 
    return payments_df


payments_df = load_data() 

def get_min_date():
    """
    This function returns the earliest date present in the dataset.
    When you want to use this value, just write get_min_date().
    """
    return min(payments_df.index.to_list()).date()

def get_max_date():
    """
    This function returns the latest date present in the dataset.
    When you want to use this value, just write get_max_date().
    """
    return max(payments_df.index.to_list()).date()


def app_creation():

    st.title('Payments in 2021')
    # vars
    min_date = get_min_date()
    max_date = get_max_date()
    card_types = [*['Any'], *sorted(payments_df['CARD_TYPE'].unique())]
    # filters
    filter_min_date = st.slider(
        label = 'Select min_date',
        min_value = min_date,
        max_value = max_date,
        value = min_date)  
    filter_max_date = st.slider(
        label = 'Select max_date',
        min_value =min_date,
        max_value = max_date,
        value = max_date)
    filter_card_type_selector = st.sidebar.selectbox(
      label = 'Choose a Card Type'
    , options = card_types
    )
    # masks
    mask_date = (payments_df.index >= pd.to_datetime(filter_min_date)) \
        & (payments_df.index <= pd.to_datetime(filter_max_date))
    mask_type = ((filter_card_type_selector == 'Any') | (payments_df['CARD_TYPE'] == filter_card_type_selector))
    mask = mask_date & mask_type

    # df
    payments_df_filtered = payments_df.loc[mask] 
    payments_df_filtered_grouped = payments_df_filtered.groupby(['PAYMENT_WEEK'])['AMOUNT_SPENT'].sum()

    # charts
    st.line_chart(data=payments_df_filtered_grouped)

app_creation() # The function above is now invoked.