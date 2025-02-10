from bs4 import BeautifulSoup
import requests
import csv

n = 0
while n <=30:


    page_to_scrape = requests.get("https://www.scrapethissite.com/pages/forms/?page_num=" + str(n))
    soup = BeautifulSoup(page_to_scrape.text, "html.parser")

    teams = soup.findAll("td", attrs={"class":"name"})
    years = soup.findAll("td", attrs={"class":"year"})
    wins = soup.findAll("td", attrs={"class":"wins"})
    losses = soup.findAll("td", attrs={"class":"losses"})



    ##for title in titles:
    ##    print(title.text)

    file_2 = open("scraped_teams.csv", "a")
    writer = csv.writer(file_2)

    if n == 0: 
        writer.writerow(["Team", "Year", "Wins", "Losses"]) 
        pass

    for team, year, win, loss in zip(teams, years, wins, losses):
        print(team.text.strip() + ": " + year.text.strip() + ", " + win.text.strip() + "-" + loss.text.strip())
        writer.writerow([team.text.strip(), year.text.strip(), win.text.strip(), loss.text.strip()])
    file_2.close()

    n = n + 1