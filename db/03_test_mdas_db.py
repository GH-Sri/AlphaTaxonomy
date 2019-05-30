#!/usr/bin/env python3

# Test creation of database, schema and tables.
# This script used to also test the presence and correctness of the initial
# company data that was loaded into tightly constrained relational DB tables.
# Now that the paradigm has shifted, AWS Glue handles the loading of data and
# relationships are not constrained until query time.  The only reason tables
# are even created ahead of time is to keep the data API endpoints from
# having hard failures before any data is loaded by Glue.
# The only thing left to test now is that the DB, schema and tables exist.

import psycopg2

# Connect to the database and open a cursor for test queries
conn = psycopg2.connect(
    host='mdas.c33zx3vjrof0.us-east-1.rds.amazonaws.com',
    user='mdas',
    password='mdaspassword',
    dbname='mdas')
# We should have a database we can connect to with the above info
cur = conn.cursor()
assert isinstance(cur, psycopg2.extensions.cursor)

# We should have a company_sector_industry_csv table
cur.execute("SELECT count(*) FROM Company_Sector_Industry_csv")
[[result]] = cur.fetchall()
assert isinstance(result, int)

# We should have a companylist_csv table
cur.execute("SELECT count(*) FROM companylist_csv")
[[result]] = cur.fetchall()
assert isinstance(result, int)

# We should have a competitors_csv table
cur.execute("SELECT count(*) FROM competitors_csv")
[[result]] = cur.fetchall()
assert isinstance(result, int)

# We should have a historicalstockpricedataallexchanges_csv table
cur.execute("SELECT count(*) FROM historicalstockpricedataallexchanges_csv")
[[result]] = cur.fetchall()
assert isinstance(result, int)

# We should have a industry_name_csv table
cur.execute("SELECT count(*) FROM industry_name_csv")
[[result]] = cur.fetchall()
assert isinstance(result, int)

# We should have a industry_weights_csv table
cur.execute("SELECT count(*) FROM industry_weights_csv")
[[result]] = cur.fetchall()
assert isinstance(result, int)

# We should have a industry_words_csv table
cur.execute("SELECT count(*) FROM industry_words_csv")
[[result]] = cur.fetchall()
assert isinstance(result, int)

# We should have a sector_name_csv table
cur.execute("SELECT count(*) FROM sector_name_csv")
[[result]] = cur.fetchall()
assert isinstance(result, int)

# We should have a sector_weights_csv table
cur.execute("SELECT count(*) FROM sector_weights_csv")
[[result]] = cur.fetchall()
assert isinstance(result, int)

# We should have a sector_words_csv table
cur.execute("SELECT count(*) FROM sector_words_csv")
[[result]] = cur.fetchall()
assert isinstance(result, int)

