
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

## Insert statement to grab ingredients that are entered by a user, and then appended to the all ingredients table of the SQL database:
try:
    sql = '''INSERT INTO "MEP".a1_all_ingredients_purchased (generic_item_name, measurement_type, amount, unit, price, store) VALUES (%s, %s, %s, %s, %s, %s)'''
    sample = [('Pears', 'Unit', 6, 'Unit', 3.99, 'Shop Rite'), ('Apples', 'Unit', 6, 'Unit', 3.99, 'Shop Rite')]
    for row in sample:
        cur.execute(sql, row)
    conn.commit()
except psycopg2.Error as e:
    conn.rollback()
    print(f"Error inserting data: {e}")



cur.close()
conn.close()