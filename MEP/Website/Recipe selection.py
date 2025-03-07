import streamlit as st
import pandas as pd

import pages.ws4 as ws4

st.title("This is page 3")

st.text("Copy and paste the URL of the recipe you would like to cook and we will build your grocery list for you.")

if 'url_list' not in st.session_state:
    st.session_state.url_list = []

df_f = pd.DataFrame(columns=['ingredients', 'amount', 'unit'])
df_final = pd.DataFrame(columns=['ingredients', 'unit', 'amount'])

url = st.text_input('Copy and paste the link to a recipe.')
if url:
    ##st.session_state.r_list.append(url)
    st.session_state.url_list.append(url)

    for link in st.session_state.url_list:
        a = ws4.screp(link)
        df_f = pd.concat([df_f, a], ignore_index=True)
        df_final = df_f.groupby(['ingredients', 'unit'])['amount'].sum()
        
st.dataframe(df_final)
    ##a = ws4.screp(url)
    ##st.session_state['df'] = pd.concat([st.session_state['df'], a], ignore_index=True)

##b = st.session_state['df'].groupby('ingredients')['amount'].sum()

##st.dataframe(st.session_state['df'].groupby('ingredients')['amount'].sum())




