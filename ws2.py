from bs4 import BeautifulSoup
import requests
import csv

page_to_scrape = requests.get("https://www.scrapethissite.com/pages/simple/")
soup = BeautifulSoup(page_to_scrape.text, "html.parser")

countries = soup.findAll("h3", attrs={"class":"country-name"})
capitols = soup.findAll("span", attrs={"class":"country-capital"})
pops = soup.findAll("span", attrs={"class":"country-population"})
areas = soup.findAll("span", attrs={"class":"country-area"})

##for title in titles:
##    print(title.text)

file_2 = open("scraped_countries.csv", "w")
writer = csv.writer(file_2)

writer.writerow(["Country", "Capitol", "Population", "Area"])

for country, capitol, pop, area in zip(countries, capitols, pops, areas):
    print(country.text.strip() + "-" + capitol.text + "-" + pop.text + "-" + area.text)
    writer.writerow([country.text.strip(), capitol.text, pop.text, area.text])
file_2.close()