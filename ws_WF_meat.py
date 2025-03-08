## WS is working, however, due to how the webpage is set up, if an ingredient does not have a unit attached, it skews the order of the units, ingredients, amounts, etc. 

from bs4 import BeautifulSoup
import requests
import csv
import pandas as pd
from fractions import Fraction



url = 'https://www.wholefoodsmarket.com/products/meat'

headers_new = {"User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"}

page_to_scrape = requests.get(url, headers=headers_new)
print(page_to_scrape.status_code)
soup = BeautifulSoup(page_to_scrape.text, "lxml")

##print(soup)

recipe_title = soup.find_all("span", attrs={"class":"text-left bds--heading-5"})
for recipe in recipe_title:
    recipe_title_clean = recipe.get_text()
    ##print(recipe_title_clean)

level_0 = soup.findAll('div', class_='w-pie--product-tile__content')
##print(level_0)

## This is for item names:
for item in level_0:
    name = item.find('h2', class_='w-cms--font-body__sans-bold')

    ##print(name.text.strip())

## This is for sub category:
for item in level_0:
    sub = item.find('span', class_="w-cms--font-disclaimer")
    ##print(sub.text.strip())

## This is for price:
for item in level_0:
    price = item.find('span', class_="text-left bds--heading-5")
    price = price.encode_contents()
    print(price)










