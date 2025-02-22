
import psycopg2
import os
from dotenv import load_dotenv, find_dotenv

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

sql = '''SELECT * 
         FROM "MEP".a0_pantry
         WHERE measurement_type = 'Solid-weight'
         '''

cur.execute(sql)
results = cur.fetchall()

for row in results:
    print(row)

conn.commit()
cur.close()
conn.close()