from PIL import Image
import pytesseract
import cv2
import csv

img = cv2.imread('/Users/mattgorka/test3.tiff')

##img = cv2.resize(img, None, fx=2, fy=2)

##img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
##config = '--oem 3 --psm %d'

txt = pytesseract.image_to_string(img, config=" --psm 6")
txt2 = txt.split('\n')                                              ## Split all the text by the line break


list_aa = []
for item in txt2:
    list_aa.append(item)
    #print(item)

list_aa = list_aa[list_aa.index("SALE TRANSACTION")+1:]             ## Remove the data above sale transaction line
##print(list_aa)

## Find total cost of trip:
substring2 = "Balance"                                              ## Substring to search for
for item in list_aa:
    if substring2 in item:
        list_aa_total_index = list_aa.index(item)                   ## Index of total 
        list_aa_total = (list_aa[list_aa_total_index])              ## Total purchase amount line
    else:
        pass



## Find the number of items purchased:
substring = "Items"                                                 ## Substring to search for
for item in list_aa:
    if substring in item:
        list_aa_trans_index = list_aa.index(item)                   ## Index of substring in variable to be used later.
        print(list_aa[list_aa_trans_index])                         ## prints as a check
    else:
        pass


## Drop all items after the items in transaction
list_aa = list_aa[:list_aa_trans_index]                             ## Drops all items after the 'items in transaction' row


list_aaa = []                                                       ## Create an empty list final list
items = []                                                          ## Create an empty list for items 
prices = []                                                         ## Create empty list for prices
n = len(list_aa)
for val in range(n):
    a = list_aa[val].split('$')
    items.append(a[0])                                              ## value zero from this represents the item and is added to the items list
    prices.append(a[1])                                             ## value one from this represents the price and is added to the prices list
    #print(txt2[val].split('$'))
    list_aaa.append(a)                                              ## Appends 

file = open("reciept_export.csv","w")                               ## Creates a file receipt_export to receive the itemized list
writer = csv.writer(file)                                           ##

writer.writerow(["Item", "Price"])                                  ## Creates two columns, Item and Price for csv

for item, price, in zip(items, prices):                             ## Itterates over the two lists items, prices, and writes them into their respective columns
    print(item + " - " + price)
    writer.writerow([item, price])
file.close()                                                        ## 




##print(list_aaa)
##print(pytesseract.image_to_string(Image.open('/Users/mattgorka/TEST.png')))
## psm 4 is a very good option as is 6, 11 is okay.