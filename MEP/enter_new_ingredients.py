
import psycopg2
import os
from dotenv import load_dotenv, find_dotenv
import pandas as pd

load_dotenv(find_dotenv())

hostname = os.environ.get("DB_HOST")
database = os.environ.get("DB_NAME")
username = os.environ.get("DB_USER")
pwd = os.environ.get("DB_PWD")
port_id = os.environ.get("DB_PORTID")

conn = psycopg2.connect(
            host = hostname,
            dbname = database,
            user = username,
            password = pwd,
            port = port_id)

cur = conn.cursor()


try:
    sql = '''INSERT INTO "MEP".a1_all_ingredients_purchased (generic_item_name, measurement_type, amount, unit, price, store) VALUES (%s, %s, %s, %s, %s, %s)'''
    sample = ('Apples', 'Unit', 6, 'Unit', 3.99, 'Shop Rite')
    cur.execute(sql, sample)
    conn.commit()
except psycopg2.Error as e:
    conn.rollback()
    print(f"Error inserting data: {e}")
##results = cur.fetchall()

##for row in results:
##    print(row)

##df = pd.DataFrame(results)
##df.columns = ['item','price','store']

##df = df.groupby(['item','store'])['price'].mean()

##print(df)



cur.close()
conn.close()