import streamlit as st
import pandas as pd

st.header('Welcome to MEP!', divider='rainbow')                                                 ## Create header
st.subheader("Smarter. Quicker. Cheaper.")                                                      ## Create subheader

## List of possible names
list = ['Josh', 'Emily', 'Matt', 'Anthony', 'Ruthie']                                           ## List of names
age = [29, 28, 30, 38, 5]                                                                       ## List of ages

df = pd.DataFrame({'name':list, 'age':age})                                                     ## Create dataframe joining those lists

print(df)                                                                                       ## Print list to test


if 'f_list' not in st.session_state:                                                            ## Create session state variable to accept user inputs
    st.session_state.f_list = []

item = st.text_input('Search for an ingredient and press Enter')                                ## Text input for user adding inputs to session state list

if item in list:                                                                                ## Checks to see if user entry is in the list of pre-approved items.
    st.session_state.f_list.append(item)                                                        ## If yes append item to session state variable list and return message.
    st.success(f"'{item}' added to the list!")  
else:
    st.error('Sorry, we have no pricing information on that item. Please check back soon!')     ## If not, return error.



df_f = df[df['name'].isin(st.session_state.f_list)]                                             ## Our new dataframe only shows the rows that correspond to the items that the user input. 
print(df_f)

st.dataframe(df_f)                                                                              ## Show items in table below.


##df2 = pd.DataFrame({'Items':st.session_state.f_list}, {'Age':st.session_state.age_list})
##st.dataframe(df2)

