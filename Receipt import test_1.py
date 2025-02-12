
## NOTES:
## print(pytesseract.image_to_string(Image.open('/Users/mattgorka/TEST.png')))
## psm 4 is a very good option as is 6, 11 is okay.
## Delimiting by $ is causing problems bc there are some receipts where the $ is faded out.
## Find way to adjust programatically or with the pre processing

from PIL import Image
import pytesseract
import cv2
import csv
import pandas as pd
import os

img = cv2.imread('/Users/mattgorka/00_Receipts/20230605.tiff')
filename = os.path.basename('/Users/mattgorka/00_Receipts/20230605.tiff')

##img = cv2.resize(img, None, fx=2, fy=2)

img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
##config = '--oem 3 --psm %d'

txt = pytesseract.image_to_string(img, config=" --psm 6")
txt2 = txt.split('\n')                                                  ## Split all the text by the line break
print(txt2)

list_aa = []
for item in txt2:
    list_aa.append(item)
    #print(item)

substring0 = "LE TRANSACTION"
for item in list_aa:
    if substring0 in item:
        list_aa_st_index = list_aa.index(item)
    else:
        pass

substring1 = "??-??-??"
for item in list_aa:
    if substring1 in item:
        list_aa_date_index = list_aa.index(item)
        date_final = list_aa[list_aa_date_index]
    else:
        pass


list_aa = list_aa[list_aa_st_index+1:]                 ## Remove the data above sale transaction line

## Find total cost of trip:
substring2 = "Balance"                                                  ## Substring to search for
for item in list_aa:
    if substring2 in item:
        list_aa_total_index = list_aa.index(item)                       ## Index of total 
        list_aa_total = (list_aa[list_aa_total_index])                  ## Total purchase amount line
    else:
        pass


## Find the number of items purchased:
substring = "n:"                                                     ## Substring to search for
for item in list_aa:
    if substring in item:
        list_aa_trans_index = list_aa.index(item)                       ## Index of substring in variable to be used later.
        trans_final = list_aa[list_aa_trans_index]
    else:
        pass


## Drop all items after the items in transaction
list_aa = list_aa[:list_aa_trans_index]                                 ## Drops all items after the 'items in transaction' row

list_aaa = []                                                           ## Create an empty list final list
items = []                                                              ## Create an empty list for items 
prices = []                                                             ## Create empty list for prices
n = len(list_aa)
for val in range(n):
    a = list_aa[val].replace('#','$').split('$')
    items.append(a[0])                                                  ## value zero from this represents the item and is added to the items list
    
    first_ele = a[1].replace('.','').replace(',','').replace(' ','')    ## Remove decimals or commas from price element.
    if len(first_ele) == 3:
        price_new = first_ele[0] + "." + first_ele[1:]
        prices.append(price_new)
    elif len(first_ele) == 4:
        price_new = first_ele[0:2] + "." + first_ele[2:]
        prices.append(price_new)
    else:
        print("Other")

    list_aaa.append(a)                                                  ## Appends 

file = open("reciept_export.csv","a")                                   ## Creates a file receipt_export to receive the itemized list
rowcount = 0                                                            ## Initialize counter to zero
for row in open("reciept_export.csv"):                                  ## Itterate through all rows in csv
    rowcount = rowcount + 1                                             ## Increase counter by one each time
writer = csv.writer(file)                                               ##

if rowcount == 0:                                                       ## If there are rows present in csv already, dont add headers, otherwise add headers.
    writer.writerow(["Item", "Price", "Filename"])                                  ## Creates two columns, Item and Price for csv
else:
    pass

for item, price, in zip(items, prices):                                 ## Itterates over the two lists items, prices, and writes them into their respective columns
    ##print(item + " - " + price)
    writer.writerow([item, price, filename])
file.close()                                                            ## 


print(f"Receipt upload complete. Here is a summary: \n {trans_final} \n {list_aa_total}")