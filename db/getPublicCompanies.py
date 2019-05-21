#!/usr/bin/env python3

# Use the NASDAQ site links for csv download of publicly traded company data
# There isn't one link to download all companies A-Z; use links for NASDAQ, NYSE and AMEX
# SEC 10-Ks are our most important ML dataset so we need CIKs as well; scrape from SEC/Edgar

import re
import csv
from requests import get
from time import sleep

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
            match = CIK_RE.search(get(CIK_by_ticker_URL.format(line[0])).content.decode())
            sleep(1)
            if not match:
                # Failed to find it by ticker, try by company name
                match = CIK_RE.search(get(CIK_by_name_URL.format(line[1])).content.decode())
                sleep(1)
            if match: line.append(match.group('CIK'))

        out_lines.append(line)

with open('companylist.csv', 'w', newline = '') as f:
    w = csv.writer(f)
    w.writerows(out_lines)
