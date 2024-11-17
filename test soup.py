import requests
from bs4 import BeautifulSoup

url = 'https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue'
page = requests.get(url)

soup = BeautifulSoup(page.text, 'lxml')

# This identifies the first table object in the entire soupy text:
table_0 = soup.find_all('table')[0]
#table_0_other = soup.find_all('table', class_ = 'wikitable sortable')

# This finds all headers (th) within table_0 item which is defined above:
table_0_headers = table_0.find_all('th')
#print(table_0_headers)

# This cleans up the header names:
world_table_titles = [title.text.strip() for title in table_0_headers]
#print(world_table_titles)

column_data = table_0.find_all('tr')
#print(column_data)

import pandas as pd
df = pd.DataFrame(columns = world_table_titles)

# Cycle through and organize each table item into a container:
for row in column_data[1:]:
    row_data = row.find_all('td')
    individual_row_data = [data.text.strip() for data in row_data]
    #print(individual_row_data)

    length = len(df)
    df.loc[length] = individual_row_data
#print("Done!")

print(df)

df.to_csv(r'/Users/mattgorka/Desktop/AB_Projects/companies.csv')



#import pandas as pd
#df = pd.DataFrame(columns = world_table_titles)
#print(df)
#print('done!')