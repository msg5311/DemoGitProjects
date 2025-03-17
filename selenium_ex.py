## WS is working, however, due to how the webpage is set up, if an ingredient does not have a unit attached, it skews the order of the units, ingredients, amounts, etc. 

from bs4 import BeautifulSoup
import requests
import csv
import pandas as pd
from fractions import Fraction
from selenium import webdriver
from selenium.webdriver.common.by import By


url = 'https://www.youtube.com/@JetsCentral/videos'



headers_new = {"User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"}

driver = webdriver.Chrome()
screp = driver.get(url)

##x_loc = '//*[@id="modal-store-finder"]/div/div/button'
driver.implicitly_wait(30)
##button = driver.find_element(By.XPATH,x_loc)
##button.click()
print("Bananas!")
tile_loc = '//*[@id="category-page-body"]/section/div/div[1]/a'
name_loc = './/*[@id="category-page-body"]/section/div/div[1]/a/div[2]/h2'
price_loc = './/*[@id="category-page-body"]/section/div/div[1]/a/div[2]/span[2]'

vid_loc = 'style-scope ytd-rich-item-renderer'
title_loc = './/*[@id="video-title"]'

videos = driver.find_elements(By.CLASS_NAME,'style-scope ytd-rich-item-renderer')
for v in videos:
    print(v.find_element(By.XPATH,title_loc).text)


##for video in videos:
##    title = video.find_element(By.XPATH,title_loc).text
    ##print(title)

print('Pumpkin!')