import re

txt =  ["SALE TRANSACTION","Purple","Josh", "SALE TRANSACT LUN"]

patterns = [".*oh.*", ".*TRANSACT.*"]

##counter = 0
for item in txt:
    for pat in patterns:
        x = re.findall(pat,item)
        if x:
            ans = txt[txt.index(item)]
            print(f"The answer is: {ans}")
        else:
            pass
    ##counter = counter + 1

## SALE TRANSACTION, SALE TRANSACT LUN