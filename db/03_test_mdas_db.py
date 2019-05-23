import psycopg2

# Connect to the database and open a cursor for test queries
conn = psycopg2.connect(
    host='mdas.c33zx3vjrof0.us-east-1.rds.amazonaws.com',
    user='mdas',
    password='mdaspassword',
    dbname='mdas')
cur = conn.cursor()

# We should have companies
cur.execute("SELECT count(*) FROM Company")
[[result]] = cur.fetchall()
assert result > 0

# We should have CIKs
cur.execute("SELECT count(*) FROM CIK")
[[result]] = cur.fetchall()
assert result > 0

# Every CIK record should have a Company that exists in the Company table
cur.execute("SELECT count(*) FROM CIK WHERE NOT COALESCE(Company IN (SELECT name FROM company), FALSE)")
[[result]] = cur.fetchall()
assert result == 0

# We should have tickers
cur.execute("SELECT count(*) FROM CIK")
[[result]] = cur.fetchall()
assert result > 0

# Every Ticker record should have a Company that exists in the Company table
cur.execute("SELECT count(*) FROM ticker WHERE NOT COALESCE(Company IN (SELECT name FROM company), FALSE)")
[[result]] = cur.fetchall()
assert result == 0
