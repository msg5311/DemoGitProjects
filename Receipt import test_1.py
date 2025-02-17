
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
import numpy as np
import re

file_tag = '20250203'
file_path = f"/Users/mattgorka/00_Receipts/{file_tag}.tiff"
update_tag = ''
preprocess_path = f"/Users/mattgorka/00_Receipts/pre_process/{update_tag}{file_tag}.tiff"

img = cv2.imread(file_path)
filename = os.path.basename(f"/Users/mattgorka/00_Receipts/{file_tag}.tiff")


## invert image:
inverted_image = cv2.bitwise_not(img)
update_tag = 'invert'
cv2.imwrite(f"/Users/mattgorka/00_Receipts/pre_process/{update_tag}{file_tag}.tiff", inverted_image)

## Binarization:
def grayscale(gs_image):
    return (cv2.cvtColor(img, cv2.COLOR_BGR2GRAY))

gray_image = grayscale(img)
update_tag = 'gray'
cv2.imwrite(f"/Users/mattgorka/00_Receipts/pre_process/{update_tag}{file_tag}.tiff",gray_image)

thresh, im_bw = cv2.threshold(gray_image, 127, 255, cv2.THRESH_BINARY)                          ## Massively impacted by glare of the picture. Suggestion of 200 and 230 is worse. 
update_tag = 'bw'
cv2.imwrite(f"/Users/mattgorka/00_Receipts/pre_process/{update_tag}{file_tag}.tiff", im_bw)

## Noise removal:   This is completely optional based on the results. 
def noise_removal(nr_image):
    kernel = np.ones((1,1), np.uint8)
    nr_image - cv2.dilate(nr_image, kernel, iterations=1)
    kernel = np.ones((1,1), np.uint8)
    nr_image = cv2.erode(nr_image, kernel, iterations=1)
    nr_image = cv2.morphologyEx(nr_image, cv2.MORPH_CLOSE, kernel)
    nr_image = cv2.medianBlur(nr_image, 3)
    return (nr_image)

no_noise = noise_removal(im_bw)
cv2.imwrite(f"/Users/mattgorka/00_Receipts/pre_process/{update_tag}{file_tag}.tiff",no_noise)

## Erosion:
def thin_font(tf_image):
    tf_image = cv2.bitwise_not(tf_image)
    kernel = np.ones((2,2), np.uint8)
    tf_image = cv2.erode(tf_image, kernel, iterations=1)
    tf_image = cv2.bitwise_not(tf_image)
    return(tf_image)

eroded_image = thin_font(no_noise)
update_tag = 'thinfont'
cv2.imwrite(f"/Users/mattgorka/00_Receipts/pre_process/{update_tag}{file_tag}.tiff", eroded_image)

## Dilation:
def thick_font(tf_image):
    tf_image = cv2.bitwise_not(tf_image)
    kernel = np.ones((2,2), np.uint8)
    tf_image = cv2.dilate(tf_image, kernel, iterations=1)
    tf_image = cv2.bitwise_not(tf_image)
    return(tf_image)

dilated_image = thick_font(no_noise)
update_tag = 'thickfont'
cv2.imwrite(f"/Users/mattgorka/00_Receipts/pre_process/{update_tag}{file_tag}.tiff", dilated_image)

update_tag = 'thickfont'
img = cv2.imread(f"/Users/mattgorka/00_Receipts/pre_process/{update_tag}{file_tag}.tiff")                                       ## Update filename to whatever the last step is here.

## Rest of script:
txt = pytesseract.image_to_string(img, config=" --psm 6")
txt2 = txt.split('\n')                                                  ## Split all the text by the line break
##print(txt2)

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

file = open("reciept_export2.csv","a")                                   ## Creates a file receipt_export to receive the itemized list
rowcount = 0                                                            ## Initialize counter to zero
for row in open("reciept_export2.csv"):                                  ## Itterate through all rows in csv
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