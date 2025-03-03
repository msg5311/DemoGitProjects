## WS is working, however, due to how the webpage is set up, if an ingredient does not have a unit attached, it skews the order of the units, ingredients, amounts, etc. 

from bs4 import BeautifulSoup
import requests
import csv
import pandas as pd



def screp(url):

    headers_new = {"User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"}

    page_to_scrape = requests.get(url, headers=headers_new)
    print(page_to_scrape.status_code)
    soup = BeautifulSoup(page_to_scrape.text, "lxml")

    ##print(soup)

    recipe_title = soup.find("h1", attrs={"class":"entry-title"})
    recipe_title_clean = recipe_title.get_text()
    print(recipe_title_clean)


    names = []
    amounts = []
    units = []

    level_0 = soup.find('div', class_="wprm-recipe-ingredient-group")

    for row in level_0:
        ing_rows = soup.findAll('li', class_="wprm-recipe-ingredient")
        for row in ing_rows:
            n = row.find("span", attrs={"class":"wprm-recipe-ingredient-name"})
            a = row.find("span", attrs={"class":"wprm-recipe-ingredient-amount"})
            u = row.find("span", attrs={"class":"wprm-recipe-ingredient-unit"})
            
            if n:
                n = n.text.strip()
            else:
                n = ''
            names.append(n)
            
            if a:
                a = a.text.strip()
            else:
                a = ''
            a = amounts.append(a)

            if u:
                u = u.text.strip()
            else:
                u = ''
            u = units.append(u)

    ##print(units)

    df = pd.DataFrame({'ingredients': names, 'amount': amounts, 'unit': units})
    return df