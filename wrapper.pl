
`perl gen-sector-company-list.pl > log.txt`;
`perl gen-industry-company-list.pl >> log.txt`;
`perl count_sic_freq.pl >> log.txt`;
`perl sector-name-sic-bucket-summary.pl >> log.txt`;
`perl Print_Sector_Industry_names.pl sec-sic-code-name.txt Sector 3 > sectors_top3_sic_words.csv`;
`perl Print_Sector_Industry_names.pl sec-sic-code-name.txt Industry 3 > industries_top3_sic_words.csv`;
`perl getSectorHighFreqSicNames.pl sec-sic-code-name.txt 3 > sector_names.csv`;
`perl industry-top3-similarity.pl industries_top3_sic_words.csv > industry_names.csv`;
