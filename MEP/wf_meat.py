import requests
from curl_cffi import requests as cureq
from pydantic import BaseModel
from rich import print
import json

headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36"}

resp = cureq.get('https://www.wholefoodsmarket.com/_next/data/RBm2ElzM9pAyc9m4voxZ3/products/pantry-essentials.json?store=10565&category=pantry-essentials', headers=headers, impersonate='chrome')

print(resp.status_code)                 ## prints status code to determine if we are getting blocked or not. 
data0 = resp.json()                     ## Gets full JSON response
keys_list0 = list(data0.keys())         ## Lists layer 0 keys
print(keys_list0)                       ## prints results
data1 = data0['pageProps']              ## Data1 is all data within the pageProps key of layer0 dict
keys_list1 = list(data1.keys())         ## lists keys within layer1 data
print(keys_list1)                       ## prints results
data2 = data1['data']                   ## Data2 is all data within the data key of layer 1 dict
keys_list2 = list(data2.keys())         ## litsts keys within layer 2 data
print(keys_list2)                       ## prints results
data3 = data2['results']                ## Data3 is all data within the results key of layer 2 dict. This contains all the info we need.

for item in data3:                      ## For each item within Data3 which houses all of our items
    item_name = item['name']            ## item_name is the value associated with the name key
    item_price = item['regularPrice']   ## item_price is the value associated with the regularPrice key
    item_brand = item['brand']          ## item_brand is the value associated with the brand key
    print(item_name)                    ## print item name
    print(item_price)                   ## print item price

