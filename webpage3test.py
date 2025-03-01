import streamlit as st
import pandas as pd

import test_sql_connect                                                                         ## Connects to script pulling in SQL results
ref_list = test_sql_connect.results                                                             ## Organizes sql results in list.



items_list = []

for item in ref_list:
    if item[0] not in items_list:
        items_list.append(item[0])
    
##print(items_list)


st.header('Welcome to MEP!', divider='rainbow')                                                 ## Create header
st.subheader("Smarter. Quicker. Cheaper.")                                                      ## Create subheader

col1, col2 = st.columns([1,1])

col1.subheader("New ingredients being added every day!")
col2.metric(label = "New ingredients added today", value="14", delta="6")

## List of possible names
list = ['Josh', 'Emily', 'Matt', 'Anthony', 'Ruthie']                                           ## List of names
age = [29, 28, 30, 38, 5]                                                                       ## List of ages

df = pd.DataFrame(ref_list, columns = ['item','price','store'])                                 ## Create dataframe joining those lists
df_2 = df.pivot_table(index='item',columns='store',values='price', aggfunc='mean')
print(df_2)
##ref_list_piv = df.pivot(index='item',columns='store',values='price')                          ## This is what we use to pivot the table
##print(ref_list_piv)


##print(df)                                                                                       ## Print list to test


if 'f_list' not in st.session_state:                                                            ## Create session state variable to accept user inputs
    st.session_state.f_list = []

item = st.text_input('Search for an ingredient and press Enter')                                ## Text input for user adding inputs to session state list

if item in items_list:                                                                                ## Checks to see if user entry is in the list of pre-approved items.
    st.session_state.f_list.append(item)                                                        ## If yes append item to session state variable list and return message.
    st.success(f"'{item}' added to the list!")  
else:
    st.error(f"Sorry, we have no pricing information for '{item}'. Please check back tomorrow!")     ## If not, return error.



df_2.reset_index(inplace = True)                                                                ## Resetting index away from 'store'.
df_2 = df_2.loc[:, ['item','Giant', 'TJs', 'Whole foods', 'Costco', 'Safeway', 'Amazon', 'Binnys', 'Total Wine']]    
df_f = df_2[df_2['item'].isin(st.session_state.f_list)]                                    ## Our new dataframe only shows the rows that correspond to the items that the user input. 
print(df_f)


st.dataframe(df_f)                                                                              ## Show items in table below.


## This section will be meant to update data in the sql database. Have this update the ticker at the top of the page as well.

if 's_list' not in st.session_state:
    st.session_state.s_list = []

new_item = st.text_input('To add an item to the database type the following: item name, amount, unit, price, store and press Enter')
new_item_list = new_item.split(",")
st.write(new_item_list)

if len(new_item_list) == 5:
    st.success(f"'{new_item_list[0]}' added to the list! Thank you for helping us on our mission.")
else:
     st.error(f"Hmmm, it looks like some of the information was missing. Please try again.")



##df2 = pd.DataFrame({'Items':st.session_state.f_list}, {'Age':st.session_state.age_list})
##st.dataframe(df2)

print(st.session_state.s_list)