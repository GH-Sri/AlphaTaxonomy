
`perl gen-sector-company-list.pl company_sector_industry.csv companylist.csv > log.txt`;
`perl gen-industry-company-list.pl company_sector_industry.csv companylist.csv >> log.txt`;
`perl count_sic_freq.pl Sector >> log.txt`;
`perl count_sic_freq.pl Industry >> log.txt`;
`perl Print_Sector_Industry_names.pl sec-sic-code-name.txt Sector 3 > sectors_top3_sic_words.csv`;
`perl Print_Sector_Industry_names.pl sec-sic-code-name.txt Industry 3 > industries_top3_sic_words.csv`;
`perl getSectorHighFreqSicNames.pl sec-sic-code-name.txt 3 > sector_name.csv`;
`perl industry-top3-similarity.pl industries_top3_sic_words.csv > industry_name.csv`;
