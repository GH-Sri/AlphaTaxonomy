#!/bin/sh
# A quick summary of the purposes of the scripts: the first two generate 10 files and 100 files, respectively.  The files include the names of all companies in the sectors/industries and their SICs.  
# The count_sic_freq.pl is a script for generating ranked list of companies for the sectors/industries by the number of occurrences of their SICs.  
# The output include 110 files following the naming convention Sector/Industry##-sic-freq.txt. 
# In each file the percentages of all SICs are calculated and accumulated percentages are provided. 
# The script Print_Sector_Industry_names.pl is used to output the top 3 SIC text descriptions for each sector and industry 
# by using the information in the sec-sic-code-name.txt file, which I scraped from the web.  Finally the two scripts getSectorHighFreqSicNames.pl and 
# industry-top3-similarity.pl are used to produce sector names and industry names, respectively.  
# These two scripts used different algorithms. The sector name generation script getSectorHighFreqSicNames.pl includes a few basic grammar rules 
# to better organize the three highest-frequency words in SIC descriptions, while industry-top3-similarity.pl finds the two SIC text descriptions 
# that are most similar to each other among the top 3 SIC text descriptions for each industry.


PYTHON=python3

${PYTHON} gen_sector_company_list.py company_sector_industry.csv companylist.csv
${PYTHON} gen_industry_company_list.py company_sector_industry.csv companylist.csv
${PYTHON} count_sic_freq.py Sector
${PYTHON} count_sic_freq.py Industry
${PYTHON} sector_name_sic_bucket_summary.py
${PYTHON} Print_Sector_Industry_names.py sec-sic-code-name.txt Sector 3 > sectors_top3_sic_words.csv
${PYTHON} Print_Sector_Industry_names.py sec-sic-code-name.txt Industry 3 > industries_top3_sic_words.csv
${PYTHON} getSectorHighFreqSicNames.py sec-sic-code-name.txt 3 > sector_names.csv
${PYTHON} industry_top3_similarity.py industries_top3_sic_words.csv > industry_names.csv
