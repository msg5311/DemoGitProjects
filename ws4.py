## WS is working, however, due to how the webpage is set up, if an ingredient does not have a unit attached, it skews the order of the units, ingredients, amounts, etc. 

from bs4 import BeautifulSoup
import requests
import csv

headers_new = {"User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"}

##r = requests.get('http://google.com')
r = requests.get('https://www.saltandlavender.com/marry-me-chicken/',headers=headers_new)
print(r.status_code)

page_to_scrape = requests.get("https://www.saltandlavender.com/marry-me-chicken/", headers=headers_new)
soup = BeautifulSoup(page_to_scrape.text, "lxml")

recipe_title = soup.find("h1", attrs={"class":"entry-title"})
recipe_title_clean = recipe_title.get_text()
print(recipe_title_clean)

ingredients = soup.findAll("span", attrs={"class":"wprm-recipe-ingredient-name"})
amounts = soup.findAll("span", attrs={"class":"wprm-recipe-ingredient-amount"})
units = soup.findAll("span", attrs={"class":"wprm-recipe-ingredient-unit"})
#notes = soup.findAll("span", attrs={"class":"wprm-recipe-ingredient-notes wprm-recipe-ingredient-notes-faded"})
#for item in ingredients:
#    print(item.get_text())

print(ingredients)

for unit in units:
    print(unit.text)

file_2 = open("scraped_countries.csv", "w")
writer = csv.writer(file_2)

writer.writerow(["Ingredient", "Amount", "Population", "Area"])

n = 0
for ingredient, amount, unit in zip(ingredients, amounts, units):
    print(n,ingredient.text.strip() + "-" + amount.text + "-" + unit.text + "-")
    writer.writerow([ingredient.text.strip(), amount.text, unit.text])
    n = n + 1
file_2.close()