
import psycopg2

hostname = 'localhost'
database = 'MEP'
username = 'postgres'
pwd = 'password'
port_id = 5432

conn = psycopg2.connect(
            host = hostname,
            dbname = database,
            user = username,
            password = pwd,
            port = port_id)

cur = conn.cursor()

sql = '''SELECT * FROM "MEP".a0_pantry'''

cur.execute(sql)
results = cur.fetchall()

for row in results:
    print(row)

conn.commit()
cur.close()
conn.close()