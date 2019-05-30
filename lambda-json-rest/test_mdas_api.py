#!/usr/bin/env python3

from requests import get

urls = '''https://2wdm1205e1.execute-api.us-east-1.amazonaws.com/DEV/companyinfo/Alphabet Inc.
https://2wdm1205e1.execute-api.us-east-1.amazonaws.com/DEV/companylist
https://2wdm1205e1.execute-api.us-east-1.amazonaws.com/DEV/companylist?sort=MarketCap&sortdir=DESC&limit=23&offset=0
https://2wdm1205e1.execute-api.us-east-1.amazonaws.com/DEV/competitorinfo-by-company/Alphabet%20Inc.
https://2wdm1205e1.execute-api.us-east-1.amazonaws.com/DEV/sectorindustryweights
https://2wdm1205e1.execute-api.us-east-1.amazonaws.com/DEV/industryweights-by-company/Alphabet%20Inc.
https://2wdm1205e1.execute-api.us-east-1.amazonaws.com/DEV/sectorweights-by-company/Alphabet%20Inc.
https://2wdm1205e1.execute-api.us-east-1.amazonaws.com/DEV/words-by-sector/Test%20Sector%20Name
https://2wdm1205e1.execute-api.us-east-1.amazonaws.com/DEV/words-by-industry/%20PIPE%20LINES%20and%20NATURAL%20GAS%20TRANSMISSION
https://2wdm1205e1.execute-api.us-east-1.amazonaws.com/DEV/detailedcompanylist?industry=%20PIPE%20LINES%20and%20NATURAL%20GAS%20TRANSMISSION
'''

# This particulare endpoint needs to be warmed up
get('https://2wdm1205e1.execute-api.us-east-1.amazonaws.com/DEV/companylist')

# Loop through all endpoints expecting successful HTTP returns from each
for url in urls.splitlines():
    print('Testing MDAS data API endpoint:', url)
    assert get(url).ok
