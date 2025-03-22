import requests
from curl_cffi import requests as cureq
from pydantic import BaseModel
from rich import print
import json

headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36"}

resp = cureq.get('https://www.wholefoodsmarket.com/_next/data/RBm2ElzM9pAyc9m4voxZ3/products/meat.json?store=10565&category=meat', headers=headers, impersonate='chrome')

print(resp.status_code)
data0 = resp.json()
keys_list0 = list(data0.keys())
print(keys_list0)
data1 = data0['pageProps']
keys_list1 = list(data1.keys())
print(keys_list1)
data2 = data1['data']
keys_list2 = list(data2.keys())
print(keys_list2)
data3 = data2['results']

for item in data3:
    item_name = item['name']
    item_price = item['regularPrice']
    item_brand = item['brand']
    print(item_name)
    print(item_price)

