import streamlit as st
import pandas as pd

import test_sql_connect
ref_list = test_sql_connect.results

##print(ref_list)

st.header('Welcome to MEP!', divider='rainbow')
st.subheader("Smarter. Quicker. Cheaper.")

st.text("Cooking is an essential part of our lives. Our relationship to cooking and food impacts us in countless ways. \n Our goal is to equip you with some tools to make life easier and cheaper.")



if 'my_list' not in st.session_state:
    st.session_state.my_list = []

user_input = st.text_input("Movie title:")

if st.button("Add to list"):
    if user_input:
        st.session_state.my_list.append(user_input)
        st.success(f"'{user_input}' added to the list!")
    else:
        st.warning("Please enter a value before adding.")

st.write("The current movie title is:", user_input)
##st.write("Current list:"), st.session_state.my_list



df2 = pd.DataFrame(st.session_state.my_list, columns = ['Titles'])


st.dataframe(df2)

df3 = pd.DataFrame(ref_list, columns = ['item', 'price', 'store'])
st.dataframe(df3)

##x = [['a','b', 'c'], [1,2,3], [4,5,6]]
##df = pd.DataFrame(x, columns = ['col 1', 'col 2', 'col 3'])
##st.dataframe(df)