import streamlit as st
import pandas as pd
import os
from snowflake.snowpark.functions import col

# Check if we're using mock data
USE_MOCK_DATA = os.getenv("USE_MOCK_DATA", "false").lower() == "true"

# Load data
if USE_MOCK_DATA:
    # Load mock data from CSV
    data = pd.read_csv(os.path.join(os.getcwd(), "mock_data", "mock_data_orders.csv"))
    data2 = pd.read_csv(os.path.join(os.getcwd(), "mock_data", "customers.csv"))
else:
    # Use Streamlit's Snowflake connection
    cnx = st.connection("snowflake")
    session = cnx.session()

    # Fetch data from the orders table
    data = session.table("orders").select(col("order_number"), col("order_name")).to_pandas()
    data2 = session.table("customers").select(col("customer_id"), col("customer_name"), col("email")).to_pandas()

# Streamlit app
st.title("Orders Dashboard")
st.write("Here are the latest orders:")

# Display data
st.dataframe(data)

st.write("Here are the latest customers:")

# Display data
st.dataframe(data2)