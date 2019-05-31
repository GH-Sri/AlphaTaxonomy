# -*- coding: utf-8 -*-
"""
Created on Sun May 19 20:18:12 2019

@author: zkrakower001
"""

import os
import requests
import wikipediaapi
import pandas as pd
import time


################
################
### Section One: Getting a List of all Companies listed on NASDAQ

# Set up session
S = requests.Session()

# Wikpedia API URL (https://www.mediawiki.org/wiki/API:Main_page)
URL = "https://en.wikipedia.org/w/api.php"

# First we'll get a list object from Wikipedia for all Companies listed on NASDAQ
categories = ["Category:Companies listed on NASDAQ",
              "Category:Companies listed on the New York Stock Exchange",
              "Category:Companies listed on NYSE American" ]
wiki_list = []
got_all_wikis = False
pull = None
for category in categories:
    while got_all_wikis == False:
        if pull == None:
            PARAMS = {
                    'action': "query",
                    'list': "categorymembers",
                    'cmtitle': category,
                    'cmprop': "title|ids|sortkey|timestamp|type",
                    'cmlimit': 500,
                    'cmtype': "page",
                    'cmsort': "sortkey",
                    'cmdir': "asc",
                    'format': "json"
                    }
        elif pull.get('continue') == None: 
            PARAMS = None
        else:
            PARAMS = {
                    'action': "query",
                    'list': "categorymembers",
                    'cmtitle': category,
                    'cmprop': "title|ids|sortkey|timestamp|type",
                    'cmlimit': 500,
                    'cmtype': 'page',
                    'cmsort': "sortkey",
                    'cmdir': "asc",
                    'cmcontinue': pull['continue']['cmcontinue'],
                    'format': "json"
                    }
        if PARAMS == None:
            got_all_wikis = True
        else:
            R = S.get(url=URL, params=PARAMS)
            pull = R.json()
            for x in pull['query']['categorymembers']:
                x.update({'wikicategory': category})

            wiki_list = wiki_list + pull['query']['categorymembers']
    pull = None
    got_all_wikis = False


wiki_titles = {item['title'] for item in wiki_list}
wiki_pageid_dict = {item['title']:item['pageid'] for item in wiki_list} 
wiki_category_dict = {item['title']:item['wikicategory'] for item in wiki_list} 



################
################    
### Section Two: Pulling Page Contents for each Company listed on NASDAQ

# Setting up the Wikipedia API connection 
wiki_api = wikipediaapi.Wikipedia('en')

# I'll need to do some string joins to get each page's contents into a dataframe row
# Defining a function to join with a seperator...
def join_sep(iterator, seperator):
    it = map(str, iterator)
    seperator = str(seperator)
    string = next(it, '')
    for s in it:
        string += seperator + s
    return string

# Initiate wiki_data Dataframe
wiki_data = pd.DataFrame(
        index = list(wiki_titles), 
        columns = ["pageid", "title", "summary", "sections", "categories", "links", "backlinks"])


# Iterate through each Wikipedia page (by title) and retrieve contents from API
x_count = 0
t = time.time()
for x in wiki_titles:
    x_count = x_count + 1
    page_ = wiki_api.page( x )
    summary = page_.summary # a string
    sections = join_sep(page_.sections, "#|#|#") # a list collapsed to a string
    categories = join_sep(list(page_.categories), "#|#|#") # dict to list collapsed to string
    links = join_sep(list(page_.links), "#|#|#") # dict to list collapsed to string
    backlinks = join_sep(list(page_.backlinks), "#|#|#") # dict to list collapsed to string
    wiki_data.loc[ x ] = pd.Series({
            'pageid': wiki_pageid_dict.get(x),
            'title': x,
            'summary': summary,
            'sections': sections,
            'categories': categories,
            'links': links,
            'backlinks': backlinks})
    if (float(x_count) % 25) == 0:
        print("x.count ", x_count, " time elapsed: ", (time.time() - t))
        # Re-setting the Wikipedia API connection each (25) times to avoid timeout
        wiki_api = wikipediaapi.Wikipedia('en')


# Write to .json file...       
wiki_data.to_json(os.path.join(os.getcwd(), r'Wikipedia_Data.json'))           
           
    
