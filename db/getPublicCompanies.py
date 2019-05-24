#!/usr/bin/env python3

# Use the NASDAQ site links for csv download of publicly traded company data
# There isn't one link to download all companies A-Z; use links for NASDAQ, NYSE and AMEX
# SEC 10-Ks are our most important ML dataset so we need CIKs as well; scrape from SEC/Edgar

import os
import re
import csv
from io import StringIO
from requests import get
import boto3

# Amazon Keys for writing to S3 bucket
keyId = os.getenv('AWS_ACCESS_KEY_ID')
secretId = os.getenv('AWS_SECRET_ACCESS_KEY')

# Paramaterized URLs for getting the company data and the CIK pages
Company_URL = 'https://www.nasdaq.com/screening/companies-by-industry.aspx?exchange={}&render=download'
CIK_by_ticker_URL = 'https://www.sec.gov/cgi-bin/browse-edgar?ticker={}&Find=Search&owner=exclude&action=getcompany'
CIK_by_name_URL = 'https://www.sec.gov/cgi-bin/browse-edgar?company={}&owner=exclude&action=getcompany'

# And a regex to pull out the CIK number from the whole page contents
CIK_RE = re.compile(r'.*CIK=(?P<CIK>\d{10}).*')

out_lines = []

# Get the A-Z publicly traded company data from the three exchanges
for exchange in ('NASDAQ', 'NYSE', 'AMEX'):
    partial_list = get(Company_URL.format(exchange)).content.decode().splitlines()
    header = True

    for line in csv.reader(partial_list):
        # We want to add to each line so remove the empty element caused by the trailing commas
        del line[-1]
        if header:
            header = False
            if not out_lines:
                # If we're just starting capture headers adding headers for our additional data
                line.extend(('Exchange','CIK'))
            else:
                # Oherwise we already have headers; continue to the data lines
                continue
        else: # Not a header line

            # capture which exchange this ticker is traded on
            line.append(exchange)

            # Attempt to determine the CIK by ticker
            CIK = ''
            match = CIK_RE.search(get(CIK_by_ticker_URL.format(line[0])).content.decode())
            if not match:
                # Failed to find it by ticker, try by company name
                match = CIK_RE.search(get(CIK_by_name_URL.format(line[1])).content.decode())
            if match: CIK = match.group('CIK')
            line.append(CIK)

        out_lines.append(line)

# Prepare the data in CSV format as a string
with StringIO() as f:
    w = csv.writer(f)
    w.writerows(out_lines)

    # Write it all out to amazon S3 bucket so it can be ETLed into the Postgres DB
    s3 = boto3.resource('s3', aws_access_key_id=keyId, aws_secret_access_key=secretId)
    bucket = s3.Bucket(name='at-mdas-data')
    bucket.put_object(Key='Output-For-ETL/companylist.csv', Body=f.getvalue())
